"""Exercise migration boundaries that can break existing published links."""

import json
from pathlib import Path
import tempfile
import unittest

from build_site import build_site
from site_utils import check_links, rewrite_links


class PublicationTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.repo = Path(self.directory.name)
        self.name = "articles/deployment/example/2026-10-28-example.html"
        self.catalog = dict(
            updated="2026-11-13", site_url="https://example.com/notes/",
            resources=["models/example/data"],
            articles=[dict(id="example", file=self.name, category="deployment", model="Example",
                           title="Example - Note", description="Example", created="2026-10-28",
                           created_source="git", date="2026-11-13", tags=["example"],
                           aliases=["old.html", "models/example/index.html"])])
        page = self.repo / self.name
        page.parent.mkdir(parents=True)
        page.write_text('<title>Example - Note</title><h1 id="topic">Topic</h1>'
                        '<a href="../../../models/example/data/sample.csv">Download</a>')
        (self.repo / "models/example/data").mkdir(parents=True)
        (self.repo / "models/example/data/sample.csv").write_text("value\n1\n")
        (self.repo / "templates").mkdir()
        (self.repo / "templates/index.template").write_text("<!doctype html><html><body>{{ARTICLES}}</body></html>")
        (self.repo / "catalog.json").write_text(json.dumps(self.catalog))

    def test_build_keeps_aliases_out_of_source_and_copies_downloads(self):
        (self.repo / "AGENTS.md").write_text("Source instructions")
        build_site(self.repo)
        output = self.repo / "dist"
        self.assertTrue((output / self.name).is_file())
        self.assertEqual((output / "models/example/data/sample.csv").read_text(), "value\n1\n")
        for alias in ("old.html", "models/example/index.html"):
            self.assertFalse((self.repo / alias).exists())
            redirect = (output / alias).read_text()
            self.assertIn("location.search", redirect)
            self.assertIn("location.hash", redirect)
        self.assertFalse((output / "AGENTS.md").exists())
        self.assertFalse((output / "scripts").exists())
        self.assertFalse((output / "templates").exists())
        before = {p.relative_to(output): p.read_bytes() for p in output.rglob("*") if p.is_file()}
        build_site(self.repo)
        self.assertEqual(before, {p.relative_to(output): p.read_bytes() for p in output.rglob("*") if p.is_file()})

    def test_rebasing_retains_queries_fragments_and_script_payloads(self):
        source = ('<a href="./index.html?mode=1#topic">Read</a>'
                  '<a href="../../">Home</a><img src="data/chart.svg">'
                  '<script>const text=\'<a href="index.html">\';</script>')
        result = rewrite_links(source, "models/example/index.html", self.name, self.catalog)
        self.assertIn('href="2026-10-28-example.html?mode=1#topic"', result)
        self.assertIn('href="../../../index.html"', result)
        self.assertIn('src="../../../models/example/data/chart.svg"', result)
        self.assertIn('<script>const text=\'<a href="index.html">\';</script>', result)
        check_links(self.repo, [self.name], self.catalog["site_url"])

    def test_missing_downloads_and_anchors_fail_publication(self):
        for link in ("../../../models/example/data/missing.csv", "#missing"):
            with self.subTest(link=link):
                (self.repo / self.name).write_text(f'<title>Example - Note</title><a href="{link}">Read</a>')
                with self.assertRaisesRegex(ValueError, "Broken local links"):
                    build_site(self.repo)

    def test_unowned_output_and_source_directories_are_preserved(self):
        output = self.repo / "dist"
        output.mkdir()
        (output / "personal.txt").write_text("keep")
        with self.assertRaisesRegex(ValueError, "not owned"):
            build_site(self.repo)
        self.assertEqual((output / "personal.txt").read_text(), "keep")
        with self.assertRaisesRegex(ValueError, "Output must"):
            build_site(self.repo, self.repo / "templates")

    def test_failed_validation_preserves_previous_build(self):
        build_site(self.repo)
        previous = (self.repo / "dist" / self.name).read_bytes()
        (self.repo / self.name).write_text('<title>Example - Note</title><a href="missing.csv">Read</a>')
        with self.assertRaisesRegex(ValueError, "Broken local links"):
            build_site(self.repo)
        self.assertEqual((self.repo / "dist" / self.name).read_bytes(), previous)


if __name__ == "__main__":
    unittest.main()
