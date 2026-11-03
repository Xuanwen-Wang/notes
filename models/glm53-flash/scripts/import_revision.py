"""Publish an audited retained-input kernel revision without relabeling old evidence."""
import argparse
import copy
import csv
from datetime import datetime
import json
import math
from pathlib import Path
import shutil
import statistics
from zoneinfo import ZoneInfo

from import_results import BATCHES, STAGES, digest, read
from sampling_policy import PAIR, percentile, rate, retained, selection, write_csv


def key(row):
    return int(row['batch_size']), row['group'], int(row['step'])


def close(a, b):
    assert math.isclose(float(a), float(b), rel_tol=1e-12, abs_tol=1e-9), (a, b)


def export_revision(baseline, evidence, out, ci=None):
    d = copy.deepcopy(read(baseline / 'benchmark.json'))
    identity, completion, qualification, comparison = [read(evidence / name) for name in
        ('identity.json', 'complete.json', 'qualification.json', 'comparison.json')]
    assert d['schema_version'] == 2
    assert comparison['passed'] and qualification['passed'] and not completion['failed']
    assert comparison['old_source_commit'] == d['zeus_population']['source_commit']
    assert identity['source_commit'] == qualification['source_commit'] == comparison['source_commit']
    assert identity['layers'] == list(range(3, 45))
    assert identity['measurement_mode'] == 'timing_only'
    assert identity['binary_sha256'] == qualification['binary_sha256']
    assert identity['scripts_sha256']['timing_campaign_worker.py'] == qualification['worker_sha256']
    assert identity['qualification_sha256'] == comparison['qualification_sha256'] == digest(evidence / 'qualification.json')
    assert comparison['campaign_identity_sha256'] == digest(evidence / 'identity.json')
    assert identity['plan_sha256'] == d['h200']['plan_sha256']
    assert comparison['aggregation'] == d['protocol']['aggregation']
    assert (comparison['cards'], comparison['ranks'], comparison['cores']) == (4, 16, 32)
    expected_cases = 49 * len(BATCHES) * 42 * 16
    assert completion['cases'] == completion['total'] == identity['total_cases'] == expected_cases
    assert comparison['cases'] == dict(baseline=expected_cases, candidate=expected_cases)
    assert completion['completed_shards'] == completion['total_shards'] == len(completion['rows']) == 672
    assert {(r['layer'], r['rank']) for r in completion['rows']} == {(l, r) for l in range(3, 45) for r in range(16)}
    assert all(r['cases'] == 49 * len(BATCHES) for r in completion['rows'])
    with (baseline / 'zeus-49-paired.csv').open() as stream:
        previous = {key(r): r for r in retained(list(csv.DictReader(stream)))}
    with (baseline / 'zeus-49-stages.csv').open() as stream:
        previous_stages = {key(r): r for r in retained(list(csv.DictReader(stream)))}
    points = {}
    for side in ('baseline', 'candidate'):
        selected = retained([r for r in comparison['samples'] if r['source'] == side])
        assert len(selected) == 735 and {key(r) for r in selected} == set(previous)
        points[side] = selected
        for r in selected:
            close(r['milliseconds'], r['cycles'] / 400000)
            close(r['tokens_s_card'], r['batch_size'] * 1e8 / r['cycles'])
            if side == 'baseline':
                close(r['cycles'], previous[key(r)]['cycles'])
                for stage in STAGES:
                    close(r['stages'][stage], previous_stages[key(r)][stage + '_cycles'])
            else:
                for stage in set(STAGES) - {'routed'}:
                    close(r['stages'][stage], previous_stages[key(r)][stage + '_cycles'])
            r['split'] = previous[key(r)]['split']
    pairs = {(r['group'], r['step']) for r in points['candidate']}
    assert pairs == {tuple(p) for p in identity['pairs']} == {tuple(p) for p in comparison['pairs']}
    zpoints = [{k: v for k, v in r.items() if k != 'source'} for r in points['candidate']]
    zrows = []
    assert [r['batch_size'] for r in comparison['rows']] == BATCHES
    for bs, audited in zip(BATCHES, comparison['rows']):
        zs = [r for r in zpoints if r['batch_size'] == bs]
        rates = [r['tokens_s_card'] for r in zs]
        row = dict(batch_size=bs, cycles=statistics.mean(r['cycles'] for r in zs),
            milliseconds=statistics.mean(r['milliseconds'] for r in zs), tokens_s_card=rate(zs, bs),
            p10=percentile(rates, .1), p90=percentile(rates, .9),
            stages={s: statistics.mean(r['stages'][s] for r in zs) for s in STAGES})
        for field in ('cycles', 'milliseconds', 'tokens_s_card'):
            close(row[field], audited['candidate'][field])
        for s in STAGES:
            close(row['stages'][s], audited['candidate']['stages'][s])
        zrows.append(row)
    # Current qualification is kept separate from the historical step001 gates.
    d['qualification']['current_full_mode'] = qualification
    if ci:
        ci_result = read(ci)
        assert ci_result['headSha'] == identity['source_commit']
        assert ci_result['status'] == 'completed' and ci_result['conclusion'] == 'success'
        d['qualification']['current_ci'] = ci_result
    d['zeus_population'] = dict(complete=True, cases=expected_cases, measured_cases=expected_cases,
        excluded_cases=0, pairs=49, rows=zrows, source_commit=identity['source_commit'],
        measurement_mode='timing_only', numerical_validation='separate_full_mode',
        evidence_type='qualified_retained_campaign', qualification_sha256=digest(evidence / 'qualification.json'),
        simulator_source=identity['simulator_source'], binary_sha256=identity['binary_sha256'],
        host_seconds=completion['total_elapsed_seconds'], host_seconds_scope='retained_49_point_campaign',
        workers=identity['workers'], complete_mode_cases=qualification['complete_mode_cases'],
        mode_comparison_cases=qualification['timing_comparison_cases'],
        regression_tests=qualification['integrated_regression_tests'], **selection(zpoints))
    paired = [dict(r, batch_per_card=r['batch_size'] / 4) for r in zpoints
              if r['group'] == PAIR['group'] and r['step'] == PAIR['step']]
    d['zeus'] = dict(complete=True, cases=10080, total=10080, rows=paired,
        source_commit=identity['source_commit'], measurement_mode='timing_only',
        numerical_validation='separate_full_mode', matched_input_hashes=True)
    d['toolchain'] = dict(triton_shared=identity['formal_source']['sources']['compiler'],
        triton=identity['formal_source']['sources']['triton'], cyclesim=identity['simulator_source'],
        cyclesim_binary_sha256=identity['binary_sha256'], routed_sha256=identity['formal_source']['routed_sha256'])
    d['updated'] = datetime.fromtimestamp(completion['updated_at'], ZoneInfo('Asia/Shanghai')).date().isoformat()
    d['provenance'] = dict(previous_public_benchmark_sha256=digest(baseline / 'benchmark.json'),
        comparison_sha256=digest(evidence / 'comparison.json'),
        identity_sha256=digest(evidence / 'identity.json'), completion_sha256=digest(evidence / 'complete.json'),
        qualification_sha256=digest(evidence / 'qualification.json'),
        paired_input_proof='All candidate inputs, Router IDs and weights match the independently H200-paired baseline',
        h200_paired_csv_sha256=digest(baseline / 'h200-49-paired.csv'))
    d['revision'] = dict(baseline_source=comparison['old_source_commit'], source=identity['source_commit'],
        paired_cases=expected_cases, rows=comparison['rows'])
    out.mkdir(parents=True, exist_ok=True)
    (out / 'benchmark.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    (out / 'routed-revision.json').write_text(json.dumps(d['revision'], indent=2) + '\n')
    shutil.copy2(baseline / 'h200-49-paired.csv', out / 'h200-49-paired.csv')
    write_csv(out / 'zeus-49-paired.csv', [{k: v for k, v in r.items() if k != 'stages'} for r in zpoints])
    write_csv(out / 'zeus-49-stages.csv', [dict(batch_size=r['batch_size'], group=r['group'], step=r['step'],
        split=r['split'], **{s + '_cycles': r['stages'][s] for s in STAGES}) for r in zpoints])
    write_csv(out / 'throughput.csv', [dict(batch_size=h['batch_size'], batch_per_card=h['batch_per_card'],
        h200_49_tokens_s_card=h['tokens_s_card'], zeus_49_tokens_s_card=z['tokens_s_card'],
        h200_train00_step017_tokens_s_card=h['paired_tokens_s_card'],
        zeus_train00_step017_tokens_s_card=p['tokens_s_card']) for h, z, p in zip(d['h200']['rows'], zrows, paired)])
    assert d['h200'] == read(baseline / 'benchmark.json')['h200']
    print(json.dumps(dict(cases=expected_cases, selection=selection(zpoints),
        best=max(zrows, key=lambda r: r['tokens_s_card'])), ensure_ascii=False))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('baseline', 'evidence', 'out'):
        parser.add_argument('--' + name, type=Path, required=True)
    parser.add_argument('--ci', type=Path)
    args = parser.parse_args()
    export_revision(args.baseline, args.evidence, args.out, args.ci)
