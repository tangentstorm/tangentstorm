# Resume

Single source of truth: [`resume.yaml`](./resume.yaml). Layout: [`resume.typ`](./resume.typ).

## Latest downloads

CI publishes built files to a fixed, mutable release tag named **`resume`** (not versioned releases):

- PDF: https://github.com/tangentstorm/tangentstorm/releases/download/resume/resume.pdf
- Markdown: https://github.com/tangentstorm/tangentstorm/releases/download/resume/resume.md
- Release page: https://github.com/tangentstorm/tangentstorm/releases/tag/resume

## Local build

```bash
# requires: typst, python3-yaml
python3 build.py
```

This writes `resume.md` and `resume.pdf` (gitignored). Edit the YAML/Typst sources only.
