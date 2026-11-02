# GLM-5.3-Flash MoE 性能与验证

固定地址：https://xuanwen-wang.github.io/notes/models/glm53-flash/

`page.template` 和 `assets/style.css` 维护正文与统一样式；`scripts/import_results.py`
从私有实验归档导出汇总，`scripts/build.py` 使用 Matplotlib 生成 PNG/SVG 和可离线阅读的 HTML。
不直接修改生成的 `index.html`。Python 构建依赖 Matplotlib 和 Noto Sans CJK 字体。

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

第一阶段固定 `train00 / step001`，不能看到测时后更换样本。全部扩展完成后导入器加
`--full56`，生成多组聚合与 train/validation/test 选择，保持总 token / 总时间公式，不能直接平均吞吐。
H200 56 组结果与 Zeus 单组曲线明确分开；不混用旧 H200 EP1 结果。

新轮次发布前，将本轮 JSON、CSV 和图表放入独立版本子目录，增加版本记录，保留固定入口。
公开数据禁止携带原始 prompt、凭据、内部地址或个人服务器路径。更新根目录 catalog.json，
检查桌面/手机、键盘、无 JS 和打印；Pages 构建成功后核对线上 HTML 与本地 SHA256。
