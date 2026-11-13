"""Catalog dates, categories, resources, and aliases must remain unambiguous."""

import json
import tempfile
import unittest
from pathlib import Path

from build_index import load_catalog


class CatalogPathsTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.repo = Path(self.directory.name)
        self.article = dict(id="example", file="articles/compiler/2026-10-28-example.html", category="compiler",
                            title="TritonShared - Example", date="2026-10-28",
                            created="2026-10-28", created_source="article", aliases=["example.html"],
                            description="Example model note", tags=["MoE"])
        target = self.repo / self.article["file"]
        target.parent.mkdir(parents=True)
        target.write_text("<title>TritonShared - Example</title>")
        (self.repo / "templates").mkdir()
        (self.repo / "templates/index.template").write_text("<!doctype html><html><body>{{ARTICLES}}</body></html>")

    def write_catalog(self, articles, resources=None):
        (self.repo / "catalog.json").write_text(json.dumps(dict(
            updated="2026-10-28", site_url="https://example.com/notes/",
            articles=articles, resources=resources or [])))

    def test_dated_categorized_article(self):
        self.write_catalog([self.article])
        self.assertEqual(load_catalog(self.repo)["articles"][0], self.article)

    def test_deployment_uses_explicit_model_identity(self):
        name = "articles/deployment/example/2026-10-28-example.html"
        (self.repo / self.article["file"]).unlink()
        (self.repo / name).parent.mkdir(parents=True)
        for model in ("GLM5.3Flash", "ExampleModelV2"):
            with self.subTest(model=model):
                article = dict(self.article, file=name, category="deployment", model=model,
                               title=f"{model} - Example")
                (self.repo / article["file"]).write_text(f"<title>{article['title']}</title>")
                self.write_catalog([article])
                self.assertEqual(load_catalog(self.repo)["articles"][0], article)

    def test_deployment_rejects_missing_or_mismatched_model(self):
        name = "articles/deployment/2026-10-28-example.html"
        (self.repo / self.article["file"]).unlink()
        (self.repo / name).parent.mkdir(parents=True, exist_ok=True)
        (self.repo / name).write_text("<title>TritonShared - Example</title>")
        for model in (None, "", " Model "):
            with self.subTest(model=model):
                self.write_catalog([dict(self.article, file=name, category="deployment", model=model)])
                with self.assertRaisesRegex(ValueError, "Model identity"):
                    load_catalog(self.repo)
        self.write_catalog([dict(self.article, file=name, category="deployment", model="OtherModel")])
        with self.assertRaisesRegex(ValueError, "Title must start"):
            load_catalog(self.repo)

    def test_unsafe_paths(self):
        for name in ("../outside.html", "/outside.html", "models/../outside.html",
                     "models//example/index.html", "models\\outside.html", "templates/index.html"):
            with self.subTest(name=name):
                self.write_catalog([dict(self.article, file=name)])
                with self.assertRaises(ValueError):
                    load_catalog(self.repo)

    def test_symlink_escape(self):
        with tempfile.TemporaryDirectory() as outside:
            link = self.repo / "articles/compiler/2026-10-28-escape.html"
            link.symlink_to(Path(outside) / "outside.html")
            self.write_catalog([dict(self.article, file=link.relative_to(self.repo).as_posix())])
            with self.assertRaises(ValueError):
                load_catalog(self.repo)

    def test_unlisted_article(self):
        self.write_catalog([])
        with self.assertRaisesRegex(ValueError, "unlisted"):
            load_catalog(self.repo)

    def test_duplicate_and_missing(self):
        self.write_catalog([self.article, self.article])
        with self.assertRaisesRegex(ValueError, "Duplicate"):
            load_catalog(self.repo)
        self.write_catalog([dict(self.article, file="articles/compiler/2026-10-28-missing.html")])
        with self.assertRaises(FileNotFoundError):
            load_catalog(self.repo)

    def test_generic_deployment_note(self):
        name = "articles/deployment/2026-10-28-example.html"
        (self.repo / self.article["file"]).unlink()
        (self.repo / name).parent.mkdir(parents=True, exist_ok=True)
        article = dict(self.article, file=name, category="deployment", title="模型部署 - Example")
        (self.repo / name).write_text("<title>模型部署 - Example</title>")
        self.write_catalog([article])
        self.assertEqual(load_catalog(self.repo)["articles"][0], article)

    def test_creation_date_is_independent_of_update_date(self):
        article = dict(self.article, date="2026-11-13")
        self.write_catalog([article])
        self.assertEqual(load_catalog(self.repo)["articles"][0]["created"], "2026-10-28")
        for change in (dict(created="2026-10-29"), dict(date="2026-10-27"),
                       dict(created_source="mtime")):
            with self.subTest(change=change):
                self.write_catalog([dict(self.article, **change)])
                with self.assertRaisesRegex(ValueError, "creation date"):
                    load_catalog(self.repo)

    def test_category_and_filename_must_match(self):
        self.write_catalog([dict(self.article, category="hardware")])
        with self.assertRaisesRegex(ValueError, "filename"):
            load_catalog(self.repo)

    def test_aliases_cannot_replace_homepage_or_escape(self):
        for alias in ("index.html", "../outside.html", "/outside.html",
                      self.article["file"], "example.html?query", "example?query.html",
                      "example/../old.html"):
            with self.subTest(alias=alias):
                self.write_catalog([dict(self.article, aliases=[alias])])
                with self.assertRaises(ValueError):
                    load_catalog(self.repo)
        self.write_catalog([dict(self.article, aliases=["example.html", "example.html"])])
        with self.assertRaisesRegex(ValueError, "duplicate alias"):
            load_catalog(self.repo)

    def test_resources_reject_symlinks_and_unregistered_html(self):
        resources = self.repo / "models/example/data"
        resources.mkdir(parents=True)
        with tempfile.TemporaryDirectory() as outside:
            link = resources / "escape.json"
            link.symlink_to(Path(outside) / "data.json")
            self.write_catalog([self.article], ["models/example/data"])
            with self.assertRaisesRegex(ValueError, "symlinks"):
                load_catalog(self.repo)


if __name__ == "__main__":
    unittest.main()
