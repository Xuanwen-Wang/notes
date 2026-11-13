# Notes 仓库工作约定

本仓库维护 GitHub Pages 静态技术笔记。先阅读 [README.md](README.md)、[CONTRIBUTING.md](CONTRIBUTING.md) 和 [目录规范](docs/repository-layout.md)，再修改相关文章或生成器。

## 语言与修改范围

- 对话和维护文档使用简体中文；代码、标识符与代码注释使用 English。
- 修改前检查 Git 状态，保留已有改动。使用 `apply_patch`，只暂存当前任务相关文件。
- 保持最小 diff，不对包含内嵌 SVG、数据和脚本的 HTML 整文件格式化。
- Commit 使用英文 Conventional Commits 和具体 scope，例如 `docs(Catalog): ...`。
- 对话中的本地路径使用绝对路径；仓库文档内使用可移植相对链接。
- 临时文件使用执行环境指定的 `TMPDIR`，缓存和构建产物不提交。`AGENTS.local.md` 是个人约定，不提交。

## 文章与目录

- `catalog.json` 是唯一文章清单。每篇文章具有稳定 `id`，正式 HTML 位于 `articles/<category>/`；模型文章再按模型分目录。
- 文件名使用 `created` 对应的 `YYYY-MM-DD-english-topic.html`。更新正文只调整 `date`，不滚动修改文件名日期。
- 记录 `created_source`：`article`、`filename` 或 `git`。无法证明原始写作日期时使用首次入库日期并注明。
- 分类、标题前缀和 HTML `<title>` 必须一致。通用部署文章不填写 `model`，使用 `模型部署 - ` 前缀。
- 改路径时将旧路径加入 `aliases`，保留既有 alias。旧地址兼容页只在发布目录生成。
- 新增公开下载目录或文件时登记 `resources`；正文内链使用正式文章路径，检查锚点与下载链接。
- 首页由 `templates/index.template` 生成。修改目录或模板后运行 `python3 scripts/build_index.py`，同步提交 `index.html`。

## 模型源码与证据

- 修改模型页面前阅读对应 `models/<model>/README.md`。三个生成页面通过 `write_article` 使用稳定 ID 查询输出路径并重定位资源链接。
- 修改模板、样式或脚本后同步生成正式 HTML，避免下次重建覆盖修复。
- 数值、统计公式、输入范围、源码/工具链 hash、频率和历史快照具有独立证据身份。目录整理保留原始 JSON、CSV、PNG、SVG 和性能结论。
- CycleSim、VCS/RTL、数值资格、CI 与完整模型验证分开表述。保留未覆盖项和失败记录，不放宽门禁或过滤样本。
- 私有草稿使用明确的外部 `--output` 路径，不登记到正式目录。

## 完成与发布

```bash
python3 -m unittest discover -s scripts -p 'test_*.py' -v
python3 scripts/build_site.py
git diff --check
```

根据改动范围补充模型自身测试与生成检查。目录迁移必须检查正文内链、章节锚点、下载，以及旧 URL 的 query/fragment 保留。

通过 `.github/workflows/pages.yml` 部署构建产物。保持既有站点和访问范围，等待对应 SHA 的部署成功，再核对线上字节与浏览器交互。最终说明修改、验证结果和未覆盖范围，并提供可直接打开的站点或文件链接。
