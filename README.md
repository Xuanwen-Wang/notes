# 技术笔记

站点：[xuanwen-wang.github.io/notes](https://xuanwen-wang.github.io/notes/)

首页由 `catalog.json` 和 `templates/index.html` 生成：

```bash
python3 scripts/build_index.py
```

`catalog.json` 维护文章分类、完整标题、摘要、内容更新日期和标签。文章的 `<title>` 必须与目录一致；日期表示内容更新日期，不使用 checkout 后的文件 mtime。首页整理日期由顶层 `updated` 维护。

标题使用 `TritonShared - 主题`、`Zeus518硬件 - 主题`、`工具 - 主题`。TritonShared 包括编译、算子实现及部署实践。只保留持续维护的技术内容，临时组会及会议报告不收录。

新增文章时先补目录元数据，确保 HTML 文件、标题与分类一致。删除文章时同步删除目录条目。生成器会拒绝遗漏或重复收录的文件，避免静默丢文章。首页包含完整静态链接，搜索和分类筛选由内嵌 JavaScript 增强，不依赖外部字体或脚本。

本机 `pub` 检测到 `scripts/build_index.py` 后会使用本仓库模板重建首页。修改首页样式请编辑模板后重新生成，不直接修改 `index.html`。发布后检查 GitHub Pages 构建状态及线上文件的一致性。

持续维护的模型手册放在 `models/<model>/index.html`，配套正文模板、数据、图示与生成脚本留在同一个模型目录。根目录旧文章路径保持有效；新增模型页面也需登记到 `catalog.json`。
