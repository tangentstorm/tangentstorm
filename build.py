#!/usr/bin/env python3
"""Build resume.md + resume.pdf from resume.yaml (single source of truth),
and cover-letter.pdf from cover-letter.md (via generated cover-letter.typ)."""
from __future__ import annotations

import re
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
    lines.append(f"# {data['name']}")
    lines.append("")
    lines.append(f"*{data['tagline']}*")
    lines.append("")
    lines.append(
        f"{data['email']} · {data['phone']} · {data['location']}<br>\n"
        f"[{data['website']}]({data['website_url']}) · "
        f"[github.com/{data['github']}](https://github.com/{data['github']})"
    )
    lines.append("")
    lines.append("## Summary")
    lines.append("")
    lines.append(data["summary"].strip())
    lines.append("")
    lines.append("## Technical Skills")
    lines.append("")
    for s in data["skills"]:
        lines.append(f"- **{s['label']}:** {s['items']}")
    lines.append("")
    lines.append("## Professional Experience")
    lines.append("")
    for j in data["experience"]:
        lines.append(f"### {j['role']}")
        loc = f" · {j['location']}" if j.get("location") else ""
        lines.append(f"{j['org']}{loc} · {j['dates']}")
        lines.append("")
        for b in j["bullets"]:
            text = b
            for link in j.get("links") or []:
                text = text.replace(link["label"], f"[{link['label']}]({link['url']})")
            lines.append(f"- {text}")
        lines.append("")
    prev = " ".join(data["previously"].split())
    lines.append("### Previously")
    lines.append(prev)
    lines.append("")
    lines.append("## Open Source & Elsewhere")
    lines.append("")
    os_parts = [f"[{p['label']}]({p['url']})" for p in data["opensource"]]
    else_parts = [f"[{e['label']}]({e['url']})" for e in data["elsewhere"]]
    lines.append("- **Open source:** " + " · ".join(os_parts))
    lines.append("- **Elsewhere:** " + " · ".join(else_parts))
    lines.append("")
    header = "<!-- Generated from resume.yaml — edit the YAML, then run: python3 build.py -->\n\n"
    (ROOT / "resume.md").write_text(header + "\n".join(lines))
    print(f"wrote {ROOT / 'resume.md'}")


def write_pdf() -> None:
    subprocess.check_call(
        ["typst", "compile", "--font-path", str(ROOT / "fonts"), str(ROOT / "resume.typ"), str(ROOT / "resume.pdf")],
    )
    print(f"wrote {ROOT / 'resume.pdf'}")


def write_cover_letter_pdf() -> None:
    write_cover_letter_typ()
    subprocess.check_call(
        ["typst", "compile", "--font-path", str(ROOT / "fonts"), str(ROOT / "cover-letter.typ"), str(ROOT / "cover-letter.pdf")],
    )
    print(f"wrote {ROOT / 'cover-letter.pdf'}")


# ---------------------------------------------------------------------------
# cover-letter.md -> cover-letter.typ (generated; do not edit the .typ by hand)
# ---------------------------------------------------------------------------

TYP_PREAMBLE = """// GENERATED from cover-letter.md — do not edit by hand. Run: python3 build.py

#let ink = rgb("#121212")
#let muted = rgb("#5c5c5c")
#let accent = rgb("#8a4b2e")
#let accent-deep = rgb("#6b3a24")

#set page(paper: "us-letter", margin: (top: 0.8in, bottom: 0.75in, x: 1in))
#set text(font: "Libertinus Serif", size: 11pt, fill: ink)
#set par(spacing: 1em, leading: 0.58em, justify: true)
#show link: it => text(fill: accent-deep, it)
#set list(
  indent: 0em,
  body-indent: 0.5em,
  marker: text(fill: accent, size: 5pt, baseline: -0.15em)[●],
  spacing: 0.6em,
)

#let inter(..args) = text(font: ("Inter", "Liberation Sans"), ..args)

"""

EMAIL_RE = r'[\w.+-]+@[\w-]+(?:\.[\w-]+)+'
PHONE_RE = r'\(\d{3}\)\s*\d{3}-\d{4}'


def typ_esc(s: str) -> str:
    """Escape Typst markup specials in plain text."""
    return re.sub(r'([@#$<>\[\]_*`\\])', r'\\\1', s)


def md_inline_to_typst(md: str) -> str:
    """Inline markdown ([text](url), **bold**, bare URLs, emails) -> Typst."""
    out: list[str] = []
    pat = re.compile(
        r'\[([^\]]+)\]\(([^)\s]+)\)'  # [text](url)
        r'|\*\*([^*]+)\*\*'           # **bold**
        r'|(https?://[^\s<>\]\)]+)'   # bare URL
        r'|(' + EMAIL_RE + r')'       # email
    )
    pos = 0
    for m in pat.finditer(md):
        out.append(typ_esc(md[pos:m.start()]))
        label, url, bold, bare, email = m.group(1, 2, 3, 4, 5)
        if label is not None:
            out.append('#link("%s")[%s]' % (url, typ_esc(label)))
        elif bold is not None:
            out.append('*%s*' % typ_esc(bold))
        elif bare is not None:
            clean = bare.rstrip('.,;:')
            out.append('#link("%s")[%s]%s' % (clean, typ_esc(clean), typ_esc(bare[len(clean):])))
        else:
            out.append('#link("mailto:%s")[%s]' % (email, typ_esc(email)))
        pos = m.end()
    out.append(typ_esc(md[pos:]))
    return ''.join(out)


def _classify_contact(s: str) -> tuple[str, str]:
    s = s.strip()
    if re.fullmatch(EMAIL_RE, s):
        return ('email', s)
    if re.fullmatch(r'https?://\S+', s):
        return ('url', s)
    if re.fullmatch(r'(?:www\.)?[a-z0-9-]+(?:\.[a-z0-9-]+)+(?:/\S*)?', s, re.I):
        return ('domain', s)
    return ('text', s)


def _render_contact_item(kind: str, val: str) -> str:
    if kind == 'email':
        return '#link("mailto:%s")[%s]' % (val, typ_esc(val))
    if kind in ('domain', 'url'):
        url = val if val.startswith('http') else 'https://' + val
        return '#link("%s")[%s]' % (url, typ_esc(val))
    return typ_esc(val)


def render_header(block: list[str]) -> str:
    """First md block -> centered name/contact header. Segments split on '·'."""
    text = ' '.join(l.strip() for l in block)
    segs = [s.strip() for s in text.split('·')]
    m = re.match(r'^([A-Z][a-z]+ [A-Z]\. [A-Z][a-z]+)\s*(.*)$', segs[0])
    name = m.group(1) if m else segs[0]
    items: list[tuple[str, str]] = []
    if m and m.group(2).strip():
        items.append(('text', m.group(2).strip()))
    for seg in segs[1:]:
        pm = re.search(PHONE_RE, seg)
        if pm:
            pre, post = seg[:pm.start()].strip(), seg[pm.end():].strip()
            if pre:
                items.append(_classify_contact(pre))
            items.append(('phone', pm.group(0)))
            if post:
                items.append(_classify_contact(post))
        else:
            items.append(_classify_contact(seg))
    line1 = [it for it in items if it[0] in ('text', 'email', 'phone')]
    line2 = [it for it in items if it[0] in ('domain', 'url')]
    parts = [
        '#align(center)[',
        '  #inter(weight: "bold", size: 20pt, fill: ink, tracking: -0.6pt)[%s] \\' % typ_esc(name),
        '  #v(0.25em)',
        '  #inter(size: 9pt, fill: muted)[%s] \\' % ' · '.join(_render_contact_item(k, v) for k, v in line1),
    ]
    if line2:
        parts.append('  #inter(size: 9pt, fill: muted)[%s]' % ' · '.join(_render_contact_item(k, v) for k, v in line2))
    parts.append(']')
    parts.append('#v(0.6em)')
    parts.append('#line(length: 100%, stroke: 1pt + accent)')
    parts.append('#v(0.9em)')
    return '\n'.join(parts)


def md_to_typst_body(md: str) -> str:
    """Block-level markdown -> Typst. '### ' headings switch to small type."""
    blocks: list[list[str]] = []
    cur: list[str] = []
    for ln in md.split('\n'):
        if ln.strip() == '':
            if cur:
                blocks.append(cur)
                cur = []
        else:
            cur.append(ln)
    if cur:
        blocks.append(cur)

    chunks: list[str] = []
    small = False
    for i, b in enumerate(blocks):
        if i == 0:
            chunks.append(render_header(b))
            continue
        if len(b) == 1 and b[0].strip() == '---':
            small = False
            chunks.append('#v(1.2em)\n#line(length: 100%, stroke: 0.5pt + accent)\n#v(0.3em)')
            continue
        if b[0].startswith('### '):
            small = True
            chunks.append('#inter(size: 7pt, weight: "bold", fill: accent-deep, tracking: 1.2pt)[%s]' % typ_esc(b[0][4:].strip().upper()))
            continue
        if b[0].startswith('## '):
            small = False
            chunks.append('#text(size: 11pt, weight: "bold", fill: ink)[%s]' % typ_esc(b[0][3:].strip()))
            continue
        if all(l.startswith('- ') for l in b):
            items = '\n'.join('- %s' % md_inline_to_typst(l[2:]) for l in b)
            if small:
                chunks.append('#[\n#set text(size: 8pt, fill: muted)\n#set list(spacing: 0.35em)\n%s\n]' % items)
            else:
                chunks.append(items)
            continue
        para = md_inline_to_typst(' '.join(l.strip() for l in b))
        if para.startswith('Best regards,'):
            # "Best regards, Name" -> signature on two lines, like a real letter
            chunks.append('#v(0.6em)\nBest regards,\\\n' + para[len('Best regards,'):].strip())
        elif small:
            chunks.append('#text(size: 8pt, fill: muted)[%s]' % para)
        else:
            chunks.append(para)
    return '\n\n'.join(chunks)


def write_cover_letter_typ() -> None:
    md = (ROOT / 'cover-letter.md').read_text()
    (ROOT / 'cover-letter.typ').write_text(TYP_PREAMBLE + md_to_typst_body(md))
    print(f"wrote {ROOT / 'cover-letter.typ'}")


def main() -> None:
    data = load()
    write_markdown(data)
    write_pdf()
    write_cover_letter_pdf()


if __name__ == "__main__":
    main()
