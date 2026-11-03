# GLM-5.3-Flash AF分离最大MOE FFN吞吐评估

固定地址：https://xuanwen-wang.github.io/notes/models/glm53-flash/

`page.template` 和 `assets/style.css` 维护正文与统一样式；`scripts/import_results.py`
从私有实验归档导出汇总，`scripts/build.py` 使用 Matplotlib 生成 PNG/SVG 和可离线阅读的 HTML。
不直接修改生成的 `index.html`。Python 构建依赖 Matplotlib 和 Noto Sans CJK 字体。

全部六张图共用 `assets/charts.js` 和 `assets/charts.css`。生成器把每张图的真实序列以
JSON 内嵌到 HTML；交互图和 Matplotlib 下载图使用相同序列，不平滑、不改写数据。
支持逐曲线显示、只看一条、显示全部、点值、batch选择、鼠标/触摸与方向键查看精确数值。
默认纵轴从零开始，上限随所选曲线调整；关闭“随筛选缩放纵轴”可固定为完整图的刻度。
H200 P10/P90 阴影随所属曲线显示。图例放在图外；PNG/SVG 下载始终包含完整曲线。
脚本与样式内嵌，无 CDN 依赖；禁用 JavaScript 时保留静态 SVG，仍可离线阅读和打印。

```bash
python3 models/glm53-flash/scripts/import_results.py --h200 H200_ARCHIVE --zeus ZEUS_CAMPAIGN --out models/glm53-flash/data
MPLCONFIGDIR="$TASK_TMP/matplotlib" python3 models/glm53-flash/scripts/build.py
python3 scripts/build_index.py
git diff --check
```

`TASK_TMP` 应由执行环境指定为有足够空间的任务临时目录。
导入器只允许完整 42 层 × 16 rank 的 batch 进入 Zeus 曲线；同组 H200/Zeus hidden hash
必须一致，源码版本不得混用，原实现参考与 Graph 门禁不得失败。未完成档位保留空值。
解析数学预算超限与原实现参考分开记录，不能通过过滤 case 隐藏。

第一阶段固定 `train00 / step001`，不能看到测时后更换样本。当前56组时序矩阵使用
`scripts/import_timing.py --h200 H200_ARCHIVE --baseline FULL_CAMPAIGN --timing TIMING_CAMPAIGN --out OUTPUT`
导入；时序样本与完整模式数值/Graph资格分开统计。保留多组聚合与 train/validation/test 选择，
保持总 token / 总时间公式，不能直接平均吞吐。旧 `import_results.py --full56` 仅适用于完整数值模式归档。
H200 56 组结果与 Zeus 单组曲线明确分开；不混用旧 H200 EP1 结果。

新轮次发布前，将本轮 JSON、CSV 和图表放入独立版本子目录，增加版本记录，保留固定入口。
公开数据禁止携带原始 prompt、凭据、内部地址或个人服务器路径。更新根目录 catalog.json，
检查桌面/手机、键盘、无 JS 和打印；Pages 构建成功后核对线上 HTML 与本地 SHA256。
