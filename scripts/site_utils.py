"""Keep article URLs portable across source, publication, and legacy locations."""

import html
import json
from pathlib import PurePosixPath
import posixpath
import re
from html.parser import HTMLParser
from urllib.parse import quote, unquote, urlsplit, urlunsplit


def safe_path(repo, name):
    """Reject traversal and symlinks before a path reaches the publication tree."""
    path = PurePosixPath(name)
    if (not name or path.is_absolute() or path.as_posix() != name
            or ".." in path.parts or "\\" in name
            or any(part.startswith(".") for part in path.parts)
            or not (repo / name).resolve().is_relative_to(repo.resolve())):
        raise ValueError(f"Invalid site path: {name}")
    return repo / name


def aliases(catalog):
    return {name: article["file"]
            for article in catalog["articles"] for name in article["aliases"]}


def local_target(value, source, site_url):
    """Resolve project-site URLs without treating external URLs as local files."""
    parsed = urlsplit(html.unescape(value))
    site = urlsplit(site_url)
    if parsed.scheme or parsed.netloc:
        if (parsed.scheme not in ("http", "https") or parsed.netloc != site.netloc
                or not parsed.path.startswith(site.path)):
            return None
        path = parsed.path[len(site.path):]
    elif parsed.path.startswith("/"):
        if not parsed.path.startswith(site.path):
            return None
        path = parsed.path[len(site.path):]
    elif not parsed.path:
        return source, parsed
    else:
        path = posixpath.join(posixpath.dirname(source), parsed.path)
    target = posixpath.normpath(unquote(path))
    if target in ("", "."):
        target = "index.html"
    elif parsed.path.endswith("/"):
        target += "/index.html"
    if target == ".." or target.startswith("../") or target.startswith("/"):
        raise ValueError(f"Link escapes the site: {source}: {value}")
    return target, parsed


class PageLinks(HTMLParser):
    """Collect links and patch start tags without reformatting embedded reports."""

    def __init__(self, source, transform=None):
        super().__init__(convert_charrefs=False)
        self.references = []
        self.ids = set()
        self.replacements = []
        self.transform = transform
        self.offsets = [0]
        for line in source.splitlines(keepends=True):
            self.offsets.append(self.offsets[-1] + len(line))
        self.feed(source)

    def handle_starttag(self, tag, attrs):
        for key, value in attrs:
            if key == "id" or (tag == "a" and key == "name"):
                self.ids.add(value)
            if key in ("href", "src", "poster", "xlink:href") and value:
                self.references.append(value)
        if self.transform is None:
            return
        original = self.get_starttag_text()

        def replace(match):
            value = self.transform(html.unescape(match[3]))
            if value == html.unescape(match[3]):
                return match[0]
            return match[1] + match[2] + html.escape(value, quote=True) + match[2]

        rendered = re.sub(r"""(\b(?:href|src|poster)\s*=\s*)(["'])(.*?)\2""",
                          replace, original, flags=re.I | re.S)
        if rendered != original:
            line, column = self.getpos()
            start = self.offsets[line - 1] + column
            self.replacements.append((start, start + len(original), rendered))

    handle_startendtag = handle_starttag


def rewrite_links(source, source_file, target_file, catalog):
    """Rebase source-relative resources and resolve article aliases in one pass."""
    redirects = aliases(catalog)

    def transform(value):
        if value.startswith("#"):
            return value
        result = local_target(value, source_file, catalog["site_url"])
        if result is None:
            return value
        target, parsed = result
        target = redirects.get(target, target)
        relative = posixpath.relpath(target, posixpath.dirname(target_file) or ".")
        return urlunsplit(("", "", quote(relative), parsed.query, parsed.fragment))

    parser = PageLinks(source, transform)
    for start, end, replacement in reversed(parser.replacements):
        source = source[:start] + replacement + source[end:]
    return source


def write_article(repo, article_id, page, source_file):
    """Let generators retain source-relative assets while catalog owns URLs."""
    catalog = json.loads((repo / "catalog.json").read_text(encoding="utf-8"))
    matches = [a for a in catalog["articles"] if a["id"] == article_id]
    if len(matches) != 1:
        raise ValueError(f"Expected one article ID: {article_id}")
    name = matches[0]["file"]
    target = safe_path(repo, name)
    target.parent.mkdir(parents=True, exist_ok=True)
    source_name = source_file.relative_to(repo).as_posix()
    target.write_text(rewrite_links(page, source_name, name, catalog), encoding="utf-8")
    return target


def check_links(repo, pages, site_url):
    """Check actual targets and anchors, including generated legacy redirects."""
    parsed = {}

    def read(name):
        if name not in parsed:
            parsed[name] = PageLinks((repo / name).read_text(encoding="utf-8"))
        return parsed[name]

    failures = []
    for name in pages:
        for value in read(name).references:
            result = local_target(value, name, site_url)
            if result is None:
                continue
            target, url = result
            path = safe_path(repo, target)
            if not path.is_file():
                failures.append(f"{name}: missing {value}")
            elif url.fragment and path.suffix == ".html" and unquote(url.fragment) not in read(target).ids:
                failures.append(f"{name}: missing anchor {value}")
    if failures:
        raise ValueError("Broken local links:\n" + "\n".join(failures))
