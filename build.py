#!/usr/bin/env python3
"""Build resume.md + resume.pdf from resume.yaml (single source of truth)."""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pyyaml", "-q"])
    import yaml

ROOT = Path(__file__).resolve().parent


def load():
    return yaml.safe_load((ROOT / "resume.yaml").read_text())


def write_markdown(data: dict) -> None:
    lines: list[str] = []
    lines.append(f"# {data['name']}<br>")
    lines.append(
        f"> Email: {data['email']} | Phone: {data['phone']}<br>\n"
        f"> Website: [{data['website']}]({data['website_url']}) | "
        f"GitHub: [@{data['github']}](https://github.com/{data['github']})<br>\n"
        f"> Location: {data['location']}"
    )
    lines.append("")
    lines.append("## Summary")
    lines.append("")
    lines.append(data["summary"].strip())
    lines.append("")
    lines.append("## Technical Skills")
    for s in data["skills"]:
        lines.append(f"- **{s['label']}:** {s['items']}")
    lines.append("")
    lines.append("## Professional Experience")
    lines.append("")
    for j in data["experience"]:
        lines.append(f"**{j['role']}**<br>")
        loc = f" · {j['location']}" if j.get("location") else ""
        lines.append(f"{j['org']} | {j['dates']}{loc}")
        lines.append("")
        for b in j["bullets"]:
            text = b
            for link in j.get("links") or []:
                text = text.replace(link["label"], f"[{link['label']}]({link['url']})")
            lines.append(f"- {text}")
        lines.append("")
    prev = " ".join(data["previously"].split())
    lines.append("**Previously**<br>")
    lines.append(f"> *{prev}*")
    lines.append("")
    lines.append("## Selected Open Source & Elsewhere")
    os_parts = [f"[{p['label']}]({p['url']})" for p in data["opensource"]]
    else_parts = [f"[{e['label']}]({e['url']})" for e in data["elsewhere"]]
    lines.append("- " + " · ".join(os_parts))
    lines.append("- " + " · ".join(else_parts))
    lines.append("")
    header = "<!-- Generated from resume.yaml — edit the YAML, then run: python3 build.py -->\n\n"
    (ROOT / "resume.md").write_text(header + "\n".join(lines))
    print(f"wrote {ROOT / 'resume.md'}")


def write_pdf() -> None:
    subprocess.check_call(
        ["typst", "compile", "--font-path", str(ROOT / "fonts"), str(ROOT / "resume.typ"), str(ROOT / "resume.pdf")],
    )
    print(f"wrote {ROOT / 'resume.pdf'}")


def main() -> None:
    data = load()
    write_markdown(data)
    write_pdf()


if __name__ == "__main__":
    main()
