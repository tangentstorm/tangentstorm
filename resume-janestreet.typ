#let data = yaml("resume-janestreet.yaml")

#let ink = rgb("#121212")
#let muted = rgb("#5c5c5c")
#let soft = rgb("#f4f1ec")
#let accent = rgb("#8a4b2e")
#let accent-deep = rgb("#6b3a24")

#set page(
  paper: "us-letter",
  margin: (top: 0.4in, bottom: 0.36in, left: 0.4in, right: 0.4in),
)
#set text(font: "Libertinus Serif", size: 9pt, fill: ink)
#set par(leading: 0.36em)
#show link: it => text(fill: accent-deep, it)

#let inter(..args) = text(font: ("Inter", "Liberation Sans"), ..args)
#let serif(..args) = text(font: "Libertinus Serif", ..args)

// Label then copper rule UNDER
#let rail-label(title) = {
  // box() avoids paragraph line-box gap; small positive gap sits rule under baseline.
  block(below: 0.2em, {
    set block(spacing: 0pt)
    box(inter(weight: "bold", size: 6.7pt, fill: accent-deep, tracking: 1.5pt, upper(title)))
    v(0.18em)
    line(length: 100%, stroke: 1pt + accent)
  })
}

#let main-label(title) = {
  block(below: 0.2em, {
    set block(spacing: 0pt)
    box(inter(weight: "bold", size: 7.1pt, fill: accent-deep, tracking: 1.6pt, upper(title)))
    v(0.18em)
    line(length: 1.15in, stroke: 1.1pt + accent)
  })
}

#let date-col = 5.9em

#let job(j, first: false) = {
  // Tight internal rhythm makes title, metadata, and bullets read as one unit.
  // Extra space above subsequent entries separates jobs without adding rules.
  if not first { v(0.42em) }
  grid(
    columns: (1fr, date-col),
    rows: (auto, auto),
    column-gutter: 0.3em,
    row-gutter: 0.08em,
    inter(weight: "bold", size: 9pt, fill: ink, j.role),
    align(right + top, inter(size: 7.3pt, fill: muted, j.dates)),
    inter(
      size: 7.6pt,
      fill: muted,
      j.org + if "location" in j and j.location != none { " · " + j.location } else { "" },
    ),
    [],
  )
  v(-0.16em)
  set list(
    indent: 0em,
    body-indent: 0.38em,
    marker: box(width: 0.38em, align(center, text(fill: accent, size: 4.4pt)[●])),
    tight: true,
  )
  set text(font: "Libertinus Serif", size: 8.55pt, fill: ink)
  set par(leading: 0.32em)
  let links = if "links" in j { j.links } else { none }
  let i = 0
  for b in j.bullets {
    if i == 0 and links != none {
      let bits = links.map(l => link(l.url, l.label))
      list.item[
        #serif(size: 8.55pt)[#b]
        #serif(fill: muted, size: 8.1pt)[ (]
        #bits.join([, ])
        #serif(fill: muted, size: 8.1pt)[)]
      ]
    } else {
      list.item[#serif(size: 8.55pt)[#b]]
    }
    i += 1
  }
}

#let left-rail = {
  rail-label("Contact")
  inter(size: 7.25pt, fill: ink)[
    #link("mailto:" + data.email)[#data.email.replace("@", "\@")] \
    #data.phone
    #v(0.18em)
    #link(data.website_url)[#data.website] \
    #link("https://github.com/" + data.github)[github.com/#data.github]
  ]

  v(0.42em)
  rail-label("Skills")
  for s in data.skills {
    inter(weight: "bold", size: 7pt, fill: ink, s.label)
    v(0.05em)
    inter(size: 7.15pt, fill: muted, s.items)
    v(0.2em)
  }

  v(0.08em)
  rail-label("Code")
  inter(size: 7.3pt)[
    #data.opensource.map(p => link(p.url, p.label)).join([\ ])
  ]

  v(0.36em)
  rail-label("Elsewhere")
  inter(size: 7.05pt)[
    #data.elsewhere.map(e => link(e.url, e.label)).join([\ ])
  ]
}

#let main-col = {
  main-label("Summary")
  set par(leading: 0.4em)
  serif(size: 8.85pt, data.summary.trim())

  v(0.26em)
  main-label("Formal Methods")
  serif(size: 8.1pt, fill: muted, emph(data.formal_method_note.trim()))
  for fm in data.formal_methods {
    v(0.3em)
    inter(weight: "bold", size: 8.55pt, fill: ink, fm.name)
    h(0.45em)
    serif(size: 8.55pt, fm.text.trim())
    let bits = fm.links.map(l => link(l.url, l.label))
    h(0.35em)
    serif(fill: muted, size: 8.1pt)[(#bits.join([, ]))]
  }

  v(0.26em)
  main-label("Experience")
  for (i, j) in data.experience.enumerate() {
    job(j, first: i == 0)
  }

  v(0.26em)
  block(
    width: 100%,
    inset: (left: 0.4em, y: 0.14em, right: 0.06em),
    stroke: (left: 1.65pt + accent),
    {
      inter(weight: "bold", size: 6.7pt, fill: accent-deep, tracking: 1.1pt)[PREVIOUSLY]
      v(0.06em)
      serif(size: 7.35pt, fill: muted, data.previously.trim())
    },
  )
}

// Header
#inter(weight: "bold", size: 24pt, fill: ink, tracking: -0.9pt, data.name)
#v(0.12em)
#line(length: 100%, stroke: 1.3pt + ink)
#v(0.16em)
#grid(
  columns: (1fr, auto),
  inter(size: 7.8pt, fill: muted)[Software engineer · formal methods · Lean 4],
  inter(size: 7.4pt, fill: muted, data.location),
)
#v(0.32em)

// Table gives equal-height cells so cream rail paints full column
#table(
  columns: (1.52in, 1fr),
  column-gutter: 0.34in,
  stroke: none,
  inset: 0pt,
  align: top,
  fill: (col, _) => if col == 0 { soft } else { none },
  // left rail
  pad(x: 0.34em, y: 0.36em, left-rail),
  // main
  main-col,
)
