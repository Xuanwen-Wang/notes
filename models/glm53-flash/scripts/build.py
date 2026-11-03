"""Build a portable HTML report and export publication-quality figures."""
import html
import io
import json
import math
from pathlib import Path
import re

from sampling_policy import INCLUDED_STEPS

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


def chart(name, lines, ylabel, title, band=None, linear=False, labels=False):
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
    ax.set_xlabel('总 batch size（4 card）', labelpad=12)
    top = ax.secondary_xaxis('top', functions=(lambda x: x / 4, lambda x: x * 4))
    top.set_xticks(list(range(4, 33, 2)))
    top.set_xlabel('归一化每卡 batch = 总 batch / 4', labelpad=8, fontsize=10)
    top.spines['top'].set_visible(False)
    ax.legend(loc='upper left', bbox_to_anchor=(0, -.18), ncol=min(len(lines) + int(linear) + int(bool(band)), 5),
              frameon=False, fontsize=9)
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
    config = dict(title=title, unit=ylabel, series=series, band=band, labels=labels)
    payload = json.dumps(config, ensure_ascii=False).replace('<', '\\u003c')
    return (f'<figure class="interactive-chart" id="chart-{name}"><figcaption><div>'
            f'<span class="chart-kicker">4 CARD · 49 DECODE STEP SAMPLES / BATCH · 42 MoE LAYERS</span><h3>{html.escape(title)}</h3></div>'
            f'<span class="chart-unit">{html.escape(ylabel)}</span></figcaption>'
            '<div class="chart-controls"></div><div class="chart-frame">' + svg + '</div>'
            '<div class="chart-readout"></div><div class="chart-footer">'
            f'<span>横轴：四卡总 batch size（16–128）<br>纵轴：{html.escape(ylabel)}<br>统计范围：每档同一套 49 个 decode step 采样点（7 批请求 × 每批 7 个采样位置），排除 step001</span>'
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
        'tokens/s/card', '49 个 decode step 采样点汇总 · H200 与 Zeus MoE 吞吐', labels=True)
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
    status = f"{f['cases']:,} 个时序 case"
    source = f['source_commit']
    best_h, best_z = max(h, key=lambda r: r['tokens_s_card']), max(kz, key=lambda r: r['tokens_s_card'])
    # Detailed historical exceptions remain downloadable without bloating every page load.
    page_data = {key: d[key] for key in ('updated', 'protocol', 'h200', 'zeus_population', 'toolchain')}
    replacements = dict(STYLE=(ROOT / 'assets/style.css').read_text() + '\n' + (ROOT / 'assets/charts.css').read_text(),
        POPULATION_CHART=population_chart, POPULATION_TABLE=population_table, DISTRIBUTION_TABLE=distribution,
        SELECTION_TABLE=selection_table, EVIDENCE=evidence, KERNEL=kernel, UPDATED=d['updated'],
        STATUS=status, ANALYSIS=analysis, EXCEPTIONS=str(exceptions), SOURCE=source,
        SOURCE_SHORT=source[:12], DATA=json.dumps(page_data, ensure_ascii=False).replace('<', '\\u003c'),
        HISTORY_TABLES=historical,
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
