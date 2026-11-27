"""Build the two paper PDFs with Pandoc and the Python Typst binding."""
import json
import os
from pathlib import Path
import re
import subprocess
from tempfile import TemporaryDirectory
from urllib.parse import urljoin

import typst

HERE = Path(__file__).resolve().parent
SOURCE_URL = "https://github.com/palvimaki/permutation-power-classes/blob/frontier-v1.0.1/research/frontier/"

LAYOUT = r'''
#set page(paper: "a4", margin: (top: 23mm, bottom: 23mm, left: 25mm, right: 25mm), numbering: "1")
#set text(size: 10.5pt, font: "New Computer Modern")
#set par(justify: true, leading: 0.68em)
#show heading.where(level: 2): it => block(above: 1.2em, below: 0.55em, text(size: 13pt, weight: "bold", it.body))
#show link: it => text(fill: rgb("234a72"), it)
'''


def build(stem, filename):
    source = (HERE / (stem + ".md")).read_text()
    title, _, article = source.split("\n\n", 2)
    title = title.removeprefix("# ")
    article = article.replace("## Result\n", "## The limit shape\n")
    article = re.sub(r"\\tag\{(\d+)\}", lambda m: r"\qquad\text{(" + m[1] + ")}", article)
    article = re.sub(r"\]\(([^()\s]+)\)", lambda m: "](" + urljoin(SOURCE_URL, m[1]) + ")", article)
    pandoc = os.environ.get("PANDOC", "pandoc")
    body = subprocess.run([pandoc, "--from=markdown+tex_math_dollars", "--to=typst", "--wrap=none"],
                          input=article, text=True, capture_output=True, check=True).stdout
    quote = json.dumps(title, ensure_ascii=False)
    header = '#set document(title: ' + quote + ')\n'
    header += LAYOUT
    header += '#align(center)[#set par(justify: false)\n#text(size: 18pt, weight: "bold", ' + quote + ')\n'
    header += '#v(4pt)\n#text(size: 9pt)[27 November 2026]]\n#v(9pt)\n'
    with TemporaryDirectory() as folder:
        temp = Path(folder) / "paper.typ"
        temp.write_text(header + body)
        typst.compile(str(temp), output=str(HERE / filename))


if __name__ == "__main__":
    build("LIMIT-SHAPE", "limit-shape.pdf")
    build("CLASSES", "fuss-catalan.pdf")
