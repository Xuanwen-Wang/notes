"""Render the methodology with a fixed baseline, independent of the live chart data."""
import html
import json
from pathlib import Path
import sys

from markdown_it import MarkdownIt

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT.parents[1]))
from scripts.site_utils import write_article

TITLE = 'GLM5.3Flash - MoE 测评口径与 PR #643 基线'


def build_methodology():
    # Later performance updates must not silently rewrite the merged PR baseline.
    data = json.loads((ROOT / 'versions/20261104-1648b5c5/data/benchmark.json').read_text())
    rows = ['| 总 BS（4 card） | H200 ms | H200 tokens/s/card | Zeus ms | Zeus tokens/s/card | Zeus/H200 |',
            '|---:|---:|---:|---:|---:|---:|']
    assert len(data['h200']['rows']) == len(data['zeus_population']['rows']) == 15
    for h, z in zip(data['h200']['rows'], data['zeus_population']['rows']):
        assert h['batch_size'] == z['batch_size']
        rows.append(f"| {h['batch_size']} | {h['mean_ms']:.4f} | {h['tokens_s_card']:,.1f} | "
                    f"{z['milliseconds']:.4f} | {z['tokens_s_card']:,.1f} | {z['tokens_s_card']/h['tokens_s_card']:.3f}× |")
    source = (ROOT / 'methodology.template.md').read_text().replace('{{BASELINE_TABLE}}', '\n'.join(rows))
    (ROOT / 'methodology.md').write_text(source)
    parser = MarkdownIt('commonmark').enable('table')
    tokens = parser.parse(source)
    navigation = []
    for i, token in enumerate(tokens):
        if token.type == 'heading_open' and token.tag == 'h2':
            anchor = f'method-{len(navigation) + 1}'
            token.attrSet('id', anchor)
            navigation.append(f'<a href="#{anchor}">{html.escape(tokens[i + 1].content)}</a>')
    body = parser.renderer.render(tokens, parser.options, {})
    body = body.replace('<table>', '<div class="table-scroll" tabindex="0"><table>')
    body = body.replace('</table>', '</table></div>')
    style = (ROOT / 'assets/style.css').read_text() + '''
main { max-width:1400px; }
.methodology { background:white; padding:32px; border:1px solid var(--line); border-radius:16px; }
.methodology h1 { margin-top:0; }
.methodology h2 { margin:40px 0 16px; padding-top:22px; border-top:1px solid var(--line); }
.methodology blockquote { margin:20px 0; padding:8px 20px; border-left:4px solid var(--blue); background:#eef4fc; }
.methodology pre { padding:18px; border-radius:10px; background:#f4f7fb; overflow-x:auto; line-height:1.7; }
.methodology pre code { white-space:pre; overflow-wrap:normal; }
.methodology table { font-size:14px; width:100%; }
.methodology th,.methodology td { vertical-align:top; text-align:left; white-space:normal; padding:12px 14px; }
.methodology th { background:#f4f7fb; }
.methodology td code { overflow-wrap:anywhere; }
.methodology p,.methodology li { overflow-wrap:anywhere; }
.side-nav a { white-space:normal; font-size:11px; }
@media print { .methodology { border:0; padding:0; } }
'''
    page = f'''<!doctype html>
<html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="data:,">
<title>{html.escape(TITLE)}</title><meta name="description" content="GLM-5.3-Flash H200/Zeus MoE 测评方法、与真实推理的差异，以及 PR643 固定基线。">
<style>{style}</style></head><body>
<aside class="sidebar"><a class="brand" href="../../">NOTES</a><p class="sidebar-model">GLM-5.3-Flash<span>MEASUREMENT PROTOCOL</span></p>
<nav class="side-nav" aria-label="测评方法目录">{''.join(navigation)}</nav><div class="sidebar-foot"><a href="./">← 返回交互曲线</a><p>固定基线 · 2026-11-05</p></div></aside>
<main><article class="methodology">{body}</article></main></body></html>
'''
    write_article(ROOT.parents[1], 'glm53-flash-moe-methodology', page, ROOT / 'methodology.html')


if __name__ == '__main__':
    build_methodology()
