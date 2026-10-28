#!/usr/bin/env python3
"""Build the portable notes homepage from explicit, stable article metadata."""

import html
import json
import re
import sys
from datetime import date
from pathlib import Path, PurePosixPath
from urllib.parse import quote

CATEGORIES = {
    "compiler": ("TritonShared", "编译与算子", "从 IR 变换到 kernel 实现，沿着编译管线理解优化。"),
    "hardware": ("Zeus518硬件", "硬件与架构", "从 RTL、数据通路与时序，理解硬件的工作方式。"),
    "tools": ("工具", "工具与实践", "把日常使用、部署和定制的方法整理成手册。"),
}


def load_catalog(repo):
    """Reject incomplete metadata so publishing cannot silently misclassify a note."""
    catalog = json.loads((repo / "catalog.json").read_text(encoding="utf-8"))
    date.fromisoformat(catalog["updated"])
    articles = catalog["articles"]
    seen = set()
    for article in articles:
        name = article["file"]
        path = PurePosixPath(name)
        # Model notes have stable subdirectories; catalog paths must stay portable
        # and inside this repository, including when a symlink is present.
        if (path.is_absolute() or path.as_posix() != name or ".." in path.parts
                or "\\" in name or not name.endswith(".html") or name == "index.html"
                or (len(path.parts) > 1 and path.parts[0] != "models")
                or not (repo / name).resolve().is_relative_to(repo.resolve())):
            raise ValueError(f"Invalid article filename: {name}")
        if name in seen:
            raise ValueError(f"Duplicate article: {name}")
        seen.add(name)
        prefix = CATEGORIES[article["category"]][0] + " - "
        if not article["title"].startswith(prefix):
            raise ValueError(f"Title must start with {prefix!r}: {name}")
        date.fromisoformat(article["date"])
        source = (repo / name).read_text(encoding="utf-8")
        match = re.search(r"<title>(.*?)</title>", source, flags=re.S | re.I)
        if not match or html.unescape(match[1]) != article["title"]:
            raise ValueError(f"Article <title> must match catalog.json: {name}")
        if not article["description"] or not article["tags"]:
            raise ValueError(f"Description and tags are required: {name}")
    published = {path.name for path in repo.glob("*.html") if path.name != "index.html"}
    published.update(path.relative_to(repo).as_posix() for path in (repo / "models").rglob("*.html"))
    if seen != published:
        raise ValueError(f"Update catalog.json; unlisted={published - seen}, missing={seen - published}")
    return catalog


def build_index(repo):
    """Render static links first; JavaScript only enhances search and filtering."""
    catalog = load_catalog(repo)
    articles = catalog["articles"]
    sections = []
    for category, (prefix, label, description) in CATEGORIES.items():
        notes = sorted((a for a in articles if a["category"] == category),
                       key=lambda a: a["date"], reverse=True)
        rows = []
        for article in notes:
            title = html.escape(article["title"])
            tags = "".join(f'<span>{html.escape(tag)}</span>' for tag in article["tags"])
            search = html.escape(" ".join([article["title"], article["description"], *article["tags"]]), quote=True)
            rows.append(f'''<article class="note" data-search="{search}">
  <div class="note-main"><h3><a href="./{quote(article['file'])}">{title}</a></h3>
  <p>{html.escape(article['description'])}</p><div class="tags">{tags}</div></div>
  <div class="note-meta"><time datetime="{article['date']}">{article['date']}</time><span aria-hidden="true" class="arrow">↗</span></div>
</article>''')
        sections.append(f'''<section class="category" data-category="{category}" aria-labelledby="heading-{category}">
  <div class="section-heading"><div><span class="section-index">0{len(sections) + 1}</span><h2 id="heading-{category}">{label}</h2><span class="section-count">{len(notes):02d}</span></div><p>{description}</p></div>
  <div class="note-list">{''.join(rows)}</div>
</section>''')
    counts = {key: sum(a["category"] == key for a in articles) for key in CATEGORIES}
    replacements = {
        "ARTICLES": "\n".join(sections),
        "TOTAL": str(len(articles)),
        "UPDATED": catalog["updated"],
        **{f"COUNT_{key.upper()}": str(value) for key, value in counts.items()},
    }
    page = (repo / "templates/index.html").read_text(encoding="utf-8")
    for key, value in replacements.items():
        page = page.replace("{{" + key + "}}", value)
    if re.search(r"\{\{[A-Z_]+\}\}", page):
        raise ValueError("Unresolved homepage template field")
    (repo / "index.html").write_text(page, encoding="utf-8")
    return len(articles)


if __name__ == "__main__":
    root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path(__file__).resolve().parents[1]
    print(build_index(root))
