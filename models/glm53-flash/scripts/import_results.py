"""Export aggregate measurements; private input/log paths never enter the page data."""
import argparse
import csv
import hashlib
import json
from pathlib import Path

BATCHES = list(range(16, 129, 8))
LAYERS = list(range(3, 45))
STAGES = ('router', 'routed', 'shared', 'reduce')
GATES = ('router_cpu_reference_pass', 'shared_cpu_reference_pass',
         'reduce_cpu_exact', 'graph_two_replays', 'graph_changed_input',
         'routed_lut_reference_pass')


def read(path):
    return json.loads(path.read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def export(h200, zeus, out):
    summary = read(h200 / 'report/summary.json')
    assert summary['complete'] and summary['paired_inputs_per_batch'] == 56
    points = list(csv.DictReader((h200 / 'report/paired_inputs.csv').open()))
    selected = [p for p in points if p['group'] == 'train00' and int(p['step']) == 1]
    assert sorted(int(p['batch_size']) for p in selected) == BATCHES
    hrows = []
    for row in summary['summaries']['all']:
        bs = row['batch_size']
        point = next(p for p in selected if int(p['batch_size']) == bs)
        hrows.append(dict(batch_size=bs, batch_per_card=bs / 4,
                          mean_ms=row['mean_ms'], tokens_s_card=row['tokens_per_second_per_card'],
                          p10=row['workload_p10_tokens_per_second'] / 4,
                          p90=row['workload_p90_tokens_per_second'] / 4,
                          paired_ms=float(point['milliseconds']),
                          paired_tokens_s_card=float(point['total_tokens_per_second']) / 4))

    cases, failures, heads = {}, [], set()
    for p in sorted((zeus / 'stage1/cases').glob('*/result.json')):
        r = read(p)
        assert r['complete'] and all(r['validation'][k] is True for k in GATES), p
        key = (r['batch_size'], r['layer'], r['rank'])
        assert key not in cases and key[0] in BATCHES and key[1] in LAYERS and key[2] in range(16)
        assert (r['group'], r['step']) == ('train00', 1)
        identity = r['validation']['paired_identity']
        assert identity['plan_sha256'] == summary['plan_sha256']
        assert r['cycles'] == sum(r['stages'].values())
        assert all(isinstance(c, int) and c > 0 for c in r['stages'].values())
        cases[key] = r
        heads.add(r['source_commit'])
    assert len(heads) <= 1, 'Mixed source commits'
    for p in (zeus / 'stage1/cases').glob('*/status.json'):
        if read(p)['status'] == 'failed':
            failures.append(p.parent.name)

    zrows, layer_rows, analytic = [], [], []
    for bs in BATCHES:
        if not all((bs, layer, rank) in cases for layer in LAYERS for rank in range(16)):
            continue
        hpeers = [read(h200 / f'measurement/cases/bs{bs}-train00-step001-ep{rank}.json') for rank in range(4)]
        total, stage_totals = 0, dict.fromkeys(STAGES, 0)
        for index, layer in enumerate(LAYERS):
            peers = [cases[bs, layer, rank] for rank in range(16)]
            hashes = {r['validation']['paired_identity']['prefix_hidden_sha256'] for r in peers}
            hashes.update(p['layers'][index]['prefix_hidden_sha256'] for p in hpeers)
            assert len(hashes) == 1, f'Zeus/H200 inputs differ at BS{bs}/L{layer}'
            slow = max(peers, key=lambda r: r['cycles'])
            cycles = slow['cycles']
            total += cycles
            lr = dict(batch_size=bs, layer=layer, cycles=cycles, slowest_rank=slow['rank'])
            for stage in STAGES:
                # Independent stage maxima describe bottlenecks, not a serial critical path.
                value = max(r['stages'].get(stage, 0) for r in peers)
                stage_totals[stage] += value
                lr[stage + '_cycles'] = value
            layer_rows.append(lr)
            for r in peers:
                v = r['validation']
                if not v.get('analytic_synthetic_budget_pass', False) or not v['shared_analytic_error']['passed']:
                    analytic.append(dict(batch_size=bs, layer=layer, rank=r['rank'],
                        routed_budget_pass=v.get('analytic_synthetic_budget_pass'),
                        routed_relative_l2=v.get('analytic_relative_l2'),
                        routed_peak_error=v.get('analytic_peak_error'),
                        shared_budget_pass=v['shared_analytic_error']['passed']))
        zrows.append(dict(batch_size=bs, batch_per_card=bs / 4, cycles=total,
                          milliseconds=total / 400000, tokens_s_card=bs * 100000000 / total,
                          stages=stage_totals))
    result = dict(schema_version=1, updated='2026-11-02',
        protocol=dict(cards=4, layers=42, frequency_mhz=400, batches=BATCHES,
                      pair=dict(group='train00', step=1), zeus_ranks=16, zeus_cores=32,
                      aggregation='sum_layer(max_rank(sum_stage(sum_launch(max_core(cycles)))))'),
        h200=dict(complete=True, pairs=56, rows=hrows, selection=summary['selection'],
                  plan_sha256=summary['plan_sha256'], summary_sha256=digest(h200 / 'report/summary.json')),
        zeus=dict(complete=len(cases) == 10080 and not failures, cases=len(cases), total=10080,
                  failed_cases=failures, source_commit=next(iter(heads), None), rows=zrows,
                  analytic_budget_exceptions=analytic,
                  full56_status='pending', matched_input_hashes=True if zrows else None),
        toolchain=dict(triton_shared='4ec41039673c0c6afea9537f789b94d3e6137d6a',
                       triton='5321c2ebe470d2527078491642b136a13ab72c49',
                       cyclesim='6248b44d30bced522c8958029bce717d50640d43',
                       routed_sha256='dc2c684c0961dbf8f2903e5d9d5879f1de68c94c89380722294dea0f62f1b2d9'))
    out.mkdir(parents=True, exist_ok=True)
    (out / 'benchmark.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    if layer_rows:
        with (out / 'zeus-layers.csv').open('w', newline='') as stream:
            writer = csv.DictWriter(stream, fieldnames=list(layer_rows[0]))
            writer.writeheader()
            writer.writerows(layer_rows)
    with (out / 'throughput.csv').open('w', newline='') as stream:
        writer = csv.writer(stream)
        writer.writerow(['global_batch', 'batch_per_card', 'h200_56_tokens_s_card',
                         'h200_pair_tokens_s_card', 'zeus_pair_tokens_s_card', 'zeus_cycles'])
        for h in hrows:
            z = next((z for z in zrows if z['batch_size'] == h['batch_size']), {})
            writer.writerow([h['batch_size'], h['batch_per_card'], h['tokens_s_card'],
                             h['paired_tokens_s_card'], z.get('tokens_s_card', ''), z.get('cycles', '')])
    print(json.dumps(dict(zeus_cases=len(cases), completed_batches=len(zrows), failures=len(failures))))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--h200', type=Path, required=True)
    parser.add_argument('--zeus', type=Path, required=True)
    parser.add_argument('--out', type=Path, required=True)
    args = parser.parse_args()
    export(args.h200, args.zeus, args.out)
