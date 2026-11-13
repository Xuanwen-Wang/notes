# 技术笔记

[阅读站点](https://xuanwen-wang.github.io/notes/) · [新增与更新文章](CONTRIBUTING.md) · [目录与迁移说明](docs/repository-layout.md) · [Agent 约定](AGENTS.md)

模型部署、TritonShared 编译与算子、Zeus518 硬件及工具的长期技术笔记。首页支持分类和搜索，文章保留可离线阅读的正文、图表与证据边界。

## 仓库结构

```text
.
├── articles/                   # 正式文章：创建日期-英文主题.html
│   ├── deployment/             # 通用部署文章与各模型子目录
│   │   ├── glm53-flash/
│   │   └── deepseek-v4-flash/
│   ├── compiler/               # TritonShared 编译与算子
│   ├── hardware/               # Zeus518 硬件、架构、集合通信
│   └── tools/                  # 工具使用与实践
├── models/                     # 模型模板、生成脚本、公开数据与图表
├── scripts/                    # 目录校验、链接处理、站点构建与测试
├── templates/                  # 首页模板；使用 .template 后缀
├── docs/                       # 仓库维护与迁移说明
├── .github/workflows/pages.yml # 自动检查与 GitHub Pages 发布
├── catalog.json                # 文章身份、路径、分类、日期、旧地址与资源
└── index.html                  # 生成的站点首页
```

正式文章 HTML 全部位于 `articles/`；根目录仅保留首页 `index.html`。旧地址的兼容 HTML 由构建器生成到 `dist/`，不在源码中保留副本。

## 日期与标题

- 文件名为 `YYYY-MM-DD-english-topic.html`，日期来自 `created`，文章更新后文件名保持稳定。
- `created` 是原文章日期；无法确认原始写作日期时，使用首次入库日期并将 `created_source` 标为 `git`。迁移依据见[说明](docs/repository-layout.md)。
- `date` 表示内容更新时间，首页按此排序；顶层 `updated` 表示目录整理日期。均不读取文件 mtime。
- 编译、硬件、工具标题分别使用 `TritonShared - `、`Zeus518硬件 - `、`工具 - `；通用部署文章使用 `模型部署 - `，模型文章使用 `<model> - `。

## 本地检查与预览

站点构建和目录测试仅依赖 Python 3.10+ 标准库。在仓库根目录执行：

```bash
python3 -m unittest discover -s scripts -p 'test_*.py' -v
python3 scripts/build_site.py
git diff --check
python3 -m http.server 8000 --bind 127.0.0.1 --directory dist
```

预览地址为 `http://127.0.0.1:8000/`。`dist/` 已被 Git 忽略，包含首页、正式文章、声明的公开资源和旧地址跳转页。构建会检查文章清单、标题、日期、分类、资源、内链和章节锚点。

## 模型页面

静态文章直接维护 `articles/` 中的 HTML。以下三个页面由模型源码生成，修改对应模板后重建：

| 页面 | 生成命令 | 源码说明 |
| --- | --- | --- |
| GLM MoE 吞吐 | `python3 models/glm53-flash/scripts/build.py` | [GLM 维护说明](models/glm53-flash/README.md) |
| GLM 测评方法 | `python3 models/glm53-flash/scripts/build_methodology.py` | 固定 PR #643 基线 |
| DeepSeek V4 MoE | `python3 models/deepseek-v4-flash/scripts/build.py` | [DeepSeek 维护说明](models/deepseek-v4-flash/README.md) |

重建模型页面时安装 `requirements-models.txt` 中的依赖；GLM 图表另需 Noto Sans CJK JP 字体。源码中的相对资源链接由公共工具重定位到正式文章路径。日常站点发布使用已提交的 HTML 与公开数据。

## 发布

`master` 推送后，GitHub Actions 执行测试、构建与内链检查、确认首页已同步，随后上传 `dist/` 并部署 Pages。Pull Request 执行检查和构建。

发布后核对对应提交的 Actions 成功、线上内容一致，并实际检查分类、搜索、图表和旧地址跳转。完整流程见 [CONTRIBUTING.md](CONTRIBUTING.md)。
