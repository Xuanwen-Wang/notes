# GLM-5.3-Flash AF分离最大MOE FFN吞吐评估

固定地址：https://xuanwen-wang.github.io/notes/models/glm53-flash/

`page.template` 和 `assets/style.css` 维护正文与统一样式；`scripts/import_timing.py`
从私有实验归档审计原始结果，再调用 `scripts/sampling_policy.py` 应用统一采样口径。
`scripts/build.py` 使用 Matplotlib 生成 PNG/SVG 和可离线阅读的 HTML。
不直接修改生成的 `index.html`。Python 构建依赖 Matplotlib 和 Noto Sans CJK 字体。

页面按「49 点总体吞吐 → 四个 kernel 介绍和三张阶段图 → 采样协议 → 验证 → 历史」组织。
删除单点性能区和重复的 H200 单独曲线；原始数据与历史导出图继续归档。
桌面侧边目录由 `assets/navigation.js` 跟随阅读位置高亮，手机改为顶部横向导航。
明细表默认折叠，caption 说明行、列、单位与统计范围；每张图同时标明 X/Y 轴和 49 点范围。

全部四张图共用 `assets/charts.js` 和 `assets/charts.css`。生成器把每张图的真实序列以
JSON 内嵌到 HTML；交互图和 Matplotlib 下载图使用相同序列，不平滑、不改写数据。
支持逐曲线显示、只看一条、显示全部、点值、batch选择、鼠标/触摸与方向键查看精确数值。
默认纵轴从零开始，上限随所选曲线调整；关闭“随筛选缩放纵轴”可固定为完整图的刻度。
吞吐主图默认显示点值，P10/P90 分布放入明细表。图例放在图外；PNG/SVG 下载始终包含完整曲线。
脚本与样式内嵌，无 CDN 依赖；禁用 JavaScript 时保留静态 SVG，仍可离线阅读和打印。

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
