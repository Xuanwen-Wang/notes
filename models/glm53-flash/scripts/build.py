"""Build a portable HTML report and export publication-quality figures."""
import html
import io
import json
import math
from pathlib import Path
import re

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
COLORS = {'zeus': '#2364d2', 'h200': '#0d8d7b', 'router': '#2364d2',
          'routed': '#d85b43', 'shared': '#7856ad', 'reduce': '#0d8d7b'}
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
                markerfacecolor='white', markeredgewidth=2, label=label)
        if labels:
            for x, y in zip(xs, ys):
                ax.annotate(f'{y:,.0f}', (x, y), xytext=(0, 10 if key == 'h200' else -18),
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
    ax.legend(loc='best', frameon=True, facecolor='white', edgecolor='#e3eaf2', fontsize=9)
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
    (assets / f'{name}.svg').write_text(svg)
    plt.close(fig)
    return '<div class="chart-scroll" tabindex="0">' + svg + '</div>'


def build():
    d = json.loads((ROOT / 'data/benchmark.json').read_text())
    h, z = d['h200']['rows'], d['zeus']['rows']
    assert [r['batch_size'] for r in h] == list(range(16, 129, 8))
    for r in z:
        assert math.isclose(r['tokens_s_card'], r['batch_size'] * 1e8 / r['cycles'], rel_tol=1e-12)
    xs = [r['batch_size'] for r in h]
    lines = [('h200', 'H200 EP4 · train00 / step001', xs, [r['paired_tokens_s_card'] for r in h])]
    if z:
        lines.append(('zeus', 'Zeus EP4×TP4 · 同组输入', [r['batch_size'] for r in z], [r['tokens_s_card'] for r in z]))
    paired_chart = chart('paired-throughput', lines, 'tokens/s/card', '同组输入 · 完整 42 层 MoE 组件吞吐', labels=True)
    full_chart = chart('h200-56-throughput', [('h200', 'H200 EP4 · 56 组统计', xs, [r['tokens_s_card'] for r in h])],
                       'tokens/s/card', 'H200 · 56 组成对输入',
                       band=(xs, [r['p10'] for r in h], [r['p90'] for r in h]), labels=True)
    paired_rows = []
    for r in h:
        zr = next((a for a in z if a['batch_size'] == r['batch_size']), None)
        paired_rows.append([r['batch_size'], f"{r['batch_per_card']:g}", f"{r['paired_ms']:.4f}",
                           f"{r['paired_tokens_s_card']:.1f}", f"{zr['cycles']:,}" if zr else '待完成',
                           f"{zr['milliseconds']:.4f}" if zr else '—', f"{zr['tokens_s_card']:.1f}" if zr else '—'])
    paired_table = table(['总 BS', '每卡 BS', 'H200 ms', 'H200 tokens/s/card', 'Zeus cycles', 'Zeus ms', 'Zeus tokens/s/card'],
                         paired_rows, '同一 train00 / step001；每个 batch 均要求完整 42 层')
    full_table = table(['总 BS', '每卡 BS', '平均 ms', 'tokens/s/card', 'P10', 'P90'],
        [[r['batch_size'], f"{r['batch_per_card']:g}", f"{r['mean_ms']:.4f}", f"{r['tokens_s_card']:.1f}",
          f"{r['p10']:.1f}", f"{r['p90']:.1f}"] for r in h], 'H200 56 组统计；P10/P90 是输入间分布，不是置信区间')
    zeus56 = '<p class="pending">尚未完成 56 组扩展。本节仅在全部 564,480 个 case 通过原门禁后生成统计曲线。</p>'
    if d.get('zeus56', {}).get('complete'):
        f = d['zeus56']
        frows = f['rows']
        zeus56 = chart('full56-comparison', [
            ('h200', 'H200 EP4 · 56 组', xs, [r['tokens_s_card'] for r in h]),
            ('zeus', 'Zeus EP4×TP4 · 相同 56 组', xs, [r['tokens_s_card'] for r in frows])],
            'tokens/s/card', '同一套 56 组成对输入 · 完整 42 层统计', labels=True)
        zeus56 += table(['总 BS', 'Zeus 平均 cycles', 'Zeus 平均 ms', 'Zeus tokens/s/card', 'Zeus P10', 'Zeus P90', 'H200 tokens/s/card'],
            [[r['batch_size'], f"{r['cycles']:,.1f}", f"{r['milliseconds']:.4f}", f"{r['tokens_s_card']:.1f}",
              f"{r['p10']:.1f}", f"{r['p90']:.1f}", f"{h[i]['tokens_s_card']:.1f}"] for i, r in enumerate(frows)],
            '两侧均为总 token / 总时间 / 4；输入间 P10/P90 不是置信区间')
        zeus56 += (f"<p>Zeus 完成 {f['cases']:,} case，原实现参考、Graph 与完成门禁全部通过。train 选择总 BS{f['selected_batch_size']}；"
                   f"validation {f['holdout']['validation']:.2f}、test {f['holdout']['test']:.2f} tokens/s/card。"
                   f"解析数学预算另记 {f['analytic_exceptions']:,} 个超限 case。</p>"
                   '<p><a href="data/zeus-56-paired.csv" download>下载全部 840 个配对输入的 Zeus 汇总 CSV</a></p>')
    kernel = '<p class="pending">等待每档完整 42 层结果。预热与部分层结果不用于吞吐曲线。</p>'
    analysis = '本轮尚未形成完整 15 档曲线；暂不判断 Zeus 的最佳 batch 或 Routed 增长趋势。'
    kz = d['zeus56']['rows'] if d.get('zeus56', {}).get('complete') else z
    kernel_scope = '56 组输入的平均周期' if d.get('zeus56', {}).get('complete') else 'train00 / step001 单组输入'
    if kz and kz[0]['batch_size'] == 16:
        kx = [r['batch_size'] for r in kz]
        stage_lines = [(s, s.title(), kx, [r['stages'][s] / kz[0]['stages'][s] for r in kz]) for s in ('router', 'routed', 'shared', 'reduce')]
        growth = chart('kernel-growth', stage_lines, '相对 BS16 的 cycles 倍数', 'Zeus · 各阶段增长与线性参考', linear=True)
        absolute = chart('kernel-time', [(s, s.title(), kx, [r['stages'][s] / 42 / 400 for r in kz]) for s in ('router', 'routed', 'shared', 'reduce')],
                         '每层平均 μs', 'Zeus · 各阶段耗时（逐层独立最大 rank）')
        normalized = chart('kernel-per-token', [(s, s.title(), kx, [r['stages'][s] / kz[0]['stages'][s] / (r['batch_size'] / 16) for r in kz]) for s in ('router', 'routed', 'shared', 'reduce')],
                           'cycles/token 相对 BS16', 'Zeus · 单 token 成本（低于 1 表示相对 BS16 次线性）')
        kt = table(['总 BS', 'Router μs', 'Routed μs', 'Shared μs', 'Reduce μs', 'Routed / BS16', '线性参考'],
            [[r['batch_size']] + [f"{r['stages'][s] / 42 / 400:.3f}" for s in ('router', 'routed', 'shared', 'reduce')]
             + [f"{r['stages']['routed']/kz[0]['stages']['routed']:.3f}×", f"{r['batch_size']/16:.2f}×"] for r in kz],
            '各阶段逐层取最大 rank，累加后除以 42；Shared 仅 EP0。各阶段最大值不可相加充当完整 MoE 时间。')
        kernel = '<p class="note">当前 kernel 曲线采样范围：' + kernel_scope + '。</p>' + growth + absolute + normalized + kt
        superlinear = [str(r['batch_size']) for r in z if r['stages']['routed']/z[0]['stages']['routed'] > r['batch_size']/16 + 1e-9]
        best = max(z, key=lambda r: r['tokens_s_card'])
        analysis = (f"当前完整档位中的最高观测吞吐为 BS{best['batch_size']}：{best['tokens_s_card']:.1f} tokens/s/card。"
                    + ('Routed 相对 BS16 仍超线性的档位：' + '、'.join(superlinear) + '。' if superlinear else '已完成档位的 Routed 相对 BS16 均未超过线性参考。')
                    + '这只描述固定输入样本；相对 BS16 次线性不等于任意相邻两档均次线性。路由负载与窗口边界同时变化，曲线本身不能唯一归因于编译器或 kernel 调度。')
    exceptions = len(d['zeus']['analytic_budget_exceptions'])
    history = json.loads((ROOT / 'data/zeus-history-20261102.json').read_text())
    historical = table(['总 BS', '优化前 cycles', '优化后 cycles', '时间降低', '优化后 ms', 'tokens/s/card'],
        [[r['batch_size'], f"{int(r['baseline_cycles']):,}", f"{int(r['candidate_cycles']):,}",
          f"{float(r['total_reduction_pct']):.2f}%", f"{float(r['candidate_ms']):.4f}",
          f"{float(r['candidate_tokens_per_second_per_card']):.1f}"] for r in history['comparison']],
        '历史 exact-tail A/B：同 batch 前后输入相同，不同 batch 的 decode step 不同')
    old_k = history['kernels']
    stages = ('router', 'routed', 'shared', 'reduce')
    historical += table(['总 BS'] + [s.title() + ' μs' for s in stages],
        [[bs] + [f"{float(next(r for r in old_k if int(r['batch_size']) == bs and r['kernel'] == s)['mean_layer_us']):.3f}"
                 for s in stages] for bs in (16, 24, 32, 40, 48)]
        + [['48 / 16'] + [f"{float(next(r for r in old_k if int(r['batch_size']) == 48 and r['kernel'] == s)['ratio_vs_bs16']):.3f}×" for s in stages]],
        '历史逐阶段平均层耗时：独立最大 rank；不能相加作为完整 MoE 时间')
    historical += table(['总 BS', 'Routed 解析预算超限 / 672', 'Shared 解析预算超限 / 168'],
        [[r['batch_size'], r['routed_analytic_failed_cases'], r['shared_analytic_failed_cases']]
         for r in history['analytic_exceptions']],
        '历史局部数学预算：优化前后逐项一致，与原实现参考/Graph 门禁分开')
    status = f"{d['zeus']['cases']:,} / {d['zeus']['total']:,} case · {'完成' if d['zeus']['complete'] else '测量中'}"
    source = d['zeus']['source_commit'] or '待导入'
    replacements = dict(STYLE=(ROOT / 'assets/style.css').read_text(), PAIRED_CHART=paired_chart,
        FULL_CHART=full_chart, PAIRED_TABLE=paired_table, FULL_TABLE=full_table, KERNEL=kernel,
        STATUS=status, ANALYSIS=analysis, EXCEPTIONS=str(exceptions), SOURCE=source,
        SOURCE_SHORT=source[:12], DATA=json.dumps(d, ensure_ascii=False).replace('<', '\\u003c'),
        HISTORY_TABLES=historical, ZEUS56=zeus56,
        TOOLCHAIN=table(['组件', '冻结版本'], [[k, '<code>' + v + '</code>'] for k, v in d['toolchain'].items()], '本轮工具链与 kernel 身份'))
    page = (ROOT / 'page.template').read_text()
    for key, value in replacements.items():
        assert '{{' + key + '}}' in page, key
        page = page.replace('{{' + key + '}}', value)
    assert '{{' not in page
    (ROOT / 'index.html').write_text(page)
    print(status)


if __name__ == '__main__':
    build()
