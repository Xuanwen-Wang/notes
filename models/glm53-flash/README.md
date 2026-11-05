# GLM-5.3-Flash AF分离最大MOE FFN吞吐评估

固定地址：https://xuanwen-wang.github.io/notes/models/glm53-flash/

算法侧测评说明源文件为 `methodology.template.md`，运行 `python3 models/glm53-flash/scripts/build_methodology.py`
生成同目录 `methodology.md` / `methodology.html`（依赖 `markdown-it-py`）。其基线表固定读取
`versions/20261104-1648b5c5/data/benchmark.json`，不随主页的新测量自动覆盖。
说明正文、源码/工具链身份或链接变化后重建 HTML 与根目录索引；服务器路径索引留在 PR 描述与 91 shared 归档。

`page.template` 和 `assets/style.css` 维护正文与统一样式；`scripts/import_timing.py`
从私有实验归档审计原始结果，再调用 `scripts/sampling_policy.py` 应用统一采样口径。
`scripts/build.py` 使用 Matplotlib 生成 PNG/SVG 和可离线阅读的 HTML。
不直接修改生成的 `index.html`。Python 构建依赖 Matplotlib 和 Noto Sans CJK 字体。

页面按「49 点总体吞吐 → Kernel 组成（先介绍，再吞吐率、耗时与增长图）→ 采样协议 → 验证 → 历史」组织。
删除单点性能区和重复的 H200 单独曲线；原始数据与历史导出图继续归档。
桌面侧边目录由 `assets/navigation.js` 跟随阅读位置高亮，手机改为顶部横向导航。
明细表默认折叠，caption 说明行、列、单位与统计范围；每张图同时标明 X/Y 轴和 49 点范围。

全部五张图共用 `assets/charts.js` 和 `assets/charts.css`。生成器把每张图的真实序列以
JSON 内嵌到 HTML；交互图和 Matplotlib 下载图使用相同序列，不平滑、不改写数据。
支持逐曲线显示、只看一条、显示全部、点值、batch选择、鼠标/触摸与方向键查看精确数值。
阶段吞吐图默认同时收紧纵轴上下限，突出所选曲线的变化；显式标明实际范围与非零起点。
勾选“纵轴从 0 开始”可恢复绝对比例视图，其他图默认仍从零开始。
关闭“随筛选缩放纵轴”可固定为全部曲线的范围；两种视图均保留真实数值与线性刻度。
吞吐主图默认显示点值，P10/P90 分布放入明细表。图例放在图外；PNG/SVG 下载始终包含完整曲线。
吞吐主图下方附 `Zeus / H200` 比值柱图，共用 batch 横轴、悬停、键盘与选点状态。
比值使用同档两条完整精度的汇总吞吐相除，不是逐采样点比值的均值；1× 为持平线。
蓝柱表示 Zeus 较高或持平，绿柱表示 H200 较高。曲线筛选与纵轴选项仅影响上图，
下图和读数卡始终保留双方数值及比值。`chart(..., ratio=('zeus', 'h200'))` 同步生成双面板 PNG/SVG。
脚本与样式内嵌，无 CDN 依赖；禁用 JavaScript 时保留静态 SVG，仍可离线阅读和打印。

阶段吞吐图使用 `总 BS × 频率 ÷ 该阶段 42 层平均 cycles ÷ 4`，按模型输入 token 计数，
不乘 Top-K 或层数。原始周期先对 49 点汇总，再求吞吐；不平均各样本的吞吐。
它只计单个阶段的时间，不是端到端或流水线吞吐。图中可见曲线由 `initialVisible` 指定，
此图默认显示 Routed / Shared / Reduce；Router 可勾选，避免数量级差异压扁其他曲线。
`build.py` 同步生成 `data/kernel-throughput.csv`、峰值/回落表与相邻档变化；图表、表格和 CSV 共用一份计算结果。

```bash
python3 models/glm53-flash/scripts/import_timing.py --h200 H200_ARCHIVE --baseline FULL_CAMPAIGN --timing TIMING_CAMPAIGN --out NEW_EXPORT
# Copy benchmark.json, throughput.csv, h200-49-paired.csv, zeus-49-paired.csv,
# and zeus-49-stages.csv from NEW_EXPORT into models/glm53-flash/data.
MPLCONFIGDIR="$TASK_TMP/matplotlib" python3 models/glm53-flash/scripts/build.py
python3 scripts/build_index.py
git diff --check
```

`TASK_TMP` 应由执行环境指定为有足够空间的任务临时目录。
导入器只允许完整 42 层 × 16 rank 的 batch 进入 Zeus 曲线；同组 H200/Zeus hidden hash
必须一致，源码版本不得混用，原实现参考与 Graph 门禁不得失败。未完成档位保留空值。
解析数学预算超限与原实现参考分开记录，不能通过过滤 case 隐藏。

2026-11-03 按维护者明确要求修订口径：排除所有 `step001`；保留 17、33、49、65、81、97、113。
每档 49 点 = 7 批请求 × 7 个 decode 索引；当前页面只以 49 点总体统计展示性能。
此调整发生在查看原始路由分布之后，作为公开的协议版本变化记录；不推断旧采集损坏。
H200、Zeus、各 batch、train/validation/test 和全部 kernel 曲线使用同一过滤规则。
新采集由 PR #643 的 `prepare.py` 默认使用七步并拒绝 step001；旧冻结包不改写。

`import_timing.py` 是原始 56 点冻结活动的审计适配器：仍核验 564,480 个回执及历史
step001 完整数值基线，再强制应用采样策略，输出当前 493,920 case 的 49 点性能报告。
新增的 `audited-timing-samples.json` 保留每个点的 stage 周期，便于重算；私有归档留存该文件。
`sampling_policy.py` 既接受完整 56 点，也接受已过滤的 49 点，拒绝残缺矩阵、重复点及未知 step。
新活动需先由适配器完成身份、输入和数值资格审计，再复用此统计策略；不要伪造旧活动的完成回执。
`build.py` 只接受带排除策略的 schema v2，阻止旧导入器意外重新发布 step001。
原 `import_results.py` 仅用作历史数值基线导出，不直接发布；其单点数值资格不可移植到 step017。
保留总 token / 总时间公式及 train/validation/test 选择，不直接平均吞吐，不混用 H200 EP1 结果。

新轮次发布前，将本轮 JSON、CSV 和图表放入独立版本子目录，增加版本记录，保留固定入口。
公开数据禁止携带原始 prompt、凭据、内部地址或个人服务器路径。更新根目录 catalog.json，
检查桌面、键盘、无 JS 和打印；按维护者要求不再检查手机端。Pages 构建成功后核对线上 HTML 与本地 SHA256。

新版 Routed 的 49 点重测使用 `scripts/import_revision.py`：输入已有发布数据与私有活动中
经过原始记录/hash 校验的 `comparison.json`、`identity.json`、`complete.json`、`qualification.json`。
脚本验证完整矩阵、源码/模拟器/worker/资格绑定、旧统计一致性及非 Routed 阶段不变，复用
现有 pooled-throughput、分位数和 train/holdout 统计。可用 `--ci` 传入对应 SHA 的完整 CI 回执。
它不替代私有原始记录审计；不得只手工生成这四个 JSON 来绕过资格和输入校验。
公开导出只包含数值统计与 hash，不复制含私有路径的 identity 原文。

```bash
PYTHONDONTWRITEBYTECODE=1 python3 models/glm53-flash/scripts/import_revision.py \
  --baseline PREVIOUS_PUBLIC_DATA --evidence AUDITED_CAMPAIGN_EXPORT --ci CI_RECEIPT --out NEW_EXPORT
```

`versions/20261103-e93a57a7/` 保留旧版 49 点数据和四张图，
`versions/20261103-b6148f98/` 保存新 Routed 的数据和四张图。固定页面入口展示新版本。

2026-11-04 的统一本地 Router → raw-word gather → direct transport 测量使用
`scripts/import_flow.py` 导入。当前版本目录为 `versions/20261104-1648b5c5/`；
49 点 × 15 档 × 42 层 × 16 rank 的 493,920 个时序 case 已全部完成。
测量源码保持 `1648b5c5`，整理后的 PR head 为代码等价的 `f4ce26ea`，不能重标旧回执。

导入器核验 `summary/identity/complete` 与数值资格、逐模式比较、回归回执、
源码记录和工具链文件的 hash 绑定；重算各档均值、分位数及 train/holdout 选择，
并保留 H200 数据原样。私有原始日志审计由本轮 `export.py` 完成，公开导入器不代替它。
导出数据只保留公开字段和 hash，不复制服务器路径。当前 CI 可以尚在执行，页面
如实展示其发布时快照；数值、时序、CI 是独立证据。

```bash
PYTHONDONTWRITEBYTECODE=1 python3 models/glm53-flash/scripts/import_flow.py \
  --baseline PREVIOUS_PUBLIC_DATA --evidence AUDITED_CAMPAIGN_EXPORT \
  --qualification NUMERIC_QUALIFICATION --numerical MODE_COMPARISON \
  --regression REGRESSION_RECEIPT --source COMMITTED_SOURCE \
  --equivalence SOURCE_EQUIVALENCE --toolchain TOOLCHAIN_MANIFEST \
  --ci CURRENT_PR_CI --out NEW_EXPORT
```

将导出的 JSON / CSV 同步到 `data/` 后，重建五张图、HTML 与目录首页，并将这一轮
导出和图表复制到独立版本目录。`flow-revision.json` / `flow-comparison.csv` 是完整方案
对照；流程、sigmoid 和编译器同时变化，Router IDs 不保证相同，不能标成 Routed 单独
优化 A/B。历史 `routed-revision.json` 与历史五档表保留原值，且只在版本记录中引用。
当前临界路径为 `sum_layer(max_owner(Router) + max_rank(Shared + Routed + Reduce))`；
阶段表仍逐阶段独立取最大 rank，用于诊断，不可相加代替完整 MoE 时间。
