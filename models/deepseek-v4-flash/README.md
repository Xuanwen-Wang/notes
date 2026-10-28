# DeepSeek V4 Flash 模型优化手册

固定入口：<https://xuanwen-wang.github.io/notes/models/deepseek-v4-flash/>。
当前章节为 MoE；后续 Attention、通信和整模型优化沿本模型目录扩展，不为每轮实验更换页面 URL。

## 文件结构

- `page.template`：可编辑正文、图示和稳定章节锚点。
- `assets/style.css`、`assets/app.js`：页面样式与逐 EP 交互。
- `data/2026-10-28.json`：冻结性能记录，含 27 batch / 108 EP 原始周期、固定基线及来源 SHA。
- `data/delivery-2026-10-28.json`：交付验证范围和结果；与冻结性能工具链分开。
- `scripts/build.py`：校验计时聚合、重算统计并生成可离线阅读的 `index.html`。
- `index.html`：发布产物，不直接编辑；样式、脚本、图表数据全部内嵌。

## 更新与发布

```bash
python3 models/deepseek-v4-flash/scripts/build.py
python3 scripts/build_index.py
python3 -m unittest discover -s scripts -p 'test_*.py'
git diff --check
```

测试会使用系统配置的 `TMPDIR`，运行前按所在机器的临时目录规范设置。更改页面标题、摘要或内容更新日期时，同步根目录 `catalog.json`。模型目录下的 HTML 必须全部进入目录登记；模板使用 `.template` 扩展名以免作为文章发布。

新增一轮测量时，保留旧日期数据和基线指纹，增加新 JSON 并更新生成器的数据入口及正文版本记录。禁止随着 rebase 隐式更新性能分母。记录 layout、source/compiler/simulator 提交、频率、计时范围、数值参考和排除项；交付 smoke 不能替代全矩阵性能。

提交前检查桌面/手机、键盘操作、禁用 JavaScript、离线和打印；确认 27 个样本可切换、双核表与最慢完整 EP 对应。发布后核对 GitHub Pages 的部署提交与线上 HTML/JSON 字节一致性。

本文公开可复核的测量摘要，不收录本机路径、内部地址或逐轮实验日志。未来章节保持既有锚点，适当增加目录项和独立数据文件。
