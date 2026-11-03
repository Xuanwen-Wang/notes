"""Audit timing-only receipts and extend the independently qualified report."""
import argparse
import csv
import json
from pathlib import Path
import statistics

from import_results import BATCHES, LAYERS, STAGES, digest, export, read


def percentile(values, fraction):
    values=sorted(values)
    position=(len(values)-1)*fraction
    lower=int(position)
    return values[lower]+(values[min(lower+1,len(values)-1)]-values[lower])*(position-lower)


def extend(h200, baseline, timing, out):
    identity=read(timing/'full56/identity.json')
    completion=read(timing/'full56/complete.json')
    qualification=read(timing/'qualification.json')
    assert qualification['passed']
    assert identity['qualification_sha256']==digest(timing/'qualification.json')
    assert identity['binary_sha256']==qualification['binary_sha256']
    assert completion['cases']==completion['total']==564480 and not completion['failed']
    assert identity['total_cases']==564480 and identity['measurement_mode']=='timing_only'
    assert identity['layers']==LAYERS and len(identity['pairs'])==56
    pairs=[tuple(pair) for pair in identity['pairs']]
    assert len(set(pairs))==56
    points=list(csv.DictReader((h200/'report/paired_inputs.csv').open()))
    assert set(pairs)=={(p['group'],int(p['step'])) for p in points}
    splits={p['group']:p['split'] for p in points}
    plan=read(h200/'report/summary.json')['plan_sha256']
    aggregate={}
    count=0
    baseline_compared=0
    for layer in LAYERS:
        for rank in range(16):
            folder=timing/'full56'/f'layer{layer:02}-rank{rank:02}'
            receipt=read(folder/'complete.json')
            assert receipt['cases']==840 and receipt['records_sha256']==digest(folder/'records.jsonl')
            assert receipt['log_sha256']==digest(folder/'worker.log')
            assert receipt['weights_sha256']==digest(folder/'weights.json')
            assert receipt['zbin_sha256']
            for filename,sha in receipt['zbin_sha256'].items():
                assert digest(folder/filename)==sha
            seen=set()
            with (folder/'records.jsonl').open() as stream:
                for line in stream:
                    row=json.loads(line)
                    bs,group,step=row['batch_size'],row['group'],row['step']
                    key=(bs,group,step,layer)
                    assert (row['layer'],row['rank'])==(layer,rank)
                    assert bs in BATCHES and (group,step) in pairs and key not in seen
                    seen.add(key)
                    assert row['measurement_mode']=='timing_only' and row['numerical_validation']=='separate_full_mode'
                    assert row['paired_identity']['plan_sha256']==plan
                    expected={'router','routed','reduce'}|({'shared'} if rank<4 else set())
                    assert set(row['stages'])==expected and row['timing_markers']
                    for stage in row['stages'].values():
                        assert stage['cycles']==sum(x['cycles'] for x in stage['launches'])
                        assert all(x['gate_pass'] and len(x['core_cycles'])==2 and
                                   x['cycles']==max(x['core_cycles'].values()) for x in stage['launches'])
                    stages={s:r['cycles'] for s,r in row['stages'].items()}
                    assert row['cycles']==sum(stages.values()) and row['cycles']>0
                    if (group,step)==('train00',1):
                        base=read(baseline/'stage1/cases'/row['name']/'result.json')
                        assert stages==base['stages']
                        assert row['route_ids_sha256']==base['validation']['route_ids_sha256']
                        assert row['paired_identity']==base['validation']['paired_identity']
                        baseline_compared+=1
                    value=aggregate.setdefault(key,dict(cycles=0,ranks=0,stages=dict.fromkeys(STAGES,0),hashes=set()))
                    assert not value['ranks'] & (1<<rank)
                    value['ranks']|=1<<rank
                    value['cycles']=max(value['cycles'],row['cycles'])
                    value['hashes'].add(row['paired_identity']['prefix_hidden_sha256'])
                    for stage in STAGES:value['stages'][stage]=max(value['stages'][stage],stages.get(stage,0))
                    count+=1
            assert len(seen)==840
    assert count==564480 and baseline_compared==10080
    samples=[]
    for bs in BATCHES:
        for group,step in pairs:
            peers=[read(h200/f'measurement/cases/bs{bs}-{group}-step{step:03}-ep{r}.json') for r in range(4)]
            total=0
            stages=dict.fromkeys(STAGES,0)
            for index,layer in enumerate(LAYERS):
                value=aggregate[bs,group,step,layer]
                assert value['ranks']==65535
                hashes=value['hashes']|{r['layers'][index]['prefix_hidden_sha256'] for r in peers}
                assert len(hashes)==1,(bs,group,step,layer)
                total+=value['cycles']
                for stage in STAGES:stages[stage]+=value['stages'][stage]
            samples.append(dict(batch_size=bs,group=group,step=step,split=splits[group],cycles=total,
                milliseconds=total/400000,tokens_s_card=bs*1e8/total,stages=stages))
    rows=[]
    for bs in BATCHES:
        selected=[s for s in samples if s['batch_size']==bs]
        mean=statistics.mean(s['cycles'] for s in selected)
        rates=[s['tokens_s_card'] for s in selected]
        rows.append(dict(batch_size=bs,cycles=mean,milliseconds=mean/400000,tokens_s_card=bs*1e8/mean,
            p10=percentile(rates,.1),p90=percentile(rates,.9),
            stages={stage:statistics.mean(s['stages'][stage] for s in selected) for stage in STAGES}))
    train={bs:bs*1e8/statistics.mean(s['cycles'] for s in samples if s['batch_size']==bs and s['split']=='train') for bs in BATCHES}
    chosen=max(train,key=train.get)
    holdout={split:chosen*1e8/statistics.mean(s['cycles'] for s in samples if s['batch_size']==chosen and s['split']==split) for split in ('validation','test')}
    fields=['batch_size','group','step','split','cycles','milliseconds','tokens_s_card']
    with (out/'zeus-56-paired.csv').open('w',newline='') as stream:
        writer=csv.DictWriter(stream,fieldnames=fields,lineterminator='\n')
        writer.writeheader();writer.writerows({k:s[k] for k in fields} for s in samples)
    d=read(out/'benchmark.json')
    assert d['zeus']['source_commit']==identity['source_commit']
    d['updated']='2026-11-03'
    d['zeus']['full56_status']='complete'
    d['zeus56']=dict(complete=True,cases=count,pairs=56,rows=rows,source_commit=identity['source_commit'],
        measurement_mode='timing_only',numerical_validation='separate_full_mode',selected_batch_size=chosen,holdout=holdout,
        baseline_comparison_cases=baseline_compared,qualification_sha256=digest(timing/'qualification.json'),
        numerical_baseline_cases=10080,new_binary_numerical_cases=qualification['new_binary_full_cases'],
        mode_comparison_cases=qualification['timing_comparison_cases'],
        simulator_source=identity['simulator_source'],binary_sha256=identity['binary_sha256'],
        host_seconds=completion['total_elapsed_seconds'])
    d['toolchain']['cyclesim_full56']=identity['simulator_source']
    d['toolchain']['cyclesim_full56_binary_sha256']=identity['binary_sha256']
    (out/'benchmark.json').write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(dict(timing_cases=count,numerical_baseline_cases=10080,paired_hashes_matched=True)))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    for name in ('h200','baseline','timing','out'):parser.add_argument('--'+name,type=Path,required=True)
    args=parser.parse_args()
    export(args.h200,args.baseline,args.out)
    extend(args.h200,args.baseline,args.timing,args.out)
