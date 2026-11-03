"""Apply the shared post-2026-11-03 performance population to audited results."""
import argparse
import csv
import json
from pathlib import Path
import statistics

from import_results import BATCHES, STAGES, digest, read

INCLUDED_STEPS = (17, 33, 49, 65, 81, 97, 113)
EXCLUDED_STEPS = (1,)
PAIR = dict(group='train00', step=17)


def retained(rows):
    """Reject missing or duplicate pairs before computing any public statistic."""
    groups = {r['group'] for r in rows}
    assert len(groups) == 7
    keys = [(int(r['batch_size']), r['group'], int(r['step'])) for r in rows]
    assert len(keys) == len(set(keys)), 'Duplicate input point'
    assert {key[2] for key in keys} <= set(INCLUDED_STEPS + EXCLUDED_STEPS)
    chosen = [r for r in rows if int(r['step']) not in EXCLUDED_STEPS]
    actual = {(int(r['batch_size']), r['group'], int(r['step'])) for r in chosen}
    assert actual == {(bs, group, step) for bs in BATCHES for group in groups
                      for step in INCLUDED_STEPS}, 'Incomplete retained population'
    return chosen


def percentile(values, fraction):
    values = sorted(values)
    position = (len(values) - 1) * fraction
    lo = int(position)
    return values[lo] + (values[min(lo + 1, len(values) - 1)] - values[lo]) * (position - lo)


def rate(rows, batch):
    # Equal-batch samples must pool elapsed time, not average reciprocal rates.
    return batch * 250 / statistics.mean(float(r['milliseconds']) for r in rows)


def selection(rows):
    train = {bs: rate([r for r in rows if int(r['batch_size']) == bs and r['split'] == 'train'], bs)
             for bs in BATCHES}
    chosen = max(train, key=train.get)
    return dict(selected_batch_size=chosen, selection_split='train',
                holdout={split: rate([r for r in rows if int(r['batch_size']) == chosen
                                     and r['split'] == split], chosen)
                         for split in ('validation', 'test')})


def write_csv(path, rows):
    with path.open('w', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator='\n')
        writer.writeheader()
        writer.writerows(rows)


def apply_policy(h200, out):
    d = read(out / 'benchmark.json')
    assert d['schema_version'] == 1, 'Apply once to the original audited export'
    raw = read(out / 'audited-timing-samples.json')
    zpoints = retained(raw)
    with (h200 / 'report/paired_inputs.csv').open() as stream:
        hpoints = retained(list(csv.DictReader(stream)))
    zkeys = {(r['batch_size'], r['group'], r['step'], r['split']) for r in zpoints}
    assert zkeys == {(int(r['batch_size']), r['group'], int(r['step']), r['split']) for r in hpoints}
    hrows, zrows = [], []
    for bs in BATCHES:
        hs = [r for r in hpoints if int(r['batch_size']) == bs]
        zs = [r for r in zpoints if r['batch_size'] == bs]
        hp = next(r for r in hs if r['group'] == PAIR['group'] and int(r['step']) == PAIR['step'])
        hrates = [bs * 250 / float(r['milliseconds']) for r in hs]
        hrows.append(dict(batch_size=bs, batch_per_card=bs / 4,
            mean_ms=statistics.mean(float(r['milliseconds']) for r in hs), tokens_s_card=rate(hs, bs),
            p10=percentile(hrates, .1), p90=percentile(hrates, .9),
            paired_ms=float(hp['milliseconds']), paired_tokens_s_card=bs * 250 / float(hp['milliseconds']),
            mean_active_experts=statistics.mean(float(r['mean_active_experts']) for r in hs)))
        zrates = [r['tokens_s_card'] for r in zs]
        zrows.append(dict(batch_size=bs, cycles=statistics.mean(r['cycles'] for r in zs),
            milliseconds=statistics.mean(r['milliseconds'] for r in zs), tokens_s_card=rate(zs, bs),
            p10=percentile(zrates, .1), p90=percentile(zrates, .9),
            stages={s: statistics.mean(r['stages'][s] for r in zs) for s in STAGES}))
    # Numerical qualification is historical step001 evidence, never step017 PASS.
    historical = d['zeus']
    qualification = {k: v for k, v in historical.items() if k not in ('rows', 'full56_status')}
    qualification['pair'] = d['protocol']['pair']
    d['qualification'] = dict(historical_full_mode=qualification)
    population = d.pop('zeus56')
    retained_cases = len(zpoints) * d['protocol']['layers'] * d['protocol']['zeus_ranks']
    measured_cases = len(raw) * d['protocol']['layers'] * d['protocol']['zeus_ranks']
    assert measured_cases == population['cases']
    population.update(measured_cases=measured_cases, excluded_cases=measured_cases - retained_cases,
                      cases=retained_cases, pairs=49, rows=zrows, **selection(zpoints))
    population['host_seconds_scope'] = 'original_56_point_campaign_including_step001'
    d['zeus_population'] = population
    paired = [dict(r, batch_per_card=r['batch_size'] / 4) for r in zpoints
              if r['group'] == PAIR['group'] and r['step'] == PAIR['step']]
    d['zeus'] = dict(complete=True, cases=10080, total=10080, rows=paired,
                    source_commit=historical['source_commit'], measurement_mode='timing_only',
                    numerical_validation='separate_full_mode', matched_input_hashes=True)
    d['h200'].update(pairs=49, rows=hrows, selection=selection(hpoints))
    d['schema_version'] = 2
    d['protocol']['pair'] = PAIR
    d['protocol']['sampling_policy'] = dict(effective_date='2026-11-03', excluded_steps=list(EXCLUDED_STEPS),
        included_steps=list(INCLUDED_STEPS), points_per_batch=49, request_groups=7,
        reason='User-directed protocol revision after inspecting early-step routing; not a capture-corruption finding',
        scope='all batches, both platforms, all splits; historical raw and numerical records retained')
    d['provenance'] = dict(audited_timing_samples_sha256=digest(out / 'audited-timing-samples.json'),
                           h200_original_points_sha256=digest(h200 / 'report/paired_inputs.csv'))
    (out / 'benchmark.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    write_csv(out / 'h200-49-paired.csv', hpoints)
    write_csv(out / 'zeus-49-paired.csv', [{k: v for k, v in r.items() if k != 'stages'} for r in zpoints])
    write_csv(out / 'zeus-49-stages.csv', [dict(batch_size=r['batch_size'], group=r['group'], step=r['step'],
        split=r['split'], **{s + '_cycles': r['stages'][s] for s in STAGES}) for r in zpoints])
    write_csv(out / 'throughput.csv', [dict(batch_size=h['batch_size'], batch_per_card=h['batch_per_card'],
        h200_49_tokens_s_card=h['tokens_s_card'], zeus_49_tokens_s_card=z['tokens_s_card'],
        h200_train00_step017_tokens_s_card=h['paired_tokens_s_card'],
        zeus_train00_step017_tokens_s_card=p['tokens_s_card']) for h, z, p in zip(hrows, zrows, paired)])
    print(json.dumps(dict(pairs=49, zeus_cases=retained_cases, h200_selection=d['h200']['selection'],
                          zeus_selection=selection(zpoints))))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--h200', type=Path, required=True)
    parser.add_argument('--out', type=Path, required=True)
    args = parser.parse_args()
    apply_policy(args.h200, args.out)
