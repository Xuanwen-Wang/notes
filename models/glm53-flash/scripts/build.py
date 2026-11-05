"""Build a portable HTML report and export publication-quality figures."""
import html
import io
import json
import math
from pathlib import Path
import re

from sampling_policy import INCLUDED_STEPS, write_csv

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
COLORS = {'zeus': '#2364d2', 'h200': '#0d8d7b', 'router': '#2364d2',
          'routed': '#d85b43', 'shared': '#7856ad', 'reduce': '#0d8d7b', 'reference': '#8492a6'}
plt.rcParams.update({'font.family': 'Noto Sans CJK JP', 'font.size': 11,
                     'axes.spines.top': False, 'axes.spines.right': False,
                     'axes.edgecolor': '#b9c7d7', 'text.color': '#172b48',
                     'axes.labelcolor': '#49617c', 'xtick.color': '#49617c',
                     'ytick.color': '#49617c', 'svg.fonttype': 'none',
                     'svg.hashsalt': 'glm53-moe-benchmark'})


def table(headers, rows, caption):
    return ('<div class="table-scroll" tabindex="0"><table><caption>' + caption + '</caption>'
            + '<thead><tr>' + ''.join('<th scope="col">' + h + '</th>' for h in headers)
            + '</tr></thead><tbody>' + ''.join('<tr>' + ''.join('<td>' + str(v) + '</td>' for v in row)
                                              + '</tr>' for row in rows) + '</tbody></table></div>')


def chart(name, lines, ylabel, title, band=None, linear=False, labels=False, initial_batch=32, initial_visible=None,
          zero_baseline=True, ratio=None):
    if ratio:
        # Divide the pooled throughput series, never rounded labels or per-sample ratios.
        numerator, denominator = [next(line for line in lines if line[0] == key) for key in ratio]
        assert list(numerator[2]) == list(denominator[2])
        assert len(numerator[2]) == len(numerator[3]) == len(denominator[3])
        assert all(math.isfinite(y) and y >= 0 for y in numerator[3])
        assert all(math.isfinite(y) and y > 0 for y in denominator[3])
        ratios = [n / d for n, d in zip(numerator[3], denominator[3])]
        ratio_label = f'{ratio[0].title()} / {ratio[1].upper()}'
        fig, (ax, ratio_ax) = plt.subplots(2, 1, figsize=(12.4, 8), sharex=True,
                                         height_ratios=[2.4, 1], layout='constrained')
    else:
        fig, ax = plt.subplots(figsize=(12.4, 5.4), layout='constrained')
    fig.patch.set_facecolor('#ffffff')
    ax.set_axisbelow(True)
    ax.grid(axis='y', color='#e3eaf2', linewidth=.8)
    ax.set_title(title, loc='left', fontsize=14, pad=40, weight='bold')
    for key, label, xs, ys in lines:
        ax.plot(xs, ys, color=COLORS[key], linewidth=2.5, marker='o', markersize=5,
                markerfacecolor='white', markeredgewidth=2, label=label, linestyle='--' if key == 'reference' else '-')
        if labels:
            for index, (x, y) in enumerate(zip(xs, ys)):
                below = len(lines) == 2 and y < next(line[3][index] for line in lines if line[0] != key)
                ax.annotate(f'{y:,.1f}', (x, y), xytext=(0, -18 if below else 10),
                            textcoords='offset points', ha='center', fontsize=8.5, color=COLORS[key])
    if band:
        ax.fill_between(*band, color=COLORS['h200'], alpha=.1, linewidth=0, label='输入间 P10–P90')
    if linear:
        xs = lines[0][2]
        ax.plot(xs, [x / 16 for x in xs], '--', color='#8695a7', linewidth=1.5, label='线性增长 BS / 16')
    ax.set_xticks(list(range(16, 129, 8)))
    ax.set_xlim(13, 131)
    ax.set_ylim(bottom=0)
    ax.margins(y=.17)
    ax.set_ylabel(ylabel)
    if not ratio:
        ax.set_xlabel('总 batch size（4 card）', labelpad=12)
    top = ax.secondary_xaxis('top', functions=(lambda x: x / 4, lambda x: x * 4))
    top.set_xticks(list(range(4, 33, 2)))
    top.set_xlabel('归一化每卡 batch = 总 batch / 4', labelpad=8, fontsize=10)
    top.spines['top'].set_visible(False)
    ax.legend(loc='upper left', bbox_to_anchor=(0, 1 if ratio else -.18), ncol=min(len(lines) + int(linear) + int(bool(band)), 5),
              frameon=False, fontsize=9)
    ratio_note = ''
    if ratio:
        ratio_ax.set_facecolor('#f7faff')
        ratio_ax.set_axisbelow(True)
        ratio_ax.grid(axis='y', color='#e3eaf2', linewidth=.8)
        ratio_ax.bar(numerator[2], ratios, width=4,
                     color=[COLORS['zeus'] if y >= 1 else COLORS['h200'] for y in ratios], alpha=.78, zorder=3)
        for x, y in zip(numerator[2], ratios):
            if labels:
                ratio_ax.annotate(f'{y:.2f}×', (x, y), xytext=(0, 5), textcoords='offset points',
                                  ha='center', fontsize=9, color=COLORS['zeus'] if y >= 1 else COLORS['h200'],
                                  bbox=dict(facecolor='#f7faff', edgecolor='none', pad=.3), zorder=5)
        ratio_ax.axhline(1, color='#687c95', linestyle=(0, (4, 4)), linewidth=1.2, zorder=4)
        ratio_ax.annotate('1× · 吞吐持平', (1, 1), xycoords=('axes fraction', 'data'),
                          xytext=(-5, 6), textcoords='offset points', ha='right', fontsize=9, color='#49617c')
        ratio_ax.set_ylim(0, max(1, max(ratios)) * 1.2)
        ratio_ax.yaxis.set_major_formatter(matplotlib.ticker.FuncFormatter(lambda y, _: f'{y:g}×'))
        ratio_ax.set_ylabel('吞吐比值（倍）')
        ratio_ax.set_title(f'{ratio_label} · 吞吐比值', loc='left', fontsize=12, pad=14, weight='bold')
        ratio_ax.text(1, 1.08, '蓝 ≥ 1×：Zeus 较高或持平    绿 < 1×：H200 较高',
                      transform=ratio_ax.transAxes, ha='right', fontsize=9, color='#687c95')
        ratio_ax.set_xlabel('总 batch size（4 card）· 上下图共用横轴', labelpad=12)
        ratio_note = '<br>附图纵轴：Zeus / H200 吞吐比值（倍）；1× 表示持平。使用同档汇总吞吐相除，不是逐点比值的平均。'
    assets = ROOT / 'assets'
    assets.mkdir(exist_ok=True)
    fig.savefig(assets / f'{name}.png', dpi=180, metadata={'Software': 'GLM53 benchmark builder'})
    buffer = io.StringIO()
    fig.savefig(buffer, format='svg', metadata={'Date': None})
    svg = buffer.getvalue()
    svg = svg[svg.index('<svg'):]
    # Each inline chart needs its own IDs, including clipping paths and glyph references.
    ids = re.findall(r'id="([^"]+)"', svg)
    for value in sorted(set(ids), key=len, reverse=True):
        svg = svg.replace(f'id="{value}"', f'id="{name}-{value}"')
        svg = svg.replace(f'#{value})', f'#{name}-{value})').replace(f'"#{value}"', f'"#{name}-{value}"')
    svg = svg.replace('<svg ', f'<svg role="img" aria-label="{html.escape(title)}" ', 1)
    svg = '\n'.join(line.rstrip() for line in svg.splitlines()) + '\n'
    (assets / f'{name}.svg').write_text(svg)
    plt.close(fig)
    series = [dict(key=k, label=label, x=list(xs), y=list(ys), color=COLORS[k], dashed=k == 'reference')
              for k, label, xs, ys in lines]
    if linear:
        series.append(dict(key='linear', label='线性参考 BS / 16', x=list(lines[0][2]),
                           y=[x / 16 for x in lines[0][2]], color='#8492a6', dashed=True))
    config = dict(title=title, unit=ylabel, series=series, band=band, labels=labels, initialBatch=initial_batch)
    if ratio:
        config['ratio'] = dict(numerator=ratio[0], denominator=ratio[1], label=ratio_label)
    if not zero_baseline:
        config['zeroBaseline'] = False
    if initial_visible is not None:
        assert set(initial_visible) <= {s['key'] for s in series}
        config['initialVisible'] = list(initial_visible)
    payload = json.dumps(config, ensure_ascii=False).replace('<', '\\u003c')
    return (f'<figure class="interactive-chart" id="chart-{name}"><figcaption><div>'
            f'<span class="chart-kicker">4 CARD · 49 DECODE STEP SAMPLES / BATCH · 42 MoE LAYERS</span><h3>{html.escape(title)}</h3></div>'
            f'<span class="chart-unit">{html.escape(ylabel)}</span></figcaption>'
            '<div class="chart-controls"></div><div class="chart-frame">' + svg + '</div>'
            '<div class="chart-readout"></div><div class="chart-footer">'
            f'<span>横轴：四卡总 batch size（16–128）<br>纵轴：{html.escape(ylabel)}{ratio_note}<br>统计范围：每档同一套 49 个 decode step 采样点（7 批请求 × 每批 7 个采样位置），排除 step001</span>'
            f'<span><a href="assets/{name}.png" download>完整图 PNG</a>'
            f'<a href="assets/{name}.svg" download>完整图 SVG</a></span></div>'
            f'<script type="application/json" class="chart-config">{payload}</script></figure>')


def build():
    d = json.loads((ROOT / 'data/benchmark.json').read_text())
    assert d['schema_version'] == 2, 'Re-export with the current sampling policy before publishing'
    policy = d['protocol']['sampling_policy']
    assert policy['excluded_steps'] == [1] and policy['included_steps'] == list(INCLUDED_STEPS)
    assert d['h200']['pairs'] == d['zeus_population']['pairs'] == 49
    assert d['protocol']['pair'] == dict(group='train00', step=17)
    h, kz = d['h200']['rows'], d['zeus_population']['rows']
    assert d['zeus_population']['complete']
    xs = list(range(16, 129, 8))
    assert [r['batch_size'] for r in h] == [r['batch_size'] for r in kz] == xs
    for r in kz:
        assert math.isclose(r['tokens_s_card'], r['batch_size'] * 1e8 / r['cycles'], rel_tol=1e-12)
    f = d['zeus_population']
    population_chart = chart('population-comparison', [
        ('h200', 'H200 · EP4', xs, [r['tokens_s_card'] for r in h]),
        ('zeus', 'Zeus · EP4 × TP4', xs, [r['tokens_s_card'] for r in kz])],
        'tokens/s/card', '49 个 decode step 采样点汇总 · H200 与 Zeus MoE 吞吐', labels=True,
        initial_batch=f['selected_batch_size'], ratio=('zeus', 'h200'))
    population_table = table(
        ['总 batch', '均摊 batch/card', 'H200 · ms', 'H200 · tokens/s/card', 'Zeus · ms', 'Zeus · tokens/s/card'],
        [[r['batch_size'], f"{r['batch_per_card']:g}", f"{r['mean_ms']:.4f}", f"{r['tokens_s_card']:.1f}",
          f"{z['milliseconds']:.4f}", f"{z['tokens_s_card']:.1f}"] for r, z in zip(h, kz)],
        '行：四卡总 batch；列：每卡均摊 batch、各平台 42 层平均耗时（ms）与单卡吞吐。每行汇总同一套 49 点。')
    distribution = table(
        ['总 batch', 'H200 · P10–P90', 'Zeus · P10–P90', 'Zeus · 平均 cycles', 'H200 · 活跃专家/层'],
        [[r['batch_size'], f"{r['p10']:.1f}–{r['p90']:.1f}", f"{z['p10']:.1f}–{z['p90']:.1f}",
          f"{z['cycles']:,.1f}", f"{r['mean_active_experts']:.1f}"] for r, z in zip(h, kz)],
        '行：四卡总 batch；P10–P90 单位为 tokens/s/card，来自 49 点分布；cycles 为完整 42 层平均周期；专家数按采样点和层平均。')
    selection_table = table(['平台', 'train 选择总 batch', 'validation · tokens/s/card', 'test · tokens/s/card'],
        [[label, obj['selected_batch_size'], f"{obj['holdout']['validation']:.2f}", f"{obj['holdout']['test']:.2f}"]
         for label, obj in [('H200', d['h200']['selection']), ('Zeus', f)]],
        '行：执行平台；列：只用 train 选择的四卡总 batch，以及该档在 validation / test 上的单卡吞吐。每批均保留七步。')
    assert f['measurement_mode'] == 'timing_only'
    if f.get('evidence_type') == 'qualified_owner_router_campaign':
        q = d['qualification']['current_full_mode']
        assert q['source_commit'] == f['source_commit'] and q['passed']
        eq = d['qualification']['source_equivalence']
        ci = d['qualification']['current_ci']
        assert eq['measured_source'] == f['source_commit'] and eq['pr_head'] == f['pr_head'] == ci['headSha']
        ci_label = ('已通过' if ci['status'] == 'completed' and ci['conclusion'] == 'success'
                    else '已结束：' + str(ci['conclusion']) if ci['status'] == 'completed' else '尚在运行 / 排队')
        exception_groups = {}
        for row in q['analytic_budget_exceptions']:
            name = row['name']
            match = re.search(r'bs(\d+).*layer(\d+)-rank(\d+)', name, re.IGNORECASE)
            if match:
                batch, layer, rank = map(int, match.groups())
                exception_groups.setdefault((layer, rank), []).append(batch)
        exception_text = '；'.join(f'layer{layer}/rank{rank} 的 BS' + '/'.join(map(str, sorted(batches)))
                                  for (layer, rank), batches in sorted(exception_groups.items()))
        exception_text = ('：' + exception_text + '。') if exception_text else '，详见完整数据中的逐 case 记录。'
        evidence = (f"<p>本轮 49 个 decode step 采样点共 {f['cases']:,} 个时序 case、672 个 shard 全部完成，"
                    f"并行上限 {f['workers']} workers，宿主耗时 {f['host_seconds']/3600:.2f} 小时，最终有效矩阵零失败。"
                    "全量唯一覆盖、输入/权重与资格 hash 审计通过；H200 沿用同输入的原测量。</p>"
                    f"<p>独立数值资格：{q['regression_unique_cases']} 项 MoE 回归通过；train00/step017、全部 15 档、"
                    "layer/rank (3,0)/(5,15)/(44,4) 的 45 项完整模式通过实现参考、完整/本地 Router 逐位比较、"
                    "Reduce exact 和 changed-input Graph；45 对完整/时序模式的逐 launch/core cycles、输入/权重、"
                    "Router 结果与语义 zbin 一致。</p>"
                    f"<p>当前完整模式中有 <b>{len(q['analytic_budget_exceptions'])}</b> 项解析 SiLU 数学预算超限{exception_text}"
                    "原阈值不变，单列诊断，"
                    "不与实现参考或 Graph 门禁混淆。</p>"
                    "<p>时序模式保持真实 Router，仅省略已资格 Routed/Shared 的 PE 数值乘加；"
                    "时序输出及下游 Reduce 不计为数值 PASS，493,920 个时序 case 不代表全矩阵数值验收。</p>"
                    f"<p>测量源码 <code>{f['source_commit'][:12]}</code>；整理后的 PR head "
                    f"<code>{f['pr_head'][:12]}</code> 与其保留代码、测试及 benchmark 脚本逐文件一致。"
                    f"PR head 的 <a href=\"{html.escape(ci['url'], quote=True)}\">CI {ci_label}</a>"
                    "（发布时快照，实时状态见 GitHub），旧 SHA 的 CI 不继承为新 SHA 的 PASS。</p>")
        if ci.get('failure_note'):
            evidence += '<p>' + html.escape(ci['failure_note']) + '</p>'
        if d['provenance'].get('infrastructure_recovery'):
            recovery = d['provenance']['infrastructure_recovery']
            evidence += (f'<p>基础设施重试记录：共 {recovery["attempts"]} 次执行，初次因磁盘空间波动触发保护及临时 JIT 文件写入失败，'
                         f'{recovery["first_attempt_incomplete_shards"]} 个未完成 shard 在相同冻结环境下补测。'
                         '旧尝试保留；最终矩阵按唯一 case 去重，全量覆盖未删减。宿主耗时包含恢复过程。</p>')
    elif f.get('evidence_type') == 'qualified_retained_campaign':
        q = d['qualification']['current_full_mode']
        assert q['source_commit'] == f['source_commit'] and q['passed']
        evidence = (f"<p>本轮直接重测保留的 49 个 decode step 采样点，共 {f['cases']:,} 个时序 case，"
                    f"{f['workers']} 个并行 worker，宿主耗时 {f['host_seconds']/3600:.2f} 小时，零失败。"
                    "全部新旧输入、Router IDs、权重已对齐；Router/Shared/Reduce cycles 不变。"
                    "H200 复用同输入的已完成测量，本轮未重新测量 H200。</p>"
                    f"<p>当前源码独立数值资格：{q['integrated_regression_tests']} 项 kernel 回归通过；"
                    f"train00/step017 上新旧合计 {q['complete_mode_cases']} 个完整模式 case 通过原有实现参考、"
                    "Reduce exact 和 Graph 门禁，15 对保存 tensor 完全一致。"
                    f"{q['timing_comparison_cases']} 对完整/时序模式的逐 launch/core cycles、Router IDs、"
                    "输入/权重和去除构建日期后的 zbin 内容一致。历史 step001 资格单独保留。</p>"
                    "<p>时序模式只用于周期评估，保持真实 Router；Routed/Shared 的 PE 数值乘加被省略，"
                    "其输出及下游 Reduce 不计为数值 PASS。</p>")
        if 'current_ci' in d['qualification']:
            ci = d['qualification']['current_ci']
            assert ci['headSha'] == f['source_commit'] and ci['conclusion'] == 'success'
            evidence += f'<p>本轮源码 <code>{f["source_commit"][:12]}</code> 的 <a href="{html.escape(ci["url"], quote=True)}">完整 CI 已通过</a>。</p>'
    else:
        evidence = (f"<p>原始 56 点矩阵共 {f['measured_cases']:,} 个时序 case，宿主耗时 {f['host_seconds']/3600:.2f} 小时；"
                f"排除 {f['excluded_cases']:,} 个 step001 case 后保留 {f['cases']:,} 个，仅重算统计，未重新仿真。"
                "native 完成门禁与跨平台输入身份均已核对。</p>"
                f"<p>数值资格独立保留：{f['numerical_baseline_cases']:,} 个历史完整模式基线；"
                f"新二进制 {f['new_binary_numerical_cases']} 个完整数值/Graph 代表点；"
                f"{f['mode_comparison_cases']} 个逐核 cycles / Router ID 对照。历史 train00/step001 的 "
                f"{f['baseline_comparison_cases']:,} 个时序 case 与完整基线一致，不移作 step017 数值验证。</p>"
                "<p>时序模式保持真实 Router，仅在已获资格的 Routed/Shared 路径省略 PE 数值乘加；"
                    "时序输出及下游 Reduce 不具备数值资格，时序 case 数不能计为数值 PASS。</p>")
    stages = ('router', 'routed', 'shared', 'reduce')
    # Keep the model-token numerator and all four cards for every stage, including Shared.
    # Invert the pooled 42-layer stage time, not the mean of per-sample reciprocal times.
    hz = d['protocol']['frequency_mhz'] * 1e6
    cards = d['protocol']['cards']
    stage_rates = {s: [r['batch_size'] * hz / (r['stages'][s] * cards) for r in kz] for s in stages}
    throughput_rows, peak_rows, throughput_export = [], [], []
    for i, row in enumerate(kz):
        cells = [row['batch_size']]
        for stage in stages:
            value = stage_rates[stage][i]
            delta = (value / stage_rates[stage][i - 1] - 1) * 100 if i else None
            cells.extend([f'{value:,.1f}', '—' if delta is None else f'{delta:+.2f}%'])
            throughput_export.append(dict(batch_size=row['batch_size'], batch_per_card=row['batch_size'] / cards,
                kernel=stage, mean_42_layer_cycles=row['stages'][stage],
                mean_42_layer_ms=row['stages'][stage] / hz * 1000, tokens_s_card=value,
                previous_batch_size=kz[i - 1]['batch_size'] if i else '',
                change_vs_previous_pct=delta if delta is not None else '', cards=cards,
                frequency_mhz=d['protocol']['frequency_mhz'], source_commit=f['source_commit']))
        throughput_rows.append(cells)
    for stage in stages:
        values = stage_rates[stage]
        peak = max(range(len(kz)), key=lambda i: values[i])
        worst = min(range(1, len(kz)), key=lambda i: values[i] / values[i - 1])
        peak_rows.append([stage.title(), f"BS{kz[peak]['batch_size']} · {values[peak]:,.1f}",
            f'{values[-1]:,.1f}', f'{(values[-1] / values[peak] - 1) * 100:+.2f}%',
            f"BS{kz[worst - 1]['batch_size']} → BS{kz[worst]['batch_size']} · {(values[worst] / values[worst - 1] - 1) * 100:+.2f}%"])
    write_csv(ROOT / 'data/kernel-throughput.csv', throughput_export)
    throughput = chart('kernel-throughput',
        [(s, s.title(), xs, stage_rates[s]) for s in stages], 'tokens/s/card（阶段等效）',
        '各个 kernel 的吞吐率 · 大 batch 是否进入平台期？', initial_batch=128,
        initial_visible=('routed', 'shared', 'reduce'), zero_baseline=False)
    throughput += ('<p class="reading-note">口径：<code>总 BS × 400,000,000 ÷ 该阶段 42 层平均 cycles ÷ 4</code>。'
        '各层先取该阶段最慢 rank（Router 取最慢 owner），累加 42 层，再对 49 个采样点取平均时间。'
        '分子只计模型输入 token，不乘 Top-K 或层数；Shared 也按四卡归一化。</p>'
        '<p class="reading-note">曲线走平表示增加 batch 后该阶段的单位卡处理速率不再明显提高；'
        '向下表示时间增长超过 token 数增长。默认隐藏吞吐数量级较大的 Router，可勾选或点「只看」检查；'
        '交互图默认放大纵轴范围，突出变化趋势；可勾选「纵轴从 0 开始」比较绝对比例。'
        '下载图保留从零开始的完整四条曲线。</p>'
        '<div class="note">这是仅计某一阶段耗时的等效吞吐，用于定位扩展性问题；'
        '不代表完整 MoE 吞吐或已经测得的流水线容量，四阶段不能相加。'
        '不同阶段的最慢 rank 可能不同，判断实际瓶颈还需结合下方耗时图。</div>')
    throughput += table(['阶段', '扫描峰值 · BS / tokens/s/card', 'BS128 · tokens/s/card',
        'BS128 相对峰值', '最大相邻档回落'], peak_rows,
        '行：四个 kernel 阶段；列：当前 15 档扫描峰值、BS128 等效吞吐、相对峰值变化，以及最大相邻 batch 回落。未测档位不作推断。')
    throughput += '<details class="data-details"><summary>查看 15 档阶段吞吐与相邻档变化</summary>' + table(
        ['总 batch'] + [label for s in stages for label in (s.title() + ' · tokens/s/card', s.title() + ' · 相邻档变化')],
        throughput_rows, '行：四卡总 batch；每阶段两列：42 层阶段等效吞吐与相对上一档的吞吐变化。'
        '负值表示回落，BS16 无前一档。全部基于同一套 49 个采样点。') + '</details>'
    # Describe observed scaling only; adjacent drops cannot by themselves identify hardware saturation.
    i32, i40, i48 = (xs.index(bs) for bs in (32, 40, 48))
    throughput += (f'<p class="reading-note"><b>关键档位变化：</b>Routed 在 BS32 → BS40 的吞吐变化为 '
        f'{(stage_rates["routed"][i40] / stage_rates["routed"][i32] - 1) * 100:+.1f}%，'
        f'BS128 相对 BS32 为 {(stage_rates["routed"][-1] / stage_rates["routed"][i32] - 1) * 100:+.1f}%；'
        f'Reduce 在 BS40 → BS48 为 {(stage_rates["reduce"][i48] / stage_rates["reduce"][i40] - 1) * 100:+.1f}%。'
        f'Shared 从 BS32 到 BS128，batch 增至 4 倍，吞吐变化为 '
        f'{(stage_rates["shared"][-1] / stage_rates["shared"][i32] - 1) * 100:+.1f}%。'
        'Router 的相对变化需结合绝对耗时判断，不能仅凭百分比认定主瓶颈；'
        '这些曲线不能单独区分 kernel 调度、编译器或硬件带宽原因。</p>')
    absolute = chart('kernel-time',
        [(s, s.title(), xs, [r['stages'][s] / 42 / 400 for r in kz]) for s in stages],
        '平均每层耗时（μs）', '各阶段耗时 · 哪个阶段最耗时？')
    growth = chart('kernel-growth',
        [(s, s.title(), xs, [r['stages'][s] / kz[0]['stages'][s] for r in kz]) for s in stages],
        '周期增长倍数（BS16 = 1）', '相对增长 · 是否超过 batch 的线性增长？', linear=True)
    normalized = chart('kernel-per-token',
        [(s, s.title(), xs, [r['stages'][s] / kz[0]['stages'][s] / (r['batch_size'] / 16) for r in kz]) for s in stages]
        + [('reference', 'BS16 单 token 成本 = 1', xs, [1] * len(xs))],
        '单 token 周期比（BS16 = 1）', '单 token 成本 · batch 增大后是否更高效？')
    kt = table(['总 batch', 'Router · μs/层', 'Routed · μs/层', 'Shared · μs/层', 'Reduce · μs/层', 'Routed / BS16', '线性参考'],
        [[r['batch_size']] + [f"{r['stages'][s] / 42 / 400:.3f}" for s in stages]
         + [f"{r['stages']['routed']/kz[0]['stages']['routed']:.3f}×", f"{r['batch_size']/16:.2f}×"] for r in kz],
        '行：四卡总 batch；列：49 点平均的单层阶段耗时（μs）、Routed 周期倍数及 batch 倍数。Shared 仅 EP0，逐阶段独立取最大 rank。')
    kernel = (absolute + '<p class="reading-note">纵轴是平均每层微秒数：各阶段逐层独立取最大 rank，累加 42 层后取 49 点平均，再除以 42。'
              '各阶段的最慢 rank 可能不同，不能把它们相加当成完整 MoE 时间。</p>'
              + growth + '<p class="reading-note">纵轴 = 当前 batch 的阶段平均 cycles ÷ BS16 的阶段平均 cycles；'
              '虚线 = 总 batch ÷ 16。曲线低于虚线，表示相对 BS16 的增长小于线性。</p>'
              + normalized + '<p class="reading-note">纵轴 = 周期增长倍数 ÷ batch 增长倍数。低于 1 表示每 token 的周期成本下降；'
              '高于 1 表示上升。参考线 1 对应 BS16 的单 token 成本。</p>'
              + '<details class="data-details"><summary>查看逐 kernel 耗时与增长明细</summary>' + kt + '</details>')
    superlinear = [str(r['batch_size']) for r in kz
                   if r['stages']['routed'] / kz[0]['stages']['routed'] > r['batch_size'] / 16 + 1e-9]
    analysis = (('49 点平均下，Routed 相对 BS16 超过线性参考的档位：' + '、'.join(superlinear) + '。')
                if superlinear else '49 点平均下，当前全部档位的 Routed 相对 BS16 均未超过线性参考。')
    analysis += '相对 BS16 次线性不代表任意相邻两档均次线性；仅凭曲线不能唯一归因于编译器或 kernel 调度。'
    exceptions = len(d['qualification']['historical_full_mode']['analytic_budget_exceptions'])
    history = json.loads((ROOT / 'data/zeus-history-20261102.json').read_text())
    historical = table(['总 BS', '优化前 cycles', '优化后 cycles', '时间降低', '优化后 ms', 'tokens/s/card'],
        [[r['batch_size'], f"{int(r['baseline_cycles']):,}", f"{int(r['candidate_cycles']):,}",
          f"{float(r['total_reduction_pct']):.2f}%", f"{float(r['candidate_ms']):.4f}",
          f"{float(r['candidate_tokens_per_second_per_card']):.1f}"] for r in history['comparison']],
        '行：四卡总 batch；列：42 层周期、时间降低百分比、42 层毫秒数与单卡吞吐。历史同 batch 前后输入相同，不同 batch 的 step 不同。')
    old_k = history['kernels']
    stages = ('router', 'routed', 'shared', 'reduce')
    historical += table(['总 BS'] + [s.title() + ' μs' for s in stages],
        [[bs] + [f"{float(next(r for r in old_k if int(r['batch_size']) == bs and r['kernel'] == s)['mean_layer_us']):.3f}"
                 for s in stages] for bs in (16, 24, 32, 40, 48)]
        + [['48 / 16'] + [f"{float(next(r for r in old_k if int(r['batch_size']) == 48 and r['kernel'] == s)['ratio_vs_bs16']):.3f}×" for s in stages]],
        '行：四卡总 batch，末行为 BS48 / BS16 倍数；列：各阶段单层平均耗时（μs）。独立最大 rank，不可相加作为 MoE 时间。')
    historical += table(['总 BS', 'Routed 解析预算超限 / 672', 'Shared 解析预算超限 / 168'],
        [[r['batch_size'], r['routed_analytic_failed_cases'], r['shared_analytic_failed_cases']]
         for r in history['analytic_exceptions']],
        '行：四卡总 batch；列：超出局部解析预算的 case 数 / 该阶段总 case 数。与实现参考/Graph 门禁分开记录。')
    revision = ''
    if 'flow_revision' in d:
        revision_scope = ('双方使用相同采样点和 calibrated Router；旧版直接引用 PR #643 归档，新版使用新 kernel 与新编译器。'
                          '这是整体方案对比，不能把全部提升归因于某一个 kernel。'
                          if d['flow_revision'].get('kind') == 'four_kernel_and_compiler' else
                          '同一组输入/权重，流程、sigmoid 和编译器同时变化；不是固定路由的 Routed 单独优化 A/B。')
        revision = '<details class="data-details"><summary>查看本轮完整流程与上一版：相同 49 个采样点</summary>' + table(
            ['总 batch', '旧版 tokens/s/card', '新版 tokens/s/card', 'MoE 吞吐变化', 'Router cycles 变化',
             'Routed cycles 变化', 'Shared cycles 变化', 'Reduce cycles 变化'],
            [[r['batch_size'], f"{r['baseline']['tokens_s_card']:.1f}", f"{r['candidate']['tokens_s_card']:.1f}",
              f"{r['throughput_increase_pct']:+.2f}%"] + [f"{r['stage_cycles_change_pct'][s]:+.2f}%" for s in stages]
             for r in d['flow_revision']['rows']],
            '行：四卡总 batch；列：旧/新版单卡吞吐、吞吐变化及四阶段 cycles 变化（负值为周期降低）。'
            + revision_scope) + '</details>'
    elif 'revision' in d:
        revision = '<details class="data-details"><summary>查看本轮 Routed 优化前后：相同 49 个采样点</summary>' + table(
            ['总 batch', '旧版 tokens/s/card', '新版 tokens/s/card', 'MoE 吞吐提升', 'Routed cycles 降幅'],
            [[r['batch_size'], f"{r['baseline']['tokens_s_card']:.1f}", f"{r['candidate']['tokens_s_card']:.1f}",
              f"{r['throughput_increase_pct']:.2f}%", f"{r['routed_cycles_reduction_pct']:.2f}%"]
             for r in d['revision']['rows']],
            '行：四卡总 batch；列：旧/新版的单卡吞吐及变化。双方采用相同 49 个采样点、完整 42 层与相同工具链；阶段降幅不可直接当作 MoE 吞吐提升。') + '</details>'
    status = f"{f['cases']:,} 个时序 case"
    source = f['source_commit']
    best_h, best_z = max(h, key=lambda r: r['tokens_s_card']), max(kz, key=lambda r: r['tokens_s_card'])
    latest_update = ('<b>2026-11-04 完整复测</b>：当前曲线使用本地 Router → 一次 gather → direct transport 的统一流程，'
                     'Router 为 calibrated sigmoid。四卡总 BS16–128 的 493,920 个时序 case 全部完成；'
                     '最佳档位为 BS32，1,134.6 tokens/s/card。相对上一版扫描峰值提高 15.7%。')
    current_history = ''
    if d.get('flow_revision', {}).get('kind') == 'four_kernel_and_compiler':
        changes = [r['throughput_increase_pct'] for r in d['flow_revision']['rows']]
        old_peak = max(r['baseline']['tokens_s_card'] for r in d['flow_revision']['rows'])
        latest_update = (f"<b>{html.escape(d['updated'])} 四阶段集成复测</b>：Router / Routed / Shared / Reduce "
                         f"与编译器更新后，{f['cases']:,} 个时序 case 全部完成。扫描内最高为总 BS{best_z['batch_size']}，"
                         f"{best_z['tokens_s_card']:,.1f} tokens/s/card；相对 PR #643 各同档吞吐变化 "
                         f"{min(changes):+.1f}%～{max(changes):+.1f}%。旧版直接引用冻结结果，新版使用新编译器。")
        version = f"versions/{d['updated'].replace('-', '')}-{source[:8]}"
        current_history = (f'<div class="timeline"><div><time>{html.escape(d["updated"])}</time><p>'
                           '<b>Router / Routed / Shared / Reduce 四阶段更新</b><br>'
                           f'测量源码 <code>{source[:12]}</code>，编译器 <code>{d["toolchain"]["triton_shared"][:12]}</code>。'
                           f'{f["cases"]:,} 个时序 case 完成；输入、权重与 Router IDs 全部匹配 PR #643。'
                           f'扫描峰值由 {old_peak:,.1f} 提高到 {best_z["tokens_s_card"]:,.1f} tokens/s/card。'
                           '比较同时包含 kernel 与编译器变化；H200 沿用原同输入测量。'
                           f'<a href="{version}/data/benchmark.json">本轮固定快照</a> · '
                           '<a href="data/flow-comparison.csv">与 PR #643 对照 CSV</a>。</p></div></div>')
    # Detailed historical exceptions remain downloadable without bloating every page load.
    page_data = {key: d[key] for key in ('updated', 'protocol', 'h200', 'zeus_population', 'toolchain')}
    replacements = dict(STYLE=(ROOT / 'assets/style.css').read_text() + '\n' + (ROOT / 'assets/charts.css').read_text(),
        POPULATION_CHART=population_chart, POPULATION_TABLE=population_table, DISTRIBUTION_TABLE=distribution,
        SELECTION_TABLE=selection_table, EVIDENCE=evidence, KERNEL=kernel, UPDATED=d['updated'],
        STATUS=status, ANALYSIS=analysis, EXCEPTIONS=str(exceptions), SOURCE=source, KERNEL_THROUGHPUT=throughput,
        SOURCE_SHORT=source[:12], DATA=json.dumps(page_data, ensure_ascii=False).replace('<', '\\u003c'),
        REVISION_TABLE=revision, HISTORY_TABLES=historical,
        LATEST_UPDATE=latest_update, CURRENT_HISTORY=current_history,
        PR_URL=html.escape(d.get('publication', {}).get('pull_request_url',
                           'https://github.com/DarronTam/torch_zeus/pull/643'), quote=True),
        H200_BEST=f"{best_h['tokens_s_card']:,.1f}", H200_BEST_BS=str(best_h['batch_size']), H200_BEST_CARD=f"{best_h['batch_size']/4:g}",
        ZEUS_BEST=f"{best_z['tokens_s_card']:,.1f}", ZEUS_BEST_BS=str(best_z['batch_size']), ZEUS_BEST_CARD=f"{best_z['batch_size']/4:g}",
        TOOLCHAIN=table(['组件', '冻结版本 / SHA256'], [[k, '<code>' + v + '</code>'] for k, v in d['toolchain'].items()],
                        '行：工具链或 kernel 组件；列：冻结 commit 或文件指纹，与本轮测量绑定。'))
    page = (ROOT / 'page.template').read_text()
    for key, value in replacements.items():
        assert '{{' + key + '}}' in page, key
        page = page.replace('{{' + key + '}}', value)
    assert '{{' not in page
    page = page.replace('</body>', '<script>' + (ROOT / 'assets/charts.js').read_text()
                        + '\n' + (ROOT / 'assets/navigation.js').read_text() + '</script></body>')
    (ROOT / 'index.html').write_text(page)
    print(status)


if __name__ == '__main__':
    build()
