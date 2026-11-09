"""Validate compact-Router sampling without relabeling the full measurement."""
import json
from pathlib import Path

from import_results import BATCHES, digest, read


def audit_reuse(root, source, measured, toolchain):
    # Compact changes executable code: sampled equivalence is narrower than
    # source equivalence and must stay explicit in every public receipt.
    assert source['measured_source'] == measured['source_commit']
    assert source['same_consumer_kernels_as_measurement']
    changed = source['changed_since_full_matrix']
    assert sorted(Path(p).name for p in changed) == [
        'README.md', 'flow_worker.py', 'sgl_moe_router_linear_biased_topk.py']
    for path, value in source['kernel_files_sha256'].items():
        if path in changed:
            continue
        matching = [v for p, v in measured['files'].items() if p.endswith('/' + path)]
        if path.endswith('.py'):
            assert matching == [value], path
    probes = sorted((root / 'fixed/probe-v2').glob('*/complete.json'))
    assert len(probes) == 3
    keys, receipts = set(), []
    for path in probes:
        receipt = read(path)
        identity_path, records_path = path.parent / 'identity.json', path.parent / 'records.jsonl'
        assert receipt['passed'] and receipt['cases'] == 90
        assert receipt['identity_sha256'] == digest(identity_path)
        assert receipt['records_sha256'] == digest(records_path)
        identity = read(identity_path)
        assert identity['compiler_sha256'] == toolchain['files']['tools/zeus_bin/zeus-compiler']
        assert identity['simulator_sha256'] == toolchain['simulator_sha256']
        for name, value in identity['moe_sources'].items():
            assert source['kernel_files_sha256']['sgl-kernel-zeus-triton/python/' + name] == value
        rows = [json.loads(line) for line in records_path.read_text().splitlines()]
        assert len(rows) == receipt['cases']
        for row in rows:
            key = row['layer'], row['slot'], row['group'], row['step'], row['batch_size']
            assert key not in keys
            keys.add(key)
            assert row['numerical_equal'] and row['batch_size'] in BATCHES
            assert row['ordinary_change_cycles'] == row['compact_change_cycles'] == 0
            assert row['ordinary']['cycles'] == row['compact']['cycles'] == row['archived_cycles']
        receipts.append(digest(path))
    assert len(keys) == source['router_cycles_equal_probes'] == 270
    full = root / 'compact/qualification-full'
    qualification = read(full / 'complete.json')
    assert qualification['passed'] and qualification['cases'] == len(qualification['rows']) == 45
    assert qualification['identity_sha256'] == digest(full / 'identity.json')
    for row in qualification['rows']:
        assert row['passed'] and row['numerical_identical']
        assert row['router_cycle_change'] == 0 and not any(row['consumer_cycle_changes'].values())
        assert row['receipt_sha256'] == digest(full / row['name'] / 'complete.json')
    regression = read(root / 'router-regression-summary.json')
    assert regression['passed'] and regression['kernel_tests_passed'] == 52
    return dict(measured_source=source['measured_source'], pr_head=source['head'],
        executable_changes=True, reuse_type='compact_router_sampled_equivalence',
        measured_router_layout='ordinary', published_router_default='compact',
        router_probes=270, compact_numerical_cases=45,
        router_regression_passed=52, optional_skipped=regression['optional_skipped'],
        full_compact_matrix_rerun=False, consumer_sources_unchanged=True,
        probe_receipts_sha256=receipts, compact_qualification_sha256=digest(full / 'complete.json'),
        scope='Full ordinary-layout measurements reused by maintainer instruction after '
              'compact Router sampling and numerical integration; not a full compact rerun')
