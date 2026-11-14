# GLM-5.3-Flash：MoE 测评口径与 PR #643 基线

固定基线：2026-11-05。面向算法侧复核与后续 kernel 优化；下方 PR #643 表格保持历史值。

> **当前主页已切换 Shared DP16 新流程，本文第 05～07 节仍描述 PR #643 固定基线。**
> 新版在每个 rank 上用本地 BF16 token 执行融合 Router+Shared（完整 I2048，两个 core 各 I1024），
> 一次 gather 传输 FP8 hidden、BF16 路由权重及 INT32 IDs；随后执行 Routed、owner-local Shared 注入的 Reduce。
> 本次显式选择 `parity_masks` 全 batch 合组；SGLang 默认 IDs 模式未改。
> 新版整体周期为 `Σ层[max_owner(Router+Shared) + max_rank(Routed+Reduce)]`，
> 阶段只实测 Router+Shared、Routed、Reduce 三项，不能把融合 launch 拆成两个独立实测耗时。
> 49 点采样、四卡归一化和排除通信等边界不变；H200 保留原测量。
> 最新源码、资格和完整结果见[主页](./#protocol)；旧版本不换新编译器重测。

> **当前曲线表示：固定输入下，42 层 MoE 组件计算的四卡等效吞吐。**
> H200 用真实 GPU CUDA event 测时，Zeus 用 CycleSim 周期按 400 MHz 换算。
> 它没有包含 Attention、H1、真实跨卡通信和在线调度，不能直接当成完整推理服务的 tokens/s/card。

[返回交互曲线](./) · [PR #643](https://github.com/DarronTam/torch_zeus/pull/643) · [下载本文 Markdown](methodology.md)

## 01 · 先对齐“测的是什么”

| 项目 | 本 benchmark | 与真实推理对比时要核对 |
|---|---|---|
| 输入 | 从真实 BS128 decode 中捕获的逐层 MoE 输入；小 batch 取前 B 行 | 自己的请求、prompt、生成位置、有效 batch 是否相同 |
| 层间关系 | 一次 replay 遍历 42 份 MoE 权重，每层使用自己捕获的输入 | **上一层 replay 的输出没有传给下一层**；不是完整模型 forward |
| 计时范围 | Router、Routed、Shared、本地 Reduce 等 MoE 计算 | 端到端通常还包含 Attention、H1/mHC、通信、采样、调度等 |
| 通信 | H200 输入提前复制到各卡，最终跨卡求和移出计时；Zeus 使用 CPU collective double | 真正 AllGather / AllReduce / All-to-All 的耗时及重叠 |
| 批次 | 四卡**总 BS16～128，步长 8** | 图上 BS128 = 归一化 32/card；不是每卡 128 |
| 单位 | 总 token / 总 MoE 计算时间 / 4 | 总吞吐、单卡吞吐、输出 token、输入 token 是否混用 |
| “最大” | 固定实现、固定输入分布、已测 15 档中的观测最佳 | 不表示所有 batch、kernel/backend 或完整模型的理论上限 |

**真实推理和本图不同，本身不足以判断哪边测错。** 应先对齐计时边界和工作负载，再比较相同层、相同输入上的 MoE 时间。

## 02 · 输入与 49 个采样点

- 模型 snapshot：`eb9eb208eb0d988989d07a6a12d0fdeb5f52574a`。层号 **3～44（从 0 开始）**，共 42 层 MoE；hidden=4096，288 个 routed experts，Top-K=8，专家 intermediate=2048。
- 896 条不同请求分为 7 批，每批 128 条。`train00/01/02`、`validation00/01`、`test00/01` 按 source group 隔离；seed=`20261102`。
- 固定 4096-token 文档上下文，生成参数 `min_new_tokens=max_new_tokens=115`、temperature=1.0、top_p=0.95、top_k=-1。`ignore_eos=False`，但 min_new_tokens 限制了提前结束；不能当作自然 EOS 的在线请求分布。
- 每批保留 decode 索引 **17、33、49、65、81、97、113**，索引从首个 decode forward 的 0 开始。因此每档是 **7 批 × 7 个位置 = 49 点**，不是 49 批请求或连续 49 步。
- 采集使用 CUDA TP4 / MoE EP1，父 batch 为 128；当前 H200 **测量**使用 MoE EP4。采集布局与执行布局是两件事。
- 同一个 `(group, step, layer)`，BS16 用 `hidden[:16]`，BS128 用全部 128 行。每个更小 batch 是父轨迹的逐层组件重放，**没有重新运行对应小 batch 的 Attention 和前序层**。
- 原采集和 H200 测量包含 step001，共 56 点。2026-11-03 查看路由分布后，维护者明确要求双方统一排除 step001，形成当前 49 点统计；这是查看数据后的协议调整，不是证明 step001 的采集损坏，也不是随机删异常值。原始 56 点与数值记录保留，不回写。
- H200 当前结果是从原 56 点测量中保留 49 点后重算；Zeus 本轮直接重测 49 点。各 batch、平台、train/validation/test 使用同一过滤规则。

请求、顺序、原始 step 和 split 预先冻结；除上述公开记录的 step001 修订外，不按吞吐或路由集中程度筛选。输入和权重有身份校验，**同输入并不意味着两平台量化后结果或 Router IDs 完全相同**。

## 03 · H200 实际怎么执行

实际测量：4 × NVIDIA H200 NVL，global TP=4；**Routed MoE EP4×TP1，Shared 独立 TP4**。

| 部分 | 实际行为 |
|---|---|
| Routed | 每卡 72 个完整专家，每专家 I=2048；全局 288 个专家不重复计算。`w13=[72,4096,4096]`，`w2=[72,4096,2048]` |
| Router | 每卡拿到相同的全局 B 行 hidden，执行原 CUDA Router，再按 EP 分区过滤 routed assignments；不是每卡只算 B/4 行 Router |
| Shared | 关闭 fused shared；在四卡分别计算 I=512 的 TP 分片，`gate_up=[1024,4096]`，`down=[4096,512]` |
| 数据分发 | `moe_a2a_backend=none`；全局输入已在每卡，局部 dispatcher 仍在 MoE 内执行 |
| 调用 | 生产 `moe.forward_normal(value, should_allreduce_fusion=True)`；省略末尾跨卡 sum，保留本地计算和合并 |
| backend | Routed 为 SGLang Triton FP8 fused MoE 默认配置；没有完成所有 H200 kernel/backend 的调优 |

这里 `ep_size=4` 与 `tp_size=4` **不代表 16 张 H200**。实际 world_size=4、moe_tp_size=1，四个不同 GPU UUID 及逐层权重形状均有回执。

冻结环境：Torch `2.10.0+cu130`、CUDA `13.0`、Triton `3.6.0`；driver `595.71.05`，power limit 600W，未锁定 SM 时钟。SGLang 使用历史固定版本及 GLM loader/NSA 兼容变更，以归档的公共源码、MoE kernel/runner 文件 hash 为执行身份，不把后来的 Zeus SGLang SHA 当成 H200 测量 SHA。

## 04 · H200 计时窗口与重复方式

1. 每档构建一个包含 **42 层、42 份不同权重**的 CUDA Graph。每层输入为该层自己的冻结 hidden，不把单层重复几百次当成完整 42 层。
2. 使用独立 reset graph 恢复输入，再 replay 测量 graph；**输入恢复不计时**。每个输入检查恢复 exact、Graph/eager 输出逐元素相等且有限。
3. 每个输入 warmup 3 次，测 7 轮，每轮重复 3 次完整序列。每层的 CUDA events 在 graph 内；每轮先对 3 次取均值，再对 7 轮取中位数。
4. 每层取四卡里最慢的结果，累加 42 层。batch 和采样点测量顺序按固定 seed 打乱。另记录整段 graph 时间用于检查层间未计区间；主值是逐层时间之和。
5. 每档每卡保留 CUDA profile，检查计时窗口没有 NCCL。采集、JIT、host 调度、模型装载、离线权重转换和输入恢复均不计入；**kernel 内读取显存权重的成本仍在计时内**。

Engine 的 `disable_cuda_graph=True` 关闭的是生产服务自动 capture；benchmark 自己构造了上述 `torch.cuda.CUDAGraph`，两者不矛盾。

原 56 点测量共有 3,360 个 rank case、141,120 个 layer/card 点。当前保留部分为 **2,940 个 rank case、123,480 个 layer/card 点**。不要把 7×3 次计时重复算作新增的请求样本。

## 05 · Zeus 实际怎么执行

4 card / **EP4×TP4 = 16 logical ranks / 32 cores**。同卡四个 TP rank 各取 I=512；每 rank 两核。Shared 仅在 EP0 的 ranks 0～3 上计算 TP4 分片。

```text
真实逐层 H1 输出
  → 按 owner 分发本地 token
  → 本地 Router（calibrated sigmoid）
  → 一次 raw-word gather（CPU double，不计通信时间）
  → Shared / Routed / Reduce 直接读取 transport rank blocks
```

所有 BS16～128 都走这条统一流程。B/4 行按卡内 TP4 分配，余数分给前面的 owner；各 owner Router 计算 1～8 行。Routed 保留 M1/M2/M4 合并与 bounded windows；不因大 batch 改回通用 Reduce。

H1 由捕获结果替代，业务编排执行冻结 SGLang 函数；核算的只有 checkpoint-backed Router 和 FFN kernels。一次记录为了模拟 rendezvous 会依次执行 16 个 owner 的 Router，但统计按并行取最大值，**不把它们串行求和**。

全量为 **49 × 15 × 42 × 16 = 493,920 个时序 case**，672 个 `(layer, rank)` shard，每 shard 735 个 case。实际在 **H200 服务器的 CPU** 上跑 CycleSim，192 workers；GPU 用于此前 H200 测量。CPU 宿主耗时不是 Zeus 延迟。

CycleSim `timing_only` 保留真实 Router、路由分组、地址和时序；对已资格的 Routed/Shared PE 路径省略数值乘加。它可用于周期矩阵，**其 Routed/Shared 输出和下游 Reduce 不计为数值 PASS**。完整数值资格单独记录。

## 06 · 量化、Router 与 Shared 的差异

| 部分 | H200 冻结实现 | Zeus 测量实现 |
|---|---|---|
| Routed weight | FP8 E4M3FN，128×128 block scales | checkpoint 权重按 TP 切分后解量化、重定标为 per-tensor FP8；每 expert/TP-local Gate、Up、Down 各一个 scale |
| Routed activation | CUDA FP8 per-token group quantization，group K=128 | 固定 scale=1 的 FP8 cast；hidden 和 SiLU×Up 输出均有 FP8 舍入，不执行动态 amax quantization |
| Shared | FP8 block-scaled linear，动态输入量化；TP4 横跨四卡 | checkpoint Shared 解量化为 BF16；BF16 activation/weight，TP4 放在 EP0 卡的四个 rank |
| Router | 原 CUDA 实现，重复处理各卡已持有的全局 B 行 | BF16 Router，calibrated sigmoid，各 owner 仅处理本地行 |
| Routed 激活函数 | 冻结 SGLang CUDA/EP 实现 | SiLU LUT；BF16→FP8 舍入在计算链中保留 |

Zeus 固定 scale=1 **仍是量化和舍入，不是“没有量化”**。双方使用同一 checkpoint 来源与输入，不意味着数值路径等价。图中的 `Zeus/H200` 是这两套组件实现及测量口径的吞吐比值，不是消除软件/精度差异后的硬件加速比。

本轮 Zeus calibrated Router 相对上一轮 accurate Router，有 206,288 / 493,920 条 rank-case 的 IDs 变化；这是 **Zeus 新旧版本**的比较计数，不是 H200/Zeus IDs 差异计数。流程、sigmoid、编译器同时改变，历史收益不能全部归因于 Routed 调度。

## 07 · 延迟与吞吐怎么汇总

令 B 为四卡总 batch，j 为一个 `(group, decode step)`，l 为层，r 为执行 rank，o 为 Router owner。

H200（毫秒）：

```text
t[j,l,r] = median(7 轮中，每轮 3 次 CUDA event 时间的均值)
T_H[j]   = Σ_l max_r t[j,l,r]
```

Zeus（cycles）：

```text
单 launch 周期 = max_core(cycles)
每 rank 的 FFN = Shared（若有）+ Routed + Reduce
C_Z[j]        = Σ_l { max_owner(Router) + max_rank(该 rank 的 FFN) }
T_Z[j]        = C_Z[j] / 400000                  # ms，400 MHz
```

Router 后有 gather 依赖，所以 Router 与 FFN 分开取并行临界路径。各层瓶颈可以是不同 rank/EP；不是全程固定一个“最慢 EP”，也不是平均 EP。

任一平台的主图：

```text
Q(B) = 49 × B × 1000 / Σ_j T[j] / 4           # tokens/s/card
     = B × 1000 / mean_j(T[j]) / 4
比值 = Q_Zeus(B) / Q_H200(B)
```

B 已经是四卡总 token 数，**分子不再乘 4，也不乘 Top-K=8 或 42 层**。比值使用双方同档汇总吞吐相除，不是 49 个逐点比值的平均。

各 kernel 图另用 `mean_j(Σ_l max_rank(stage cycles))` 计算阶段等效吞吐，目的为诊断瓶颈；各 stage 的最大值可能来自不同 rank，**不能相加替代整体 MoE 时间**。P10/P90 是 49 个工作负载点的吞吐分布，不是计时误差置信区间。49 点也不等于 49 个互相独立的请求集合。

## 08 · PR #643 固定基线

PR 于北京时间 **2026-11-05 01:56:02** 合入，merge commit `1e2168f6baaf51fe58be97300c33a33059fa3755`。

| 身份 | 冻结值 |
|---|---|
| Zeus 实际测量源码 | `1648b5c5aad4654f14d66bb9ccbd96b02af72ae7` |
| 提交整理后 | `f4ce26eabcc964650064c75635ebc750a38ccfa8` |
| PR 最终 head | `765f65a0769383a3f6719d7617f1e6dee7f57b9a` |
| Zeus 编排 SGLang / #63 | `49542794a358528c3d95c848cbdf0df33310e2ff` |
| triton_shared | `d78b531acacedeb002d72d72017f1abf1ed208c7` |
| Triton | `5321c2ebe470d2527078491642b136a13ab72c49` |
| CycleSim | `b39990784ba2e1324c258c1db5fb02c13f93953b` |
| CycleSim daemon SHA256 | `efdf5ee46eac45b7c6bc0f15641eb1e194bca7680d160eb3ab4ea5bc8a025ea6` |

合入后核对：测量版到 merge 的 GLM MoE 目录内 **21 个 Python 文件相同**；最终 PR head 到 merge 的 MoE/benchmark 指定范围 **71 个文件相同**。整理后还有 H200 资格门禁修复，整体仓库另有主线改动；不宣称整个执行环境相同，**没有在 merge SHA 上重新跑本轮全量测量**。

基线表使用固定版本数据生成，后续首页升级不会自动改写此表。H200 时间是 GPU 实测，Zeus 时间是周期换算；单位均为四卡 42 层 MoE 组件计算。

{{BASELINE_TABLE}}

Zeus 在这 15 档中观测最佳为 BS32；H200 为 BS128，仍位于扫描上界。选择 batch 使用 train，validation/test 只验证选择；公开主表汇总全部 49 点。

[固定版本 JSON](versions/20261104-1648b5c5/data/benchmark.json) · [固定 H200 49 点 CSV](versions/20261104-1648b5c5/data/h200-49-paired.csv) · [固定 Zeus 49 点 CSV](versions/20261104-1648b5c5/data/zeus-49-paired.csv) · [固定阶段 CSV](versions/20261104-1648b5c5/data/zeus-49-stages.csv)

## 09 · 验证覆盖与未覆盖的部分

- Zeus：361 项 MoE 回归；train00/step017、15 档、layer/rank `(3,0)/(5,15)/(44,4)` 的 45 项完整模式，通过实现参考、完整/本地 Router 逐位对照、Reduce exact、changed-input Graph；45 对完整/时序模式 cycles、输入/权重、Router 与语义 zbin 一致。
- 493,920 时序 case 完成、672 shard 全部通过覆盖与身份审计，**不等于 493,920 项完整数值通过**。
- 45 项完整模式中仍有 18 项解析 SiLU 预算超限：layer5/rank15 的 BS112/120/128，以及 layer44/rank4 的全部 15 档。原阈值不变。维护者反馈算法侧真实推理暂未发现相关问题，由 [#644](https://github.com/DarronTam/torch_zeus/issues/644) 跟踪；该反馈不替代新版本端到端验收。
- H200：全部正式 case 有 Graph/eager 和输入恢复 exact；历史 EP4 smoke 在边界 batch、首尾样本的 layer3/24/44 做 48 项分区/归并参考核对。参考保留相同 FP8/激活实现，不等于独立解析数学参考。
- 历史 H200 smoke 包含 step001，作为历史数值记录保留，不计入当前 49 点性能，也不重标为 step017。2026-11-05 回查旧 smoke/measurement 的 7 个执行源码 hash、6 个公共源码 hash、runtime 和模型元数据相同；脚本集仅 `plot.py` 不同。这是归档核对，不是本次重跑 GPU smoke。
- PR 最终 head `765f65a0` 的 [CI](https://github.com/DarronTam/torch_zeus/actions/runs/41834169767) 成功；另有 85 项 benchmark CPU 检查。新资格门禁会拒绝源码、kernel/runner 或 runtime 变化后的旧 smoke。冻结数据里的旧 CI 字段是发布快照，不能用它覆盖最终 head 的回执。
- 本轮未提供实卡 Zeus 通信、VCS/RTL 或完整模型速度/质量验收；H200 也未做新 backend 全面调优。

## 10 · 算法侧怎样与真实推理核对

建议先记录下表，再从共同的 BS16/32/64/128 和一个采样点开始逐层对照，而不是先比较最终两条吞吐曲线。

| 对齐项 | 需要提供或检查的内容 |
|---|---|
| 服务身份 | 模型 snapshot、config/index、SGLang/Torch/CUDA/Triton、实际 MoE backend/kernel、启动参数、源码改动 |
| 拓扑 | 实际 GPU 数、global TP、MoE EP/TP、Shared 放置、是否 fused shared、通信 backend |
| 工作负载 | prompt、上下文长度、生成位置、有效 decode batch、动态 batching、自然 EOS 与固定长度规则 |
| 计数 | 输出 tokens 还是含 prompt tokens；总吞吐还是每卡；BS 是全局还是每卡 |
| 时间 | 单层 MoE、42 层 MoE、完整 decode step、TPOT、TTFT 或整个服务窗口；是否包括等待与通信 |
| 执行 | Graph/eager、warmup、权重 cache、量化/激活函数、SM clocks、功率、并发 GPU 任务 |
| 路由 | 同层同输入的 Top-K IDs/weights、活跃 routed expert 数、每 expert token 数、各 EP 负载 |

核对顺序：

1. 用归档输入复现同一层、同一 batch 的 `forward_normal` 计时；对上 backend、量化、Shared 和 rank 时延。
2. 扩展到 42 个独立冻结层输入，并复用上文的逐层 max 与 pooled throughput 公式。
3. 在真实 decode 上分别记录 MoE 计算、通信、Attention/H1、其余调度与端到端时间。若存在重叠，用 trace 的实际关键路径，不直接把模块时间相加。
4. 最后更换为真实业务请求、动态 batch/EOS 分布，单独报告服务吞吐。此时输入和边界都已改变，不与组件曲线逐点混称同口径。

如果算法侧更换 H200 backend 或 quantization，应在 train 上选择配置，冻结后再测 holdout；不能保留旧 smoke 资格直接刷新性能。如果核对后仍有差异，优先提交 `(snapshot, source, batch, group, step, layer, rank, input hash, route hash, raw event/cycles)`，就能定位到具体测量点。

## 11 · 后续优化的对比约定与入口

**建议 baseline ID：`pr643-1648b5c5-owner-router-direct49`。** 原始输入、版本和测试结果按此基线保留，不把持续更新的首页当作唯一历史凭据。

- 固定输入、49 点规则、15 档、拓扑、统计公式与编译器/模拟器，再做单 kernel A/B；同时变更多项则注明“完整方案比较”。
- candidate 单独输出；保存 source/tool/binary/input hashes，原始数值门槛不变。先完整模式资格、再 full/timing 对照、再扩大周期矩阵。
- 新 H200 正式扫描先跑当前源码的 `--smoke`，再传 `--qualification`。原有数据目录中的 56 点 plan 不直接冒充新的 49 点计划。
- 核对唯一覆盖和失败数后，再生成 pooled throughput；同时给同档延迟、吞吐、变化百分比及最佳档位。固定基线表不随新结果覆盖。
- 不把旧 EP1 曲线、step001 单点曲线、仅 train00/step017 曲线或未完成的连续输入矩阵混入这个 baseline。

可复用入口（私有仓库，需要 torch_zeus 访问权限）：

- [配对采集、H200 EP4 测量和命令说明](https://github.com/DarronTam/torch_zeus/blob/765f65a0769383a3f6719d7617f1e6dee7f57b9a/sgl-kernel-zeus-triton/tests/cyclesim_performance/glm53_flash/moe/paired_benchmark/README.md)
- [H200 计时入口](https://github.com/DarronTam/torch_zeus/blob/765f65a0769383a3f6719d7617f1e6dee7f57b9a/sgl-kernel-zeus-triton/tests/cyclesim_performance/glm53_flash/moe/paired_benchmark/benchmark_h200.py)、[H200 汇总](https://github.com/DarronTam/torch_zeus/blob/765f65a0769383a3f6719d7617f1e6dee7f57b9a/sgl-kernel-zeus-triton/tests/cyclesim_performance/glm53_flash/moe/paired_benchmark/summarize.py)
- [Zeus 实测 flow worker](https://github.com/DarronTam/torch_zeus/blob/1648b5c5aad4654f14d66bb9ccbd96b02af72ae7/sgl-kernel-zeus-triton/tests/cyclesim_performance/glm53_flash/moe/paired_benchmark/flow_worker.py)、[冻结 SGLang 编排适配](https://github.com/DarronTam/torch_zeus/blob/1648b5c5aad4654f14d66bb9ccbd96b02af72ae7/sgl-kernel-zeus-triton/tests/cyclesim_performance/glm53_flash/moe/paired_benchmark/sglang_flow.py)
- [Notes 采样与统计脚本](https://github.com/Xuanwen-Wang/notes/tree/master/models/glm53-flash/scripts)

原始 tensor、权重和日志在服务器保留；91 shared 交接包及 H200 路径、hash 清单见 **PR #643 描述中的“合入基线与复现索引”**。公开 Notes 只提供数值、身份及测量方法，不复制原始请求或模型文件。
