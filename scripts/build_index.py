#!/usr/bin/env python3
"""Build the portable notes homepage from explicit, stable article metadata."""

import html
import json
import re
import sys
from datetime import date
from pathlib import Path
from urllib.parse import quote, urlsplit

# The local publishing wrapper loads this file with runpy from another checkout.
sys.path.insert(0, str(Path(__file__).resolve().parent))
from site_utils import safe_path

CATEGORIES = {
    "deployment": ("模型部署", "模型部署", "按模型梳理数据流、并行策略与性能方案，保留可核对的验证边界。"),
    "compiler": ("TritonShared", "编译与算子", "从 IR 变换到 kernel 实现，沿着编译管线理解优化。"),
    "hardware": ("Zeus518硬件", "硬件与架构", "从 RTL、数据通路与时序，理解硬件的工作方式。"),
    "tools": ("工具", "工具与实践", "把日常使用、部署和定制的方法整理成手册。"),
}


def load_catalog(repo):
    """Reject incomplete metadata so publishing cannot silently misclassify a note."""
    catalog = json.loads((repo / "catalog.json").read_text(encoding="utf-8"))
    date.fromisoformat(catalog["updated"])
    site = urlsplit(catalog["site_url"])
    if (site.scheme != "https" or not site.netloc or not site.path.endswith("/")
            or site.query or site.fragment or site.username):
        raise ValueError("site_url must be an HTTPS site root ending in /")
    articles = catalog["articles"]
    seen = set()
    identifiers = set()
    legacy = set()
    for article in articles:
        name = article["file"]
        path = safe_path(repo, name)
        category = article["category"]
        if (not name.startswith(f"articles/{category}/")
                or not re.fullmatch(r"\d{4}-\d{2}-\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*\.html", path.name)):
            raise ValueError(f"Invalid article filename: {name}")
        if name in seen:
            raise ValueError(f"Duplicate article: {name}")
        seen.add(name)
        identifier = article["id"]
        if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", identifier) or identifier in identifiers:
            raise ValueError(f"Invalid or duplicate article ID: {identifier}")
        identifiers.add(identifier)
        created = date.fromisoformat(article["created"])
        updated = date.fromisoformat(article["date"])
        if (not path.name.startswith(created.isoformat() + "-") or created > updated
                or article["created_source"] not in ("article", "filename", "git")):
            raise ValueError(f"Invalid creation date or provenance: {name}")
        prefix_name = CATEGORIES[category][0]
        if category == "deployment" and "model" in article:
            prefix_name = article["model"]
            if not isinstance(prefix_name, str) or not prefix_name.strip():
                raise ValueError(f"Model identity is required: {name}")
            if prefix_name != prefix_name.strip():
                raise ValueError(f"Model identity must not have surrounding whitespace: {name}")
        prefix = prefix_name + " - "
        if not article["title"].startswith(prefix):
            raise ValueError(f"Title must start with {prefix!r}: {name}")
        source = (repo / name).read_text(encoding="utf-8")
        match = re.search(r"<title>(.*?)</title>", source, flags=re.S | re.I)
        if not match or html.unescape(match[1]) != article["title"]:
            raise ValueError(f"Article <title> must match catalog.json: {name}")
        if not article["description"] or not article["tags"]:
            raise ValueError(f"Description and tags are required: {name}")
        for alias in article["aliases"]:
            safe_path(repo, alias)
            if (not alias.endswith(".html") or alias == "index.html"
                    or alias.startswith("articles/") or alias in legacy
                    or urlsplit(alias).query or urlsplit(alias).fragment):
                raise ValueError(f"Invalid or duplicate alias: {alias}")
            legacy.add(alias)
    # Only the homepage is exempt from the dated, categorized article tree.
    published = {path.relative_to(repo).as_posix() for path in repo.rglob("*.html")
                 if path.relative_to(repo).parts[0] not in ("dist", "output", ".git", ".venv")
                 and path != repo / "index.html"}
    if seen != published:
        raise ValueError(f"Update catalog.json; unlisted={published - seen}, missing={seen - published}")
    for resource in catalog["resources"]:
        path = safe_path(repo, resource)
        if not path.exists() or path.is_symlink():
            raise ValueError(f"Invalid resource: {resource}")
        files = path.rglob("*") if path.is_dir() else [path]
        for item in files:
            if item.is_symlink() or item.suffix == ".html":
                raise ValueError(f"Resources cannot contain HTML or symlinks: {item.relative_to(repo)}")
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
        "TOPICS": str(len(CATEGORIES)),
        "UPDATED": catalog["updated"],
        **{f"COUNT_{key.upper()}": str(value) for key, value in counts.items()},
    }
    page = (repo / "templates/index.template").read_text(encoding="utf-8")
    for key, value in replacements.items():
        page = page.replace("{{" + key + "}}", value)
    if re.search(r"\{\{[A-Z_]+\}\}", page):
        raise ValueError("Unresolved homepage template field")
    (repo / "index.html").write_text(page, encoding="utf-8")
    return len(articles)


if __name__ == "__main__":
    root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path(__file__).resolve().parents[1]
    print(build_index(root))
