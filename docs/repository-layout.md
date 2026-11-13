# 目录、日期与兼容地址

## 2026-11-13 整理结果

文章统一放到 `articles/`，按 `deployment`、`compiler`、`hardware`、`tools` 分模块；模型专属内容位于部署模块的模型子目录。“性能优化的三个层次”归入通用模型部署。

`models/` 保留模型模板、样式、脚本、公开数据和历史图表；正式 HTML 输出到 `articles/`。`templates/` 使用 `.template` 后缀。源码根目录仅保留生成的首页 HTML。

## 日期依据

`created` 表示原文章日期，`date` 表示内容更新时间。迁移优先采用原文件名中的日期，标记 `created_source: filename`；没有原始日期时，采用 `git log --follow --reverse` 中的首次入库日期，标记 `git`。新文章可由作者确认日期并标记 `article`。

首次入库日期是现有仓库可核对的最早记录，不等同于已证明的原始写作日期。GLM 吞吐页使用 2026-11-02，DeepSeek 手册使用 2026-10-28；2026-11-09、2026-11-05 继续作为它们的内容更新时间。

## 地址迁移表

以下旧地址在部署时生成兼容页；模型原目录地址同时由其 `index.html` 兼容页承接。

| 旧路径 | 正式路径 | 日期依据 |
| --- | --- | --- |
| `ZeusV3_Deployment_Perf_Optimization.html` | `articles/deployment/2026-09-07-performance-optimization-layers.html` | 首次入库 |
| `models/glm53-flash/index.html` | `articles/deployment/glm53-flash/2026-11-02-moe-ffn-throughput.html` | 首次入库 |
| `2026-11-05-glm53flash-dsa-kvcache.html` | `articles/deployment/glm53-flash/2026-11-05-dsa-kvcache-attention.html` | 原文件名 |
| `models/glm53-flash/methodology.html` | `articles/deployment/glm53-flash/2026-11-05-moe-benchmark-methodology.html` | 首次入库 |
| `models/glm53-flash/routed-global-grouping.html` | `articles/deployment/glm53-flash/2026-11-11-routed-global-grouping.html` | 首次入库 |
| `models/deepseek-v4-flash/index.html` | `articles/deployment/deepseek-v4-flash/2026-10-28-moe-optimization.html` | 首次入库 |
| `2026-09-01-moe-ffn-flow-visual-guide.html` | `articles/compiler/2026-09-01-moe-ffn-flow-visual-guide.html` | 原文件名 |
| `2026-09-03-batch-scalar-dma-loads-explained.html` | `articles/compiler/2026-09-03-batch-scalar-dma-loads-explained.html` | 原文件名 |
| `2026-09-08-device-fused-uscale-gemm.html` | `articles/compiler/2026-09-08-device-fused-uscale-gemm.html` | 原文件名 |
| `2026-09-14-gather-parent-acquire-first.html` | `articles/compiler/2026-09-14-gather-parent-acquire-first.html` | 原文件名 |
| `2026-09-14-small-row-gather-lowering-explained.html` | `articles/compiler/2026-09-14-small-row-gather-lowering-explained.html` | 原文件名 |
| `2026-10-30-sigmoid-silu-fitting.html` | `articles/compiler/2026-10-30-sigmoid-silu-fitting.html` | 原文件名 |
| `ldg-bandwidth-explained-2026-10-15.html` | `articles/hardware/2026-10-15-ldg-bandwidth-explained.html` | 原文件名 |
| `2026-11-03-zccl-allreduce-pblink.html` | `articles/hardware/2026-11-03-zccl-allreduce-pblink.html` | 原文件名 |
| `codex-switch-guide.html` | `articles/tools/2026-09-07-codex-switch-guide.html` | 首次入库 |

## 构建与发布边界

`scripts/build_index.py` 校验目录并生成首页；`scripts/build_site.py` 校验内链和锚点，复制正式页面与声明的公开资源，在 `dist/` 生成兼容页。兼容页使用浏览器跳转，保留 query 和章节 fragment，为禁用 JavaScript 的读者提供链接。

GitHub Actions 发布 `dist/`。README、AGENTS、模板和 Python 脚本不进入部署产物；已有公开下载文件与历史快照维持原路径。新增文章继续按 catalog 登记。

校验范围是仓库内文件、章节锚点和下载。三篇既有文章（Device-Fused UScale GEMM、Gather C1/C2、四行 Gather）含内网 GitLab 源码引用，外网读者可能无法访问；本次保留原引用。后续替换这些外部链接时需核对公开源码的对应版本。
