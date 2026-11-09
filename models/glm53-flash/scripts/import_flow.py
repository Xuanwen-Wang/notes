"""Publish audited local-Router/direct-transport results and retain old evidence."""
import argparse
import copy
import csv
from datetime import datetime
import json
from pathlib import Path
import re
import shutil
import statistics
from zoneinfo import ZoneInfo

from import_results import BATCHES, STAGES, digest, read
from import_revision import close, key
from sampling_policy import PAIR, percentile, rate, retained, selection, write_csv


def export_flow(args):
    """Consume the private raw-record audit; never reinterpret timing as numeric PASS."""
    baseline = read(args.baseline / 'benchmark.json')
    d = copy.deepcopy(baseline)
    identity, complete, summary = [read(args.evidence / name) for name in
                                   ('identity.json', 'complete.json', 'summary.json')]
    q, numerical, regression, source, equivalent, toolchain, ci = [read(p) for p in
        (args.qualification, args.numerical, args.regression, args.source,
         args.equivalence, args.toolchain, args.ci)]
    assert summary['passed'] and q['passed'] and not complete['failed']
    for name, field in (('identity.json', 'identity_sha256'), ('complete.json', 'completion_sha256')):
        assert summary[field] == digest(args.evidence / name)
    assert summary['qualification_sha256'] == identity['qualification_sha256'] == digest(args.qualification)
    assert identity['files'] == q['files']
    assert q['evidence_sha256']['committed-source.json'] == digest(args.source)
    assert q['evidence_sha256']['qualification-comparison.json'] == digest(args.numerical)
    regression_key = 'regression/complete.json' if args.kernel_revision else 'regression-v7/complete.json'
    assert q['evidence_sha256'][regression_key] == digest(args.regression)
    assert all(q['files'][path] == value for path, value in source['files'].items())
    assert source['torch_zeus'] == q['source_commit']
    assert source['sglang'] == q['sglang_commit']
    if args.router_reuse:
        from router_reuse import audit_reuse
        assert args.kernel_revision
        equivalence = audit_reuse(args.router_reuse, equivalent, q, toolchain)
        equivalence['proof_sha256'] = digest(args.equivalence)
    else:
        assert source['torch_zeus'] == equivalent['old_head']
        assert all(path.endswith('.md') for path in equivalent['documentation_edits'])
        equivalence = dict(measured_source=equivalent['old_head'], pr_head=equivalent['clean_head'],
            identical_files=len(equivalent['identical_files']), proof_sha256=digest(args.equivalence),
            executable_changes=False)
    pr_head = equivalence['pr_head']
    assert ci['headSha'] == pr_head
    compiler = identity.get('compiler') or identity['toolchain']['compiler']
    assert compiler == toolchain['triton_shared']
    for suffix, value in toolchain['files'].items():
        assert [v for p, v in q['files'].items() if p.endswith('/triton/' + suffix)] == [value]
    assert [v for p, v in q['files'].items() if p.endswith('/zeus3-sim_daemon')] == [toolchain['simulator_sha256']]
    assert identity['flow'] == q['flow'] == summary['flow'] == 'owner_router_direct_transport'
    assert identity['calibrated_sigmoid'] and q['calibrated_sigmoid'] and summary['calibrated_sigmoid']
    assert identity['measurement_mode'] == complete['mode'] == 'timing_only'
    assert identity['batch_sizes'] == BATCHES and not identity['separate_batches']
    assert identity['shards'] == [[layer, rank] for layer in range(3, 45) for rank in range(16)]
    cases = 49 * len(BATCHES) * 42 * 16
    assert identity['total'] == complete['cases'] == complete['total'] == summary['cases'] == cases
    assert summary['matched_baseline_inputs_weights_cases'] == cases
    assert complete['completed_shards'] == complete['total_shards'] == len(complete['rows']) == 672
    assert all(row['cases'] == 735 for row in complete['rows'])
    assert q['full_mode_cases'] == q['timing_comparison_cases'] == len(numerical) == 45
    assert regression['count'] == regression['passed'] == q['regression_unique_cases']
    assert regression['count'] >= 361
    if args.kernel_revision:
        assert len(set(regression['collected_nodes'])) == regression['count']
        assert {r['node'] for r in regression['rows']} == set(regression['collected_nodes'])
    for row in numerical:
        assert row['cycles_equal'] and row['input_weights_router_equal']
        gates = row['numerical']
        assert all(gates[k] for k in ('router_cpu_reference', 'router_full_batch_exact',
            'routed_lut_reference', 'reduce_exact', 'router_changed_input_graph', 'consumers_changed_input_graph'))
        if int(row['name'].rsplit('rank', 1)[1]) < 4:
            assert gates['shared_cpu_reference']
    with (args.baseline / 'zeus-49-paired.csv').open() as stream:
        previous = {key(r): r for r in retained(list(csv.DictReader(stream)))}
    points = copy.deepcopy(retained(summary['samples']))
    assert {key(r) for r in points} == set(previous)
    assert {(r['group'], r['step']) for r in points} == {tuple(p) for p in identity['pairs']}
    for row in points:
        close(row['milliseconds'], row['cycles'] / 400000)
        close(row['tokens_s_card'], row['batch_size'] * 1e8 / row['cycles'])
        row['split'] = previous[key(row)]['split']
    assert [r['batch_size'] for r in summary['rows']] == BATCHES
    for row in summary['rows']:
        selected = [p for p in points if p['batch_size'] == row['batch_size']]
        assert len(selected) == 49
        close(row['cycles'], statistics.mean(p['cycles'] for p in selected))
        close(row['milliseconds'], statistics.mean(p['milliseconds'] for p in selected))
        close(row['tokens_s_card'], rate(selected, row['batch_size']))
        for field, fraction in (('p10', .1), ('p90', .9)):
            close(row[field], percentile([p['tokens_s_card'] for p in selected], fraction))
        for stage in STAGES:
            close(row['stages'][stage], statistics.mean(p['stages'][stage] for p in selected))
    # Only allowlisted fields enter the public export: private receipts contain server paths.
    current = {k: q[k] for k in ('passed', 'source_commit', 'sglang_commit', 'full_mode_cases',
        'timing_comparison_cases', 'regression_unique_cases', 'flow', 'calibrated_sigmoid',
        'numerical_validation', 'dependency_contract')}
    current['analytic_budget_exceptions'] = [r for r in numerical
        if not r['numerical']['analytic_synthetic_budget_pass']]
    current['numerical_cases'] = numerical
    d['qualification']['current_full_mode'] = current
    d['qualification']['current_ci'] = ci
    d['qualification']['source_equivalence'] = equivalence
    d['protocol'].update(aggregation=summary['aggregation'], flow=summary['flow'],
        calibrated_sigmoid=True, stage_aggregation=summary['stage_aggregation'])
    d['zeus_population'] = dict(complete=True, cases=cases, measured_cases=cases, excluded_cases=0,
        pairs=49, rows=summary['rows'], source_commit=q['source_commit'], pr_head=pr_head,
        measurement_mode='timing_only', numerical_validation='separate_full_mode',
        evidence_type='qualified_owner_router_campaign', host_seconds=summary.get('host_seconds', complete['seconds']),
        workers=complete['workers'], host_seconds_scope='retained_49_point_campaign_including_recovery', **selection(points))
    paired = [dict(r, batch_per_card=r['batch_size'] / 4) for r in points
              if r['group'] == PAIR['group'] and r['step'] == PAIR['step']]
    d['zeus'] = dict(complete=True, cases=10080, total=10080, rows=paired,
        source_commit=q['source_commit'], measurement_mode='timing_only',
        numerical_validation='separate_full_mode', matched_input_hashes=True)
    d['toolchain'] = dict(torch_zeus_measured=q['source_commit'], torch_zeus_pr_head=pr_head,
        sglang=q['sglang_commit'], triton_shared=toolchain['triton_shared'], triton=toolchain['triton'],
        cyclesim=toolchain['simulator'], cyclesim_binary_sha256=toolchain['simulator_sha256'])
    d['updated'] = datetime.fromtimestamp(complete['updated_at'], ZoneInfo('Asia/Shanghai')).date().isoformat()
    d['provenance'] = dict(previous_public_benchmark_sha256=digest(args.baseline / 'benchmark.json'),
        summary_sha256=digest(args.evidence / 'summary.json'), identity_sha256=summary['identity_sha256'],
        completion_sha256=summary['completion_sha256'], qualification_sha256=digest(args.qualification),
        source_equivalence_sha256=digest(args.equivalence), matched_inputs_weights_cases=cases,
        h200_paired_csv_sha256=digest(args.baseline / 'h200-49-paired.csv'))
    if summary.get('infrastructure_recovery'):
        d['provenance']['infrastructure_recovery'] = summary['infrastructure_recovery']
    if args.kernel_revision:
        assert summary['router_id_changes_vs_pr643'] == summary['router_weight_changes_vs_pr643'] == 0
        assert re.fullmatch(r'https://github.com/DarronTam/torch_zeus/pull/\d+', args.pr_url)
        d['publication'] = dict(pull_request_url=args.pr_url)
        d['provenance'].update(router_id_changes_vs_pr643=0, router_weight_changes_vs_pr643=0,
            paired_input_proof='All retained activation, weight, Router ID and routing-weight identities matched the archived PR643 baseline')
    else:
        d['provenance'].update(router_id_changes_vs_accurate_baseline=summary['router_id_changes_vs_accurate_baseline'],
            paired_input_proof='All retained activation and weight identities matched; Router IDs may differ')
    # Kernel and compiler revisions are a whole-stack comparison, not a
    # single-kernel attribution; the archived baseline is never relabeled.
    d.pop('revision', None)
    d['flow_revision'] = dict(baseline_source=baseline['zeus_population']['source_commit'],
        source=q['source_commit'], paired_cases=cases, fixed_router_ab=bool(args.kernel_revision),
        kind='automatic_pe_and_compiler' if args.router_reuse else
             'four_kernel_and_compiler' if args.kernel_revision else 'owner_router_flow', rows=[])
    for old, new in zip(baseline['zeus_population']['rows'], summary['rows']):
        assert old['batch_size'] == new['batch_size']
        d['flow_revision']['rows'].append(dict(batch_size=new['batch_size'], baseline=old, candidate=new,
            throughput_increase_pct=(new['tokens_s_card'] / old['tokens_s_card'] - 1) * 100,
            stage_cycles_change_pct={s: (new['stages'][s] / old['stages'][s] - 1) * 100 for s in STAGES}))
    if args.previous_baseline:
        previous_data = read(args.previous_baseline / 'benchmark.json')
        assert previous_data['h200'] == d['h200']
        assert [r['batch_size'] for r in previous_data['zeus_population']['rows']] == BATCHES
        d['previous_revision'] = dict(source=previous_data['zeus_population']['source_commit'], rows=[])
        for old, new in zip(previous_data['zeus_population']['rows'], summary['rows']):
            assert old['batch_size'] == new['batch_size']
            d['previous_revision']['rows'].append(dict(batch_size=new['batch_size'],
                baseline_tokens_s_card=old['tokens_s_card'], candidate_tokens_s_card=new['tokens_s_card'],
                throughput_change_pct=(new['tokens_s_card'] / old['tokens_s_card'] - 1) * 100))
    encoded = json.dumps(d, ensure_ascii=False, indent=2) + '\n'
    assert not re.search(r'/data/wangxw|/mnt/disk|120\.209\.|172\.16\.|192\.168\.', encoded)
    args.out.mkdir(parents=True, exist_ok=True)
    (args.out / 'benchmark.json').write_text(encoded)
    (args.out / 'flow-revision.json').write_text(json.dumps(d['flow_revision'], indent=2) + '\n')
    if args.previous_baseline:
        write_csv(args.out / 'previous-revision-comparison.csv', d['previous_revision']['rows'])
    shutil.copy2(args.baseline / 'h200-49-paired.csv', args.out / 'h200-49-paired.csv')
    write_csv(args.out / 'zeus-49-paired.csv', [{k: v for k, v in r.items() if k != 'stages'} for r in points])
    write_csv(args.out / 'zeus-49-stages.csv', [dict(batch_size=r['batch_size'], group=r['group'], step=r['step'],
        split=r['split'], **{s + '_cycles': r['stages'][s] for s in STAGES}) for r in points])
    write_csv(args.out / 'throughput.csv', [dict(batch_size=h['batch_size'], batch_per_card=h['batch_per_card'],
        h200_49_tokens_s_card=h['tokens_s_card'], zeus_49_tokens_s_card=z['tokens_s_card'],
        h200_train00_step017_tokens_s_card=h['paired_tokens_s_card'],
        zeus_train00_step017_tokens_s_card=p['tokens_s_card']) for h, z, p in zip(d['h200']['rows'], summary['rows'], paired)])
    write_csv(args.out / 'flow-comparison.csv', [dict(batch_size=r['batch_size'],
        baseline_tokens_s_card=r['baseline']['tokens_s_card'], candidate_tokens_s_card=r['candidate']['tokens_s_card'],
        throughput_increase_pct=r['throughput_increase_pct'], **{s + '_cycles_change_pct': r['stage_cycles_change_pct'][s]
                                                                  for s in STAGES}) for r in d['flow_revision']['rows']])
    assert d['h200'] == baseline['h200']
    print(json.dumps(dict(cases=cases, selection=selection(points),
        best=max(summary['rows'], key=lambda r: r['tokens_s_card'])), ensure_ascii=False))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('baseline', 'evidence', 'qualification', 'numerical', 'regression', 'source',
                 'equivalence', 'toolchain', 'ci', 'out'):
        parser.add_argument('--' + name, type=Path, required=True)
    parser.add_argument('--kernel-revision', action='store_true',
        help='Compare the four-kernel revision against archived PR643 with unchanged Router IDs')
    parser.add_argument('--pr-url', default='https://github.com/DarronTam/torch_zeus/pull/643')
    parser.add_argument('--router-reuse', type=Path,
        help='Audited compact Router evidence; explicitly retain the ordinary-layout measured identity')
    parser.add_argument('--previous-baseline', type=Path,
        help='Optional previous public revision, separate from the fixed PR643 comparison')
    export_flow(parser.parse_args())
