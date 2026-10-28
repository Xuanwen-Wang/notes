#!/usr/bin/env python3
"""Build one portable model handbook from prose, assets and frozen measurements."""
import html
import json
import math
from pathlib import Path
from statistics import mean

ROOT = Path(__file__).resolve().parents[1]


def table(headers, rows, caption):
    return ('<div class="table-wrap"><table class="numeric"><caption>' + html.escape(caption)
            + '</caption><thead><tr>' + ''.join('<th scope="col">' + h + '</th>' for h in headers)
            + '</tr></thead><tbody>' + ''.join('<tr>' + ''.join('<td>' + str(v) + '</td>' for v in row) + '</tr>' for row in rows)
            + '</tbody></table></div>')


def build():
    data = json.loads((ROOT / 'data/2026-10-28.json').read_text())
    batches = data['batches']
    assert len(batches) == 27 and len({(b['T'], b['case']) for b in batches}) == 27
    assert {(b['T'], b['case']) for b in batches} == {
        (t, f's{seed}_{profile}') for t in (16, 24, 32) for seed in (528588, 528589, 528590)
        for profile in ('independent', 'clustered', 'hotspot')}
    divisor = data['clock_mhz'] * 1000
    for b in batches:
        assert sorted(ep['ep'] for ep in b['per_ep']) == [0, 1, 2, 3]
        for ep in b['per_ep']:
            assert ep['cycles'] == sum(s['cycles'] for s in ep['stages'].values())
            assert all(s['cycles'] == max(s['core_cycles'].values()) for s in ep['stages'].values())
        assert b['ds_cycles'] == max(ep['cycles'] for ep in b['per_ep'])
        assert b['slow_eps'] == [ep['ep'] for ep in b['per_ep'] if ep['cycles'] == b['ds_cycles']]
    for summary in data['summary']:
        subset = [b for b in batches if b['T'] == summary['T']]
        for key in ('ds', 'master', 'glm', 'previous_pr'):
            assert math.isclose(summary[key + '_mean_ms'], mean(b[key + '_cycles'] for b in subset) / divisor, rel_tol=1e-12)
            assert math.isclose(summary[key + '_worst_ms'], max(b[key + '_cycles'] for b in subset) / divisor, rel_tol=1e-12)
        assert math.isclose(summary['ratio'], summary['ds_mean_ms'] / summary['glm_mean_ms'], rel_tol=1e-12)
        assert math.isclose(summary['max_paired_ratio'], max(b['ds_cycles'] / b['glm_cycles'] for b in subset), rel_tol=1e-12)
    pair = lambda s, key: f"{s[key + '_mean_ms']:.8f} / {s[key + '_worst_ms']:.8f}"
    first = table(['T', '固定 master<br>平均 / 最慢 batch ms', '当前 DS<br>平均 / 最慢 batch ms', '平均下降', '最慢 batch 下降'],
                  [[s['T'], pair(s, 'master'), pair(s, 'ds'), f"{(1 - s['ds_mean_ms'] / s['master_mean_ms']) * 100:.2f}%", f"{(1 - s['ds_worst_ms'] / s['master_worst_ms']) * 100:.2f}%"] for s in data['summary']],
                  '表 1 · 相对固定 master 原生实现')
    second = table(['T', '当前 DS<br>平均 / 最慢 batch ms', '固定 GLM<br>平均 / 最慢 batch ms', 'DS/GLM<br>平均耗时比', '最大配对<br>batch 比'],
                   [[s['T'], pair(s, 'ds'), pair(s, 'glm'), f"{s['ratio']:.5f}", f"{s['max_paired_ratio']:.5f}"] for s in data['summary']],
                   '表 2 · 与 GLM5Next300B 的固定测量对比')
    all_batches = table(['T', 'seed / profile', '最慢 EP', 'DS ms', 'GLM ms', '配对比'],
                        [[b['T'], b['case'], ', '.join(map(str, b['slow_eps'])), f"{b['ds_cycles']/divisor:.7f}", f"{b['glm_cycles']/divisor:.7f}", f"{b['ds_cycles']/b['glm_cycles']:.5f}"] for b in batches],
                        '全部 27 个 batch；未按收益筛选样本')
    ceiling = max(s['ds_mean_ms'] for s in data['summary']) * 1.08
    bars = ''
    for s in data['summary']:
        bars += f'<div class="comparison-row"><b>T{s["T"]}</b><div class="comparison-bars">'
        for key, label in [('ds', 'DS'), ('glm', 'GLM')]:
            value = s[key + '_mean_ms']
            bars += f'<div class="bar-track"><div class="bar-fill {key}" style="width:{value/ceiling*100:.4f}%"></div><span>{label} {value:.5f} ms</span></div>'
        bars += '</div></div>'
    # Inline assets keep the handbook usable when saved locally or shared as HTML.
    replacements = dict(STYLE=(ROOT / 'assets/style.css').read_text(), SCRIPT=(ROOT / 'assets/app.js').read_text(),
                        DATA=json.dumps(data, ensure_ascii=False, separators=(',', ':')).replace('<', '\\u003c'),
                        MASTER_TABLE=first, GLM_TABLE=second, ALL_BATCHES=all_batches, COMPARISON_BARS=bars)
    delivery = json.loads((ROOT / 'data/delivery-2026-10-28.json').read_text())
    assert delivery['status'] == 'local_validation_passed'
    replacements['DELIVERY_SHARED'] = html.escape(delivery['revisions']['triton_shared'])
    replacements['DELIVERY'] = ''.join('<p>' + html.escape(p) + '</p>' for p in delivery['paragraphs'])
    replacements['DELIVERY'] += table(['检查', '实际结果', '范围'],
                                     [[html.escape(str(v)) for v in row] for row in delivery['rows']],
                                     '2026-10-28 交付验证记录')
    page = (ROOT / 'page.template').read_text()
    for key, value in replacements.items():
        assert '{{' + key + '}}' in page
        page = page.replace('{{' + key + '}}', value)
    assert '{{' not in page
    (ROOT / 'index.html').write_text(page)
    print('Built DeepSeek V4 Flash handbook: 27 batches / 108 EP; frozen metrics verified')


if __name__ == '__main__':
    build()
