// Layout for resume.yaml. All content lives in the YAML; run: python3 build.py

#let data = yaml("resume.yaml")

#let ink = rgb("#121212")
#let muted = rgb("#5c5c5c")
#let soft = rgb("#f4f1ec")
#let accent = rgb("#8a4b2e")
#let accent-deep = rgb("#6b3a24")

#set page(
  paper: "us-letter",
  margin: (top: 0.55in, bottom: 0.5in, x: 0.55in),
)
#set text(font: "Libertinus Serif", size: 10.6pt, fill: ink, hyphenate: false)
#set par(leading: 0.5em, spacing: 0.6em)
#show link: it => text(fill: accent-deep, it)

#let inter(..args) = text(font: ("Inter", "Liberation Sans"), ..args)

// One section-label style for both columns: small caps label over a hairline.
#let section-label(title, above: 0em) = block(above: above, below: 0.55em, {
  set block(spacing: 0pt)
  box(inter(weight: "bold", size: 7.6pt, fill: accent-deep, tracking: 1.4pt, upper(title)))
  v(0.3em)
  line(length: 100%, stroke: 0.7pt + accent)
})

#let rail-group(label, body) = block(below: 0.75em, {
  set block(spacing: 0pt)
  inter(weight: "semibold", size: 8.4pt, fill: ink, label)
  v(0.28em)
  body
})

#let job(j, first: false) = block(above: if first { 0em } else { 1.45em }, breakable: false, {
  // Role and dates share a baseline; org/location sits directly beneath.
  set block(spacing: 0pt)
  grid(
    columns: (1fr, auto),
    column-gutter: 1em,
    inter(weight: "bold", size: 10.4pt, fill: ink, j.role),
    inter(size: 8.6pt, fill: muted, j.dates),
  )
  v(0.32em)
  inter(
    size: 8.8pt,
    fill: muted,
    j.org + if "location" in j and j.location != none { "  ·  " + j.location } else { "" },
  )
  v(0.6em)
  set list(
    indent: 0.1em,
    body-indent: 0.5em,
    spacing: 0.5em,
    marker: text(fill: accent, size: 5pt, baseline: -0.15em)[●],
  )
  set par(leading: 0.45em)
  let links = if "links" in j { j.links } else { none }
  for (i, b) in j.bullets.enumerate() {
    if i == 0 and links != none {
      list.item[#b #text(fill: muted)[(#links.map(l => link(l.url, l.label)).join[, ])]]
    } else {
      list.item(b)
    }
  }
})

#let left-rail = {
  set par(leading: 0.42em, spacing: 0pt)

  section-label("Contact")
  set par(leading: 0.55em)
  block(below: 0.7em, inter(size: 8.5pt, fill: ink)[
    #link("mailto:" + data.email, data.email) \
    #data.phone \
    #data.location
  ])
  inter(size: 8.5pt)[
    #link(data.website_url, data.website) \
    #link("https://github.com/" + data.github)[github.com/#data.github]
  ]

  section-label("Skills", above: 1.8em)
  for s in data.skills {
    rail-group(s.label, inter(size: 8.4pt, fill: muted, s.items))
  }

  section-label("Open Source", above: 1.4em)
  inter(size: 8.5pt)[#data.opensource.map(p => link(p.url, p.label)).join(linebreak())]

  section-label("Elsewhere", above: 1.8em)
  inter(size: 8.5pt)[#data.elsewhere.map(e => link(e.url, e.label)).join(linebreak())]
}

#let main-col = {
  section-label("Summary")
  data.summary.trim()

  section-label("Experience", above: 1.8em)
  for (i, j) in data.experience.enumerate() {
    job(j, first: i == 0)
  }

  v(1.7em)
  block(
    width: 100%,
    inset: (left: 0.7em, y: 0.25em),
    stroke: (left: 1.6pt + accent),
    {
      set block(spacing: 0pt)
      inter(weight: "bold", size: 7.6pt, fill: accent-deep, tracking: 1.4pt)[PREVIOUSLY]
      v(0.45em)
      text(size: 9.2pt, fill: muted, par(leading: 0.48em, data.previously.trim()))
    },
  )
}

// Header: name and tagline over a full-width rule.
#block(below: 0pt, {
  set block(spacing: 0pt)
  inter(weight: "bold", size: 28pt, fill: ink, tracking: -0.9pt, data.name)
  v(0.5em)
  inter(size: 9.8pt, fill: muted, tracking: 0.2pt, data.tagline)
  v(0.7em)
  line(length: 100%, stroke: 1.2pt + ink)
})
#v(0.3in)

// A table gives equal-height cells, so the cream rail paints the full column.
#table(
  columns: (1.85in, 1fr),
  column-gutter: 0.3in,
  stroke: none,
  inset: 0pt,
  align: top,
  fill: (col, _) => if col == 0 { soft } else { none },
  pad(x: 0.75em, y: 0.9em, left-rail),
  main-col,
)
