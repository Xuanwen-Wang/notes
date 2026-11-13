# DeepSeek V4 Flash 模型优化手册

正式页面：[2026-10-28-moe-optimization.html](../../articles/deployment/deepseek-v4-flash/2026-10-28-moe-optimization.html)。
原固定入口 <https://xuanwen-wang.github.io/notes/models/deepseek-v4-flash/> 由发布流程生成兼容跳转。
当前章节为 MoE；后续 Attention、通信和整模型优化沿该模型扩展，创建日期和正式 URL 保持稳定。

## 文件结构

- `page.template`：可编辑正文、图示和稳定章节锚点。
- `assets/style.css`、`assets/app.js`：页面样式与 BS × 43 层 × 16 rank 交互。
- `assets/*.png`：已有真实 Viewer 导出；构建时核对 SHA 并内嵌，保留版本标签和原始轴。
- `data/2026-11-05.json`：仅在最终组合交付完成后写入的真实采集结果；草稿阶段不创建。
- `data/2026-10-28.json`：历史 27 随机 batch / 108 EP 原件，只在历史折叠区展示。
- `data/delivery-2026-10-28.json`：历史交付原件，与当前测量完全分开。
- `scripts/build.py`：校验新 schema、重算所有聚合，按 catalog 的稳定 ID 生成正式 HTML。
- `scripts/test_build.py`：覆盖跨 rank 拼接、慢核、重复 / 缺 case、计时 / 数值混淆与预览误发布等反例。
- `../../articles/deployment/deepseek-v4-flash/2026-10-28-moe-optimization.html`：发布产物，不直接编辑；样式、脚本、图表数据全部内嵌。

## 更新与发布

```bash
export TMPDIR=/data/wangxw/tmp TMP=/data/wangxw/tmp TEMP=/data/wangxw/tmp
python3 models/deepseek-v4-flash/scripts/build.py
python3 -m unittest discover -s models/deepseek-v4-flash/scripts -p 'test_*.py'
python3 scripts/build_index.py
python3 -m unittest discover -s scripts -p 'test_*.py'
git diff --check
```

最终 JSON 不存在时，默认构建明确失败。私有中间版只能显式生成带水印草稿；预览 JSON 放在任务私有目录，不写入 `data/2026-11-05.json`：

```bash
python3 models/deepseek-v4-flash/scripts/build.py --data /absolute/private/preview.json --preview --output /absolute/private/preview.html
```

`status=preview` 必须加 `--preview`，`status=final` 必须不加。HTML 数据、图片、CSS 和脚本全部内嵌，无网络请求即可交互。正式生成前替换最终 2064 case、source/tool 身份、数值差集、mode 收据与 Viewer 图，不能将中间版性能继承给最终源码。

测试使用系统配置的 `TMPDIR`。更改页面标题、摘要或内容更新日期时，同步根 `catalog.json` 并重建首页；私有草稿使用明确的外部输出路径。模型源码目录维护 `.template`，正式文章集中在 `articles/`。

## 真实采集数据 schema v2

顶层必须包含：

- `schema_version: 2`、`kind: dsv4-moe-real-capture`、`status: preview|final`、`measurement_id`、日期与显示标签。
- `clock_hz: 400000000`；`scope` 显式记录 BS16/24/32、43 层、16 rank、step17、history4096、H4096/I512/topk6/E256、Zeus TP4×EP4、H200 TP1×EP4 和 `compute_only`。
- `implementation` 记录该组**实际测量**的数学 / 调度 profile、产品文件 SHA；未确定的 commit/PR 保持 null，不补造链接。
- `tools`、`sources` 记录 compiler/simulator/reference 和原交付 JSON 的 SHA，不包含本机路径、IP、输入或权重内容。
- `denominators.master.totals_ms` 是 2026-11-04 冻结原始 baseline，固定为 13.612195 / 22.518230 / 29.645385；这里的 schema key `master` 不表示最新 master 同工具重测。`h200.totals_ms` 固定为 8.701847 / 9.827390 / 10.746829，不随源码版本滚动。
- `denominators.provenance` 保存冻结原始 baseline 的 source/compiler/Triton/CycleSim commit、实际工具 binary SHA 和原报告/summary SHA，以及 H200 三轮、拓扑、dynamic FP8 block128 和原 artifact SHA。当前使用不同源与工具链，百分比只表示跨冻结实现与工具链的总变化，不能归因于纯 kernel 单变量优化。
- `cases` 恰好包含 BS×layer×rank 的 2064 个唯一坐标。每个 case 保存 `bs/layer/rank/cycles`、四 stage，以及每 stage 的 `cycles` 和 `launches`。每个 launch 保存实际 kernel、launch ID、双核原始 `core_cycles: [c0,c1]` 及 `cycles=max(c0,c1)`。本 profile 四个窗口各一次业务 compute；窗口外 `fill_bf16` 不进入 stage。
- `cases[].evidence` 保存原收据与输入/权重的 SHA，以及 `router_fp64_pass=true`、`ffn_numerical_pass=false`。SHA 只关联原记录，不发布输入或权重内容。
- `summary` 是每 BS 的 cycles/ms 和四 stage 分解，构建器必须从 case 数组重算后逐项一致。
- `qualification.cpu` 分开写 `initial_cases`、`additional_critical_cases`、`unique_cases`、`graph_replays`；`critical` 单列 129 个 critical case 的数值、Graph、pointwise 与最大 L2；`mode` 单列 6 full / 6 timing，绑定六个 CPU 资格点已验的 12 次 Graph，不增加唯一 Graph 计数；`matrix` 单列 2064 timing、2064 Router FP64、native completion 和明确的 FFN numerical false。
- `figures` 为已存在 PNG 的相对路径、来源 measurement_id、SHA、标题与说明；图与表版本不同必须显式 `reference_only=true` 并标出不同身份。正文计时统一 ms；真实 Viewer 保留原 cycle 轴并给出 ms 区间，轴跨度与完整 native 耗时分开。

聚合严格为 `sum_layer(max_rank(sum_stage(sum_launch(max_core(cycles)))))`，除以 400000 转 ms。tie 取低 rank；同层四个 stage 始终来自同一个整链最慢 rank。没有各 stage 跨 rank 独立取 max，也没有跨层平均替代 43 层总和。

新增测量时保留旧日期数据和基线指纹。记录 layout、source/compiler/simulator、频率、计时范围、数值参考和排除项；2064 timing-only 不当作全部 FFN 数值 PASS。历史 GLM 随机测量只保留在独立折叠区。

提交前检查桌面/手机、键盘、禁用 JavaScript、离线和打印；确认 3×43×16 可切换、默认整链 critical rank 与双核表一致，以及九个原锚点存在。发布后由发布者核对 Pages 部署提交与线上 HTML/JSON 字节一致性。

本文公开可复核的测量摘要，不收录本机路径、内部地址或逐轮实验日志。未来章节保持既有锚点，适当增加目录项和独立数据文件。
