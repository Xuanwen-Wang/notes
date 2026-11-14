"""Presentation of the DP16 campaign, with explicit cross-flow comparisons."""
import html

STAGES = ('router_shared', 'routed', 'reduce')


def label(stage):
    return 'Router + Shared' if stage == 'router_shared' else stage.title()


def method(dp16):
    front = 'Router+Shared' if dp16 else 'Router'
    consumers = 'Routed + Reduce' if dp16 else 'Shared + Routed + Reduce'
    return (f'<div class="mini"><h3>Zeus <span>TP4 × EP4</span></h3><p>'
            f'4 card / 16 rank / 32 core，400 MHz。每个 launch 取最慢 core；每层先取最慢 owner 的 {front}，'
            f'再加最慢 rank 的 {consumers}，最后累加 42 层。gather 是依赖边界，真实通信耗时未计入。</p>'
            f'<code>cycles = Σ层 [max_owner({front}) + max_rank({consumers})]<br>'
            'tokens/s/card = 总 BS × 400,000,000 ÷ cycles ÷ 4</code></div>')


def evidence(data):
    q = data['qualification']['dp16_full_mode']
    pop = data['zeus_population']
    ci = data['qualification']['current_ci']
    assert q['passed'] and q['source_commit'] == pop['source_commit'] == ci['headSha']
    state = '已通过' if ci['status'] == 'completed' and ci['conclusion'] == 'success' else '尚未通过，见实时状态'
    return (f'<p>完整 49 点 × 15 档 × 42 层 × 16 rank：<b>{pop["cases"]:,}</b> 个时序 case 全部审计完成。'
            f'并发上限 {pop["workers"]}，实际峰值 {pop["peak_workers"]}；宿主耗时 {pop["host_seconds"]/3600:.2f} 小时。'
            '宿主耗时包含磁盘空间保护触发的暂停，不是设备计算延迟。'
            '原始输入、权重身份与旧 Notes 测量逐 case 核对，H200 数据保持原样。</p>'
            f'<p>数值资格：{q["full_mode_cases"]} 个 full case，覆盖全部 15 档以及额外 train/validation/test 输入；'
            '保留 Router reference、完整 I2048 Shared reference、Routed LUT reference、Reduce exact 与 changed-input Graph。'
            f'{q["timing_comparison_cases"]} 对 full/timing、{q["equal_core_cycles"]:,} 个逐核 cycles、'
            f'{q["identical_binary_pairs"]} 对二进制一致。此前同源码 {q["regression_unique_cases"]} 项 kernel 回归、'
            f'{q["cpu_checks"]} 项 CPU 检查为旧工具环境下的历史证据，不计作本次新 simulator 的复测。</p>'
            f'<p>Routed 解析 SiLU 预算仍有 {q["analytic_exceptions"]}/{q["full_mode_cases"]} 项超限；'
            f'Shared 解析参考超预算 {q["shared_analytic_exceptions"]}/{q["full_mode_cases"]} 项。'
            '原阈值未放宽，详见 JSON 中的数值诊断。实现参考通过与解析精度通过是不同结论。</p>'
            '<p>时序模式仅跳过 Routed 的 PE 数值计算；融合 Router+Shared 完整执行，真实路由继续决定分组。'
            '时序输出及下游 Reduce 不计作数值 PASS。H1 使用冻结捕获，collective 为 CPU test double；'
            '不包含真实通信、Attention、host/JIT，不新增 VCS/RTL、物理卡或整模推理验收。</p>'
            f'<p>测量源码 <code>{pop["source_commit"][:12]}</code>；'
            f'<a href="{html.escape(ci["url"],quote=True)}">测量 SHA 的 CI：{state}</a>（发布时快照）。</p>')


def comparison(data, table):
    revision = data['dp16_revision']
    rows = revision['rows']
    note = ('同一套 49 个采样点；旧版直接引用上一版 Notes，未用新编译器重跑。'
            '流程、kernel、编译器与模拟器版本共同变化，增益不能归因于单一改动。'
            '融合阶段的旧值为 Router 与 Shared 两个独立阶段的耗时之和，'
            '仅表示组件成本对照，不是实测的旧融合 kernel 或完整 MoE 临界路径。')
    overview = table(['总 BS', '旧 Notes · tokens/s/card', '本轮 · tokens/s/card', '整体吞吐变化'],
        [[r['batch_size'], f'{r["baseline"]["tokens_s_card"]:,.1f}',
          f'{r["candidate"]["tokens_s_card"]:,.1f}', f'{r["throughput_change_pct"]:+.2f}%'] for r in rows],
        '行：四卡总 batch；列：两版 42 层 / 49 点的单卡吞吐及相对变化。' + note)
    stages = table(['总 BS'] + [label(s) + ' · 旧 → 新 tokens/s/card（变化）' for s in STAGES],
        [[r['batch_size']] + [f'{r["stage_rates"][s]["baseline"]:,.1f} → '
            f'{r["stage_rates"][s]["candidate"]:,.1f}（{r["stage_rates"][s]["change_pct"]:+.2f}%）'
            for s in STAGES] for r in rows],
        '行：四卡总 batch；列：每阶段的等效吞吐对照，分子为模型输入 token。' + note)
    return overview, stages


def update_text(data):
    rows = data['dp16_revision']['rows']
    changes = [r['throughput_change_pct'] for r in rows]
    best = max(data['zeus_population']['rows'], key=lambda r:r['tokens_s_card'])
    regressions = [str(r['batch_size']) for r in rows if r['throughput_change_pct'] < -1e-9]
    result = (f'<b>{html.escape(data["updated"])} Shared DP16 / 全 batch M4 完整复测</b>：'
              f'493,920 个时序 case 已完成。扫描峰值为 BS{best["batch_size"]}：'
              f'{best["tokens_s_card"]:,.1f} tokens/s/card；相对旧 Notes 同档变化 '
              f'{min(changes):+.1f}%～{max(changes):+.1f}%。')
    result += ('有退化的档位：BS' + ' / '.join(regressions) + '。') if regressions else '本次所测 15 档均未退化。'
    return result
