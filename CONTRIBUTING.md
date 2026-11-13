# 新增、更新与发布笔记

## 新增文章

1. 选择 `deployment`、`compiler`、`hardware` 或 `tools`。部署文章可按模型建立子目录。
2. 在 `articles/<category>/` 写入 `YYYY-MM-DD-english-topic.html`。采用 UTF-8、相对链接与完整 HTML 文档。
3. 在 `catalog.json` 增加条目，例如：

```json
{
  "id": "example-topic",
  "file": "articles/compiler/2026-11-13-example-topic.html",
  "category": "compiler",
  "title": "TritonShared - 示例主题",
  "description": "说明文章的具体问题、方法和适用范围。",
  "created": "2026-11-13",
  "created_source": "article",
  "date": "2026-11-13",
  "tags": ["Lowering", "数据流"],
  "aliases": []
}
```

`id` 不随标题、内容更新或目录迁移改变。模型专属文章增加 `model` 并使用 `<model> - 主题`；通用部署文章使用 `模型部署 - 主题`。

4. 将新增公开下载文件或目录登记到顶层 `resources`。模型模板、脚本和公开实验资料在 `models/<model>/` 维护。
5. 更新顶层 `updated`，重建首页并执行检查。

## 更新与迁移

正文更新时调整 `date`；`created`、创建日期前缀和 `id` 保持稳定。更正错误日期需要记录依据。

修改路径时，将上一个正式路径追加到 `aliases`，同步正文引用和生成脚本。旧 alias 长期保留；构建器拒绝重复 alias、覆盖首页、目录逃逸和无归属的 HTML。

生成页面修改模板后重建。`scripts/site_utils.py` 的 `write_article` 从 catalog 查询输出路径；模板资源路径以模型源码目录为基准，输出时转换为正式文章目录的相对路径。`#章节` 链接保持当前页面语义。

## 验证

```bash
python3 -m unittest discover -s scripts -p 'test_*.py' -v
python3 scripts/build_site.py
git diff --check
git diff -- catalog.json index.html
```

检查实际修改文件，清理格式噪声与无关生成物。构建器在 `dist/` 生成完整站点和兼容页，并校验正式文章、日期、标题、资源、内链与锚点。

模型页面按其 README 运行对应测试；重建图表时执行 `python3 -m pip install -r requirements-models.txt`。GLM 图表另需 Noto Sans CJK JP 字体。图像字节可能受字体和依赖版本影响；目录整理保留已发表的数据和图表原件。

浏览器检查首页分类、大小写与多关键词搜索、空结果恢复、文章目录、图表、下载和旧地址带锚点的跳转。页面结构变化时检查窄屏与禁用 JavaScript 的静态链接。

## 发布与验收

按实际文件显式暂存并提交；不提交 `dist/`、私有原始日志、凭据、内部地址或个人服务器路径。

`master` 推送后，GitHub Actions 自动检查并部署 `dist/`。站点构建仅依赖 Python 标准库，使用已提交的文章与公开资料；模型重建在内容更新时单独执行。`pub index` 可调用本仓库首页生成器，正式发布以 Actions 部署结果为准。

检查对应 commit 的工作流和部署状态，并比较线上首页、文章、catalog 与关键下载文件和本地构建产物。迁移还需验证旧 URL 返回兼容页、跳转到正确文章并保留 query/fragment。

Pages 发布来源使用 `GitHub Actions`，可在仓库 `Settings → Pages` 查看。旧分享链接的跳转文件是部署产物，不重新复制到源码根目录。
