#!/usr/bin/env python3
"""Validate real-capture measurements and build a portable model handbook."""
import argparse
import base64
import hashlib
import html
import ipaddress
import json
import math
from pathlib import Path
import re
from statistics import mean
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parents[1]
STAGES = ('router', 'shared', 'routed', 'reduce')
BUSINESS_KERNELS = dict(router='sgl_moe_router_replicated_kernel', shared='_bf16_shared_kernel',
                        routed='sgl_moe_quantized_fused_kernel', reduce='sgl_moe_sum_reduce_quantized_kernel')
BATCHES = (16, 24, 32)
LAYERS = 43
RANKS = 16
CLOCK_HZ = 400_000_000
FROZEN_DENOMINATORS = {
    'master': {'16': 13.612195, '24': 22.518230, '32': 29.645385},
    'h200': {'16': 8.701847, '24': 9.827390, '32': 10.746829},
}
ANCHORS = ('overview', 'dataflow', 'quantization', 'optimization', 'abi',
           'explorer', 'viewer', 'validation', 'roadmap')


def require(condition, message):
    if not condition:
        raise ValueError(message)


def ms(cycles, clock_hz=CLOCK_HZ):
    return cycles * 1000 / clock_hz


def display(value):
    return f'{value:.7f}'


def table(headers, rows, caption):
    escape = lambda value: html.escape(str(value))
    return ('<div class="table-wrap"><table class="numeric"><caption>' + escape(caption)
            + '</caption><thead><tr>' + ''.join('<th scope="col">' + escape(h) + '</th>' for h in headers)
            + '</tr></thead><tbody>' + ''.join('<tr>' + ''.join('<td>' + escape(v) + '</td>' for v in row)
            + '</tr>' for row in rows) + '</tbody></table></div>')


def public_strings(value):
    """Reject private locations without copying the original receipt payloads."""
    if isinstance(value, dict):
        for key, item in value.items():
            public_strings(key)
            public_strings(item)
    elif isinstance(value, list):
        for item in value:
            public_strings(item)
    elif isinstance(value, str):
        require(not re.search(r'/(mnt|data|home|tmp)/|[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}', value),
                'Public data contains a machine path or email')
        for candidate in re.findall(r'(?<![\d.])(?:\d{1,3}\.){3}\d{1,3}(?![\d.])', value):
            try:
                ipaddress.ip_address(candidate)
            except ValueError:
                continue
            raise ValueError('Public data contains an IP address')


def aggregate(cases):
    """Select a complete rank chain before summing layers or stage components."""
    selected = []
    summaries = []
    for batch in BATCHES:
        by_layer = {}
        for row in cases:
            if row['bs'] == batch:
                by_layer.setdefault(row['layer'], []).append(row)
        chosen = []
        for layer in range(LAYERS):
            # Stable ties retain the lowest rank, matching the audited matrix.
            row = min(by_layer[layer], key=lambda item: (-item['cycles'], item['rank']))
            chosen.append(row)
            selected.append(row)
        stage_cycles = {stage: sum(row['stages'][stage]['cycles'] for row in chosen) for stage in STAGES}
        cycles = sum(row['cycles'] for row in chosen)
        require(cycles == sum(stage_cycles.values()), 'Critical-rank stage decomposition differs')
        summaries.append(dict(bs=batch, cycles=cycles, ms=ms(cycles), stage_cycles=stage_cycles))
    return summaries, selected


def validate_current(data, preview=False):
    require(data.get('schema_version') == 2 and data.get('kind') == 'dsv4-moe-real-capture', 'Unsupported schema')
    require(data.get('status') in ('preview', 'final'), 'Missing release status')
    require(not data.get('template_only'), 'A schema template is not measured data')
    require(preview == (data['status'] == 'preview'), 'Preview data requires --preview; final data must omit it')
    require(type(data.get('clock_hz')) is int and data['clock_hz'] == CLOCK_HZ, 'The frozen frequency changed')
    scope = data['scope']
    require(scope['batches'] == list(BATCHES) and scope['layers'] == LAYERS and scope['ranks'] == RANKS,
            'The real-capture scope changed')
    require(scope['decode_step'] == 17 and scope['history'] == 4096 and scope['boundary'] == 'compute_only',
            'The workload or timing boundary changed')
    expected_shape = dict(hidden=4096, intermediate_per_tp=512, routed_experts=256, topk=6,
                          zeus_tp=4, zeus_ep=4, h200_tp=1, h200_ep=4)
    require(all(scope[key] == value for key, value in expected_shape.items()), 'The model or parallelism scope changed')
    public_strings(data)
    fingerprints = [*data['tools'].values(), *data['sources'].values(),
                    *data['implementation']['product_manifest'].values(), data['qualification']['reference_sha256']]
    require(bool(fingerprints) and all(isinstance(value, str) and re.fullmatch('[0-9a-f]{64}', value)
                                     for value in fingerprints), 'Invalid source or tool fingerprint')
    if not preview:
        require(len(data['implementation']['product_manifest']) == 14, 'Final delivery must bind its fourteen products')
    for key, expected in FROZEN_DENOMINATORS.items():
        require(data['denominators'][key]['totals_ms'] == expected, 'Frozen denominator changed: ' + key)
    cases = data['cases']
    expected = {(batch, layer, rank) for batch in BATCHES for layer in range(LAYERS) for rank in range(RANKS)}
    keys = [(row['bs'], row['layer'], row['rank']) for row in cases]
    require(all(all(type(value) is int for value in key) for key in keys), 'Case coordinates must be integers')
    require(len(keys) == len(set(keys)) and set(keys) == expected, 'Duplicate or missing matrix case')
    for row in cases:
        require(set(row['stages']) == set(STAGES), 'The four measured stages changed')
        for stage in STAGES:
            item = row['stages'][stage]
            require(bool(item['launches']), 'Missing measured launch')
            for launch in item['launches']:
                core = launch['core_cycles']
                require(len(core) == 2 and all(type(value) is int and value >= 0 for value in core), 'Invalid core cycles')
                require(type(launch['cycles']) is int and launch['cycles'] > 0
                        and launch['cycles'] == max(core), 'Launch must use max(core0, core1)')
            require(type(item['cycles']) is int and item['cycles'] == sum(launch['cycles'] for launch in item['launches']),
                    'Stage launch sum differs')
            require(len(item['launches']) == 1 and item['launches'][0]['kernel'] == BUSINESS_KERNELS[stage],
                    'This profile requires four business compute launches')
        require(type(row['cycles']) is int and row['cycles'] == sum(item['cycles'] for item in row['stages'].values()),
                'Rank chain sum differs')
        require(row['evidence']['router_fp64_pass'] is True and row['evidence']['ffn_numerical_pass'] is False,
                'Timing-only must retain Router FP64 and separate FFN numerical scope')
    summaries, selected = aggregate(cases)
    declared = {row['bs']: row for row in data['summary']}
    require(len(data['summary']) == len(BATCHES) and set(declared) == set(BATCHES), 'Summary batches differ')
    for row in summaries:
        original = declared[row['bs']]
        require(original['cycles'] == row['cycles'] and original['stage_cycles'] == row['stage_cycles'],
                'Summary must select one complete rank per layer')
        require(math.isclose(original['ms'], row['ms'], rel_tol=0, abs_tol=1e-12), 'Summary ms conversion differs')
    qualification = data['qualification']
    cpu, critical, mode, matrix = (qualification[key] for key in ('cpu', 'critical', 'mode', 'matrix'))
    require(cpu['unique_cases'] == cpu['initial_cases'] + cpu['additional_critical_cases'], 'CPU difference-set count differs')
    require(cpu['graph_replays'] == 2 * cpu['unique_cases'], 'CPU Graph count differs')
    require(critical['cases'] == len(BATCHES) * LAYERS and critical['graph_replays'] == 2 * critical['cases'],
            'Critical numerical coverage is incomplete')
    require(critical['pointwise_failures'] == 0, 'Critical pointwise failures remain')
    require(critical['max_relative_l2']['routed'] < .025 and critical['max_relative_l2']['shared'] < .01
            and critical['max_relative_l2']['shared_no_activation_qdq'] < .01, 'Original L2 gate failed')
    require(mode['full_cases'] == mode['timing_cases'] == 6 and mode['graph_replays'] == 12, 'Mode qualification is incomplete')
    require(matrix['timing_cases'] == matrix['router_fp64_cases'] == len(cases)
            and matrix['native_completion_passed'] is True and matrix['ffn_numerical_pass'] is False,
            'Matrix evidence scope differs')
    for link in data.get('public_links', []):
        parsed = urlparse(link['url'])
        require(parsed.scheme == 'https' and parsed.hostname and not parsed.username, 'Invalid public source link')
    return summaries, selected


def history_html():
    """Retain the original random-batch measurements as a separate history."""
    data = json.loads((ROOT / 'data/2026-10-28.json').read_text())
    batches = data['batches']
    require(len(batches) == 27 and len({(row['T'], row['case']) for row in batches}) == 27, 'Historical cases changed')
    require({(row['T'], row['case']) for row in batches} == {
        (batch, f's{seed}_{profile}') for batch in BATCHES for seed in (528588, 528589, 528590)
        for profile in ('independent', 'clustered', 'hotspot')}, 'Historical sample grid changed')
    divisor = data['clock_mhz'] * 1000
    for row in batches:
        require(sorted(ep['ep'] for ep in row['per_ep']) == [0, 1, 2, 3], 'Historical EP scope changed')
        for ep in row['per_ep']:
            require(ep['cycles'] == sum(stage['cycles'] for stage in ep['stages'].values()), 'Historical chain differs')
            require(all(stage['cycles'] == max(stage['core_cycles'].values()) for stage in ep['stages'].values()),
                    'Historical core aggregation differs')
        require(row['ds_cycles'] == max(ep['cycles'] for ep in row['per_ep']), 'Historical slow EP differs')
        require(row['slow_eps'] == [ep['ep'] for ep in row['per_ep'] if ep['cycles'] == row['ds_cycles']], 'Historical ties differ')
    for summary in data['summary']:
        subset = [row for row in batches if row['T'] == summary['T']]
        for key in ('ds', 'master', 'glm', 'previous_pr'):
            require(math.isclose(summary[key + '_mean_ms'], mean(row[key + '_cycles'] for row in subset) / divisor,
                                 rel_tol=1e-12), 'Historical mean differs')
            require(math.isclose(summary[key + '_worst_ms'], max(row[key + '_cycles'] for row in subset) / divisor,
                                 rel_tol=1e-12), 'Historical worst differs')
        require(math.isclose(summary['ratio'], summary['ds_mean_ms'] / summary['glm_mean_ms'], rel_tol=1e-12), 'Historical ratio differs')
        require(math.isclose(summary['max_paired_ratio'], max(row['ds_cycles'] / row['glm_cycles'] for row in subset),
                             rel_tol=1e-12), 'Historical paired ratio differs')
    result = '<p>2026-10-28：三个 seed × 三种随机路由分布 × 三档 BS，共 27 batch / 108 EP。它使用旧 FP8 Shared、动态激活与 row-local 布局；与本轮 PR640 的真实 43 层 × 16 rank 完全分开。</p>'
    result += table(['BS', '历史 master 均值 ms', '历史 DS 均值 ms', '历史 GLM 均值 ms', '历史 DS/GLM'],
        [[row['T'], display(row['master_mean_ms']), display(row['ds_mean_ms']), display(row['glm_mean_ms']),
          f"{row['ratio']:.5f}"] for row in data['summary']], '历史随机测量；不是当前 baseline 或 H200 对照')
    result += table(['BS', '随机样本', '历史最慢 EP', '历史 DS ms', '历史 GLM ms'],
        [[row['T'], row['case'], ', '.join(map(str, row['slow_eps'])), display(row['ds_cycles'] / divisor),
          display(row['glm_cycles'] / divisor)] for row in batches], '完整保留 27 个历史样本')
    delivery = json.loads((ROOT / 'data/delivery-2026-10-28.json').read_text())
    require(delivery['status'] == 'local_validation_passed', 'Historical delivery status changed')
    result += '<details><summary>2026-10-28 原交付范围</summary>'
    result += ''.join('<p>' + html.escape(paragraph) + '</p>' for paragraph in delivery['paragraphs'])
    result += table(['历史检查', '原记录结果', '原记录范围'], delivery['rows'], '历史交付记录') + '</details>'
    result += '<p><a href="data/2026-10-28.json" download>原性能 JSON</a> · <a href="data/delivery-2026-10-28.json" download>原交付 JSON</a>；两个原件均未更改。</p>'
    return result


def figure_html(data):
    result = ''
    for figure in data.get('figures', []):
        path = (ROOT / figure['path']).resolve()
        require(path.is_relative_to(ROOT) and path.suffix == '.png', 'Invalid figure path')
        image = path.read_bytes()
        require(image.startswith(b'\x89PNG\r\n\x1a\n'), 'Figure must be an actual PNG')
        if figure['measurement_id'] != data['measurement_id']:
            require(figure.get('reference_only') is True, 'A different trace must be labeled as a separate reference')
        require(figure.get('sha256') == hashlib.sha256(image).hexdigest(), 'Figure SHA differs')
        encoded = base64.b64encode(image).decode()
        result += ('<figure class="native-figure"><h3>' + html.escape(figure['title']) + '</h3><a href="data:image/png;base64,'
                   + encoded + '" target="_blank" rel="noopener"><img loading="lazy" alt="'
                   + html.escape(figure['title'], quote=True) + '" src="data:image/png;base64,'
                   + encoded + '"></a><figcaption>' + html.escape(figure['caption'])
                   + ' 原图 SHA256：<code>' + figure['sha256'] + '</code>。</figcaption></figure>')
    return result


def denominator_html(data):
    """Show frozen historical tool identities independently of current results."""
    provenance = data['denominators']['provenance']
    original, larger = provenance['bs16'], provenance['bs24_bs32']
    fields = ('kernel_commit', 'compiler_commit', 'triton_commit', 'cyclesim_commit', 'cyclesim_sha256')
    require(all(original[key] == larger[key] for key in fields), 'Frozen baseline tools differ across batches')
    result = table(['冻结原始 baseline（2026-11-04）', '身份'], [
        ['kernel commit', original['kernel_commit']], ['compiler commit', original['compiler_commit']],
        ['Triton commit', original['triton_commit']], ['CycleSim commit', original['cyclesim_commit']],
        ['compiler binary SHA256', original['runtime_binary_sha256']['ZEUS_COMPILER']],
        ['simulator binary SHA256', original['cyclesim_sha256']],
        ['zecc binary SHA256', original['runtime_binary_sha256']['ZECC']],
        ['BS16 summary SHA256', original['summary_sha256']],
        ['BS24/32 summary SHA256', larger['summary_sha256']],
    ], '历史起点版本固定；当前 source / tool 指纹另见来源表')
    rows = []
    for batch in BATCHES:
        item = provenance['h200'][str(batch)]
        record = item['record']
        repetitions = record['repeat_total_ms']
        require(len(repetitions) == 3 and record['full_43_layers'] and record['real_decode_step'] == 17,
                'Frozen H200 workload differs')
        require(math.isclose(sorted(repetitions)[1], record['median_ms'], rel_tol=0, abs_tol=1e-12)
                and math.isclose(record['median_ms'], data['denominators']['h200']['totals_ms'][str(batch)],
                                 rel_tol=0, abs_tol=1e-12), 'Frozen H200 median differs')
        rows.append([batch, ' / '.join(display(value) for value in repetitions), display(record['median_ms']), item['summary_sha256']])
    result += table(['BS', 'H200 三轮总时长 ms', '中位数 ms', '原 summary SHA256'], rows,
                    '冻结 H200：TP1/EP4，FP8 E4M3 / UE8M0，dynamic activation，block128×128')
    return result


def build(data_path, preview=False, output=None):
    data = json.loads(data_path.read_text())
    summaries, selected = validate_current(data, preview)
    suffix = '中间版预览' if preview else '最终组合'
    replacements = dict(STYLE=(ROOT / 'assets/style.css').read_text(), SCRIPT=(ROOT / 'assets/app.js').read_text(),
        DATA=json.dumps(data, ensure_ascii=False, separators=(',', ':')).replace('<', '\\u003c'),
        RESULT_LABEL=html.escape(data['label']), RESULT_SUFFIX=suffix, PAGE_STATE='未发布草稿' if preview else '本轮交付数据',
        PROFILE_CONTEXT=('后文描述本轮冻结组合的设计；预览数字不继承给新的源码。' if preview
                         else '本页性能、数值资格与下文实现说明对应同一份冻结14产品组合。'),
        DESIGN_NOTE=('本节描述本轮冻结组合；预览数字只对应所列测量身份，发布前仍需核对全部资格。' if preview
                     else '本节对应本页已合格数据的实际源码；有界数学、调度与精度边界共同绑定。'),
        PREVIEW_BANNER=('<div class="preview-banner" role="status"><strong>未发布预览</strong>下列数字仅对应本页列出的源码与工具身份，尚未发布为最终交付。</div>' if preview else ''),
        MASTER_TABLE=table(['BS', '冻结原始 baseline ms', suffix + ' ms', '总耗时下降', '耗时加速比'],
            [[row['bs'], display(data['denominators']['master']['totals_ms'][str(row['bs'])]), display(row['ms']),
              f"{(1-row['ms']/data['denominators']['master']['totals_ms'][str(row['bs'])])*100:.2f}%",
              f"{data['denominators']['master']['totals_ms'][str(row['bs'])]/row['ms']:.3f}×"] for row in summaries],
            '表 1 · 对照 2026-11-04 冻结实现与工具链 · ' + suffix),
        H200_TABLE=table(['BS', suffix + ' ms', '冻结 H200 ms', 'Zeus/H200 耗时比', 'Zeus 相对耗时'],
            [[row['bs'], display(row['ms']), display(data['denominators']['h200']['totals_ms'][str(row['bs'])]),
              f"{row['ms']/data['denominators']['h200']['totals_ms'][str(row['bs'])]:.5f}",
              f"{(row['ms']/data['denominators']['h200']['totals_ms'][str(row['bs'])]-1)*100:+.2f}%"] for row in summaries],
            '表 2 · 同工作点的冻结 H200 对照 · ' + suffix),
        STAGE_TABLE=table(['BS', 'Router ms', 'Shared ms', 'Routed ms', 'Reduce ms', '整链 ms'],
            [[row['bs'], *[display(ms(row['stage_cycles'][stage])) for stage in STAGES], display(row['ms'])]
             for row in summaries], '同一整链 critical rank 的分 stage 分解；没有跨 rank 拼接'),
        LAYER_TABLE=table(['层', 'BS16 rank / ms', 'BS24 rank / ms', 'BS32 rank / ms'],
            [[layer, *[next(f"r{row['rank']} / {display(ms(row['cycles']))}" for row in selected
                            if row['bs'] == batch and row['layer'] == layer) for batch in BATCHES]]
             for layer in range(LAYERS)], '全部 43 层；每列采用该 BS 本层整链最慢 rank'),
        FIGURES=figure_html(data), HISTORY=history_html(), DENOMINATOR_TABLE=denominator_html(data))
    q = data['qualification']
    comparisons = []
    for row in summaries:
        change = (row['ms'] / data['denominators']['h200']['totals_ms'][str(row['bs'])] - 1) * 100
        comparisons.append(f"BS{row['bs']} 比 H200 {'低' if change < 0 else '高'} {abs(change):.2f}%")
    replacements['PERFORMANCE_STATUS'] = '；'.join(comparisons) + '。这些比例对应本页的 MoE compute 统计范围。'
    replacements['DELIVERY_STATUS'] = ('当前仍为中间版预览；最终组合将独立完成数值、模式、矩阵和新 critical 差集后更新。' if preview
        else f"本轮完成 {q['cpu']['initial_cases']} 个原标准点，另补 {q['cpu']['additional_critical_cases']} 个新 critical 差集，合计 {q['cpu']['unique_cases']} 个唯一 CPU 标准点 / {q['cpu']['graph_replays']} Graph；2064 timing 和129个critical独立数值资格全部闭合。")
    replacements['QUALIFICATION_TABLE'] = table(['证据', '实际范围', '结论边界'], [
        ['原标准 CPU / Graph', f"{q['cpu']['initial_cases']} 原点 + {q['cpu']['additional_critical_cases']} critical 差集 = {q['cpu']['unique_cases']} 唯一点；{q['cpu']['graph_replays']} Graph", '原 FP64 Router、CPU FFN、Shared no-QDQ、ordered Reduce 与 changed-input Graph'],
        ['该版本 critical 数值', f"{q['critical']['cases']} 点 / {q['critical']['graph_replays']} Graph；pointwise 失败 {q['critical']['pointwise_failures']}", '每层实际整链 critical rank 均有独立原标准资格'],
        ['full / timing 模式', f"{q['mode']['full_cases']} full + {q['mode']['timing_cases']} timing；绑定 {q['mode']['graph_replays']} 次已验 Graph", '以该组合自身 CPU 合格输出绑定 full 字节和计时模式；Graph 属于上行已验资格，不重复计数'],
        ['timing 矩阵', f"{q['matrix']['timing_cases']} 点；Router FP64 {q['matrix']['router_fp64_cases']} 点", 'FFN timing-only；完整 native completion，不赋予全矩阵 FFN 数值 PASS'],
        ['未包含', 'RTL/VCS、通信、host/pack、完整模型', '不能延伸为模型精度、端到端 decode 或整模型容量验收'],
    ], suffix + '的证据分层')
    errors = q['critical']['max_relative_l2']
    replacements['ERRORS'] = (f"critical 最大 relative L2：Routed {errors['routed']:.10f}；Shared {errors['shared']:.10f}；"
                              f"Shared no-QDQ {errors['shared_no_activation_qdq']:.10f}。")
    manifest = data['implementation']['product_manifest']
    replacements['SOURCE_TABLE'] = table(['测量身份', 'SHA256'],
        [['compiler', data['tools']['compiler_sha256']], ['simulator', data['tools']['simulator_sha256']],
         ['CPU reference', q['reference_sha256']], *[[name, digest] for name, digest in sorted(data['sources'].items())]],
        suffix + '的公开来源摘要；原始本机路径不进入页面')
    replacements['PRODUCT_TABLE'] = table(['产品文件', 'SHA256'], sorted(manifest.items()), suffix + '实际测量的产品指纹')
    replacements['PUBLIC_LINKS'] = ''.join('<li><a href="' + html.escape(item['url'], quote=True) + '">'
        + html.escape(item['label']) + '</a></li>' for item in data.get('public_links', []))
    replacements['SOURCE_LINK_NOTE'] = ('公开源码链接以正式交付身份为准；历史版本留在下方折叠区。'
        if data.get('public_links') else '公开源码 commit / PR 链接等待正式交付身份，不用旧 PR 代替。')
    replacements['PROFILE'] = html.escape(data['implementation']['label'] + '：Routed ' + data['implementation']['routed_sigmoid']
        + '；Router ' + data['implementation']['router_domain'] + '；Shared ' + data['implementation']['shared'])
    page = (ROOT / 'page.template').read_text()
    for key, value in replacements.items():
        require('{{' + key + '}}' in page, 'Unused template value: ' + key)
        page = page.replace('{{' + key + '}}', value)
    require('{{' not in page, 'Unresolved template value')
    require(all(f'id="{anchor}"' in page for anchor in ANCHORS), 'Stable anchor missing')
    target = output or ROOT / 'index.html'
    target.write_text(page)
    print(f'Built {suffix}: 2064 cases / 129 complete critical chains; offline single HTML')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--data', type=Path, default=ROOT / 'data/2026-11-05.json')
    parser.add_argument('--preview', action='store_true', help='Required for private intermediate data; never final release')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    if not args.data.exists():
        parser.error('Final data is not available; use --data PRIVATE_PREVIEW.json --preview for a draft')
    build(args.data, args.preview, args.output)


if __name__ == '__main__':
    main()
