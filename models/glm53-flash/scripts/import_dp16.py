"""Import a complete DP16/parity campaign without relabeling the EP0 baseline."""
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

from dp16_report import STAGES
from import_results import BATCHES, digest, read
from import_revision import close, key
from sampling_policy import PAIR, percentile, rate, retained, selection, write_csv

FLOW = 'owner_router_shared_dp16_fp8_transport'


def export(args):
    baseline = read(args.baseline/'benchmark.json')
    identity, complete, summary, qualification = [read(args.evidence/name) for name in
        ('identity.json', 'complete.json', 'summary.json', 'qualification.json')]
    ci = read(args.ci)
    inherited = read(args.evidence/'inherited-validation.json')
    assert inherited['passed'] and inherited['source_commit'] == identity['source_commit']
    assert inherited['matched_source_files'] == 2264
    assert inherited['kernel_cases'] == qualification['regression_unique_cases'] == 700
    assert inherited['cpu_checks'] == qualification['cpu_checks'] == 90
    assert summary['passed'] and qualification['passed'] and not complete['failures']
    assert complete['cases'] == complete['total'] == summary['cases'] == 493920
    assert complete['completed_jobs'] == complete['total_jobs'] == len(summary['receipts']) == 672
    for filename, field in (('identity.json','identity_sha256'), ('complete.json','completion_sha256'),
                            ('qualification.json','qualification_sha256')):
        assert summary[field] == digest(args.evidence/filename), filename
    assert qualification['identity_sha256'] == summary['identity_sha256']
    assert qualification['source_commit'] == identity['source_commit'] == ci['headSha']
    assert identity['flow'] == summary['flow'] == FLOW
    assert identity['route_format'] == 'parity_masks' and identity['shared_layout'] == 'dp16'
    assert summary['stages'] == list(STAGES) and summary['matched_baseline_inputs_weights_cases'] == 493920
    assert summary['baseline_identity_sha256'] == baseline['provenance']['identity_sha256']
    assert summary['baseline_completion_sha256'] == baseline['provenance']['completion_sha256']
    assert qualification['full_mode_cases'] == qualification['timing_comparison_cases'] == 72
    assert qualification['equal_core_cycles'] > 0 and qualification['identical_binary_pairs'] > 0
    required = ('router_cpu_reference','router_full_batch_exact','shared_cpu_reference','routed_lut_reference',
                'reduce_exact','router_changed_input_graph','consumers_changed_input_graph')
    assert len(qualification['numerical']) == 72
    assert all(all(n['validation'][k] for k in required) for n in qualification['numerical'])
    with (args.baseline/'zeus-49-paired.csv').open() as stream:
        previous = {key(r):r for r in retained(list(csv.DictReader(stream)))}
    points = copy.deepcopy(retained(summary['samples']))
    assert {key(r) for r in points} == set(previous)
    for row in points:
        assert row['split'] == previous[key(row)]['split']
        assert set(row['stages']) == set(STAGES) and all(v > 0 for v in row['stages'].values())
        close(row['milliseconds'], row['cycles']/400000)
        close(row['tokens_s_card'], row['batch_size']*1e8/row['cycles'])
    rows = summary['rows']
    assert [r['batch_size'] for r in rows] == BATCHES
    for row in rows:
        selected = [p for p in points if p['batch_size'] == row['batch_size']]
        assert len(selected) == 49 and set(row['stages']) == set(STAGES)
        close(row['cycles'], statistics.mean(p['cycles'] for p in selected))
        close(row['milliseconds'], statistics.mean(p['milliseconds'] for p in selected))
        close(row['tokens_s_card'], rate(selected, row['batch_size']))
        for field, fraction in (('p10',.1),('p90',.9)):
            close(row[field], percentile([p['tokens_s_card'] for p in selected], fraction))
        for stage in STAGES:
            close(row['stages'][stage], statistics.mean(p['stages'][stage] for p in selected))
    d = copy.deepcopy(baseline)
    for field in ('revision','flow_revision','previous_revision'):
        d.pop(field, None)
    q = {k:qualification[k] for k in ('passed','source_commit','full_mode_cases','timing_comparison_cases',
        'equal_core_cycles','identical_binary_pairs','regression_unique_cases','cpu_checks','analytic_exceptions','numerical')}
    q['shared_analytic_exceptions'] = sum(not n['validation']['shared_analytic_error']['passed'] for n in q['numerical'])
    d['qualification'] = dict(historical_full_mode=baseline['qualification']['historical_full_mode'],
                             dp16_full_mode=q, current_ci=ci)
    d['protocol'].update(flow=FLOW, shared_layout='dp16', route_format='parity_masks', stages=list(STAGES),
        calibrated_sigmoid=True, aggregation=summary['aggregation'], stage_aggregation=summary['stage_aggregation'])
    d['zeus_population'] = dict(complete=True, cases=493920, measured_cases=493920, excluded_cases=0, pairs=49,
        rows=rows, source_commit=identity['source_commit'], pr_head=identity['source_commit'],
        measurement_mode='timing_only', numerical_validation='separate_full_mode',
        evidence_type='qualified_dp16_campaign', workers=complete['max_workers'], peak_workers=complete['peak_workers'],
        host_seconds=complete['seconds'], host_seconds_scope='complete_49_point_campaign', **selection(points))
    paired = [dict(r, batch_per_card=r['batch_size']/4) for r in points
              if r['group'] == PAIR['group'] and r['step'] == PAIR['step']]
    d['zeus'] = dict(complete=True, cases=10080, total=10080, rows=paired,
        source_commit=identity['source_commit'], measurement_mode='timing_only',
        numerical_validation='separate_full_mode', matched_input_hashes=True)
    compiler = [v for p,v in identity['files'].items() if p.endswith('/zeus-compiler')]
    simulator = [v for p,v in identity['files'].items() if p.endswith('/zeus3-sim_daemon')]
    assert len(simulator) == len(compiler) == 1
    d['toolchain'] = dict(torch_zeus_measured=identity['source_commit'], sglang=identity['sglang_commit'],
        triton_shared=identity['compiler_commit'], compiler_binary_sha256=compiler[0],
        cyclesim=identity['simulator_commit'], cyclesim_binary_sha256=simulator[0])
    d['updated'] = datetime.fromtimestamp(complete['updated_at'], ZoneInfo('Asia/Shanghai')).date().isoformat()
    d['publication'] = dict(pull_request_url='https://github.com/DarronTam/torch_zeus/pull/730')
    d['provenance'] = dict(previous_public_benchmark_sha256=digest(args.baseline/'benchmark.json'),
        summary_sha256=digest(args.evidence/'summary.json'), identity_sha256=summary['identity_sha256'],
        completion_sha256=summary['completion_sha256'], qualification_sha256=summary['qualification_sha256'],
        inherited_validation_sha256=digest(args.evidence/'inherited-validation.json'),
        matched_inputs_weights_cases=493920, router_id_changes_vs_baseline=summary['router_id_changes_vs_baseline'],
        router_weight_changes_vs_baseline=summary['router_weight_changes_vs_baseline'],
        h200_paired_csv_sha256=digest(args.baseline/'h200-49-paired.csv'))
    revision = dict(baseline_source=baseline['zeus_population']['source_commit'], source=identity['source_commit'],
        baseline_toolchain=baseline['toolchain'], paired_cases=493920,
        kind='dp16_fp8_transport_parity_and_toolchain', baseline_shared_layout='ep0_tp4', rows=[])
    for old, new in zip(baseline['zeus_population']['rows'], rows):
        bs = new['batch_size']
        assert old['batch_size'] == bs
        old_stage = dict(router_shared=old['stages']['router']+old['stages']['shared'],
                         routed=old['stages']['routed'], reduce=old['stages']['reduce'])
        stage_rates = {}
        for stage in STAGES:
            before, after = bs*1e8/old_stage[stage], bs*1e8/new['stages'][stage]
            stage_rates[stage] = dict(baseline=before,candidate=after,change_pct=(after/before-1)*100)
        revision['rows'].append(dict(batch_size=bs,baseline=old,candidate=new,stage_rates=stage_rates,
            throughput_change_pct=(new['tokens_s_card']/old['tokens_s_card']-1)*100))
    d['dp16_revision'] = revision
    encoded = json.dumps(d, ensure_ascii=False, indent=2)+'\n'
    assert not re.search(r'/data/wangxw|/mnt/disk|120\.209\.|172\.16\.|192\.168\.',encoded)
    args.out.mkdir(parents=True,exist_ok=True)
    (args.out/'benchmark.json').write_text(encoded)
    (args.out/'dp16-revision.json').write_text(json.dumps(revision,ensure_ascii=False,indent=2)+'\n')
    shutil.copy2(args.baseline/'h200-49-paired.csv',args.out/'h200-49-paired.csv')
    write_csv(args.out/'zeus-49-paired.csv',[{k:v for k,v in r.items() if k!='stages'} for r in points])
    write_csv(args.out/'zeus-49-stages.csv',[dict(batch_size=r['batch_size'],group=r['group'],step=r['step'],
        split=r['split'],**{s+'_cycles':r['stages'][s] for s in STAGES}) for r in points])
    write_csv(args.out/'throughput.csv',[dict(batch_size=h['batch_size'],batch_per_card=h['batch_per_card'],
        h200_49_tokens_s_card=h['tokens_s_card'],zeus_49_tokens_s_card=z['tokens_s_card'],
        h200_train00_step017_tokens_s_card=h['paired_tokens_s_card'],zeus_train00_step017_tokens_s_card=p['tokens_s_card'])
        for h,z,p in zip(d['h200']['rows'],rows,paired)])
    write_csv(args.out/'dp16-comparison.csv',[dict(batch_size=r['batch_size'],
        baseline_tokens_s_card=r['baseline']['tokens_s_card'],candidate_tokens_s_card=r['candidate']['tokens_s_card'],
        throughput_change_pct=r['throughput_change_pct'],
        **{s+'_'+k:v for s,values in r['stage_rates'].items() for k,v in values.items()}) for r in revision['rows']])
    assert d['h200'] == baseline['h200']
    print(json.dumps(dict(cases=493920,selection=selection(points),best=max(rows,key=lambda r:r['tokens_s_card']))))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('baseline','evidence','ci','out'):
        parser.add_argument('--'+name,type=Path,required=True)
    export(parser.parse_args())
