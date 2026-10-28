"""Catalog paths must support model notes without escaping the publication tree."""

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
        self.article = dict(file="models/example/index.html", category="compiler",
                            title="TritonShared - Example", date="2026-10-28",
                            description="Example model note", tags=["MoE"])
        target = self.repo / self.article["file"]
        target.parent.mkdir(parents=True)
        target.write_text("<title>TritonShared - Example</title>")

    def write_catalog(self, articles):
        (self.repo / "catalog.json").write_text(json.dumps(dict(updated="2026-10-28", articles=articles)))

    def test_nested_model_article(self):
        self.write_catalog([self.article])
        self.assertEqual(load_catalog(self.repo)["articles"][0], self.article)

    def test_unsafe_paths(self):
        for name in ("../outside.html", "/outside.html", "models/../outside.html",
                     "models//example/index.html", "models\\outside.html", "templates/index.html"):
            with self.subTest(name=name):
                self.write_catalog([dict(self.article, file=name)])
                with self.assertRaises(ValueError):
                    load_catalog(self.repo)

    def test_symlink_escape(self):
        with tempfile.TemporaryDirectory() as outside:
            link = self.repo / "models/escape.html"
            link.symlink_to(Path(outside) / "outside.html")
            self.write_catalog([dict(self.article, file="models/escape.html")])
            with self.assertRaises(ValueError):
                load_catalog(self.repo)

    def test_unlisted_model_article(self):
        self.write_catalog([])
        with self.assertRaisesRegex(ValueError, "unlisted"):
            load_catalog(self.repo)

    def test_duplicate_and_missing(self):
        self.write_catalog([self.article, self.article])
        with self.assertRaisesRegex(ValueError, "Duplicate"):
            load_catalog(self.repo)
        self.write_catalog([dict(self.article, file="models/missing.html")])
        with self.assertRaises(FileNotFoundError):
            load_catalog(self.repo)


if __name__ == "__main__":
    unittest.main()
