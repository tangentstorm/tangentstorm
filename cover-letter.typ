// GENERATED from cover-letter.md — do not edit by hand. Run: python3 build.py

#let ink = rgb("#121212")
#let muted = rgb("#5c5c5c")
#let accent = rgb("#8a4b2e")
#let accent-deep = rgb("#6b3a24")

#set page(paper: "us-letter", margin: (top: 0.75in, bottom: 0.7in, x: 1in))
#set text(font: "Libertinus Serif", size: 10.5pt, fill: ink)
#set par(spacing: 0.7em, leading: 0.55em, justify: true)
#show link: it => text(fill: accent-deep, it)

#let inter(..args) = text(font: ("Inter", "Liberation Sans"), ..args)

#align(center)[
  #inter(weight: "bold", size: 17pt, fill: ink, tracking: -0.5pt)[Michal J. Wallace] \
  #v(0.1em)
  #inter(size: 9pt, fill: muted)[Hicksville, NY (remote) · #link("mailto:michal.wallace@gmail.com")[michal.wallace\@gmail.com] · (678) 812-9126] \
  #inter(size: 9pt, fill: muted)[#link("https://tangentstorm.com")[tangentstorm.com] · #link("https://github.com/tangentstorm")[github.com/tangentstorm]]
]
#v(0.5em)
#line(length: 100%, stroke: 1pt + accent)
#v(0.5em)

Dear hiring manager,

I'm a generalist software engineer with 20+ years of experience, looking for an individual-contributor role in AI, developer relations, or formal methods.

Here's what I believe: AI will bring software creation to the average person, but the right interface isn't raw natural language. We should translate prompts into a concise, formal specification that states which features and constraints actually matter. AI should fill in the details and, when it's important, prove the solution implements the spec. Most of my recent work points in that direction.

A few of the things I've built:

- At 1010data, the #link("https://docs.1010data.com/DynamicAPI/")[Dynamic API], which lets client applications query the Insights Platform. It became the backbone of the company's ODBC driver, which hundreds of users relied on for every Tableau and Power BI dashboard, and it made it possible to run multiple queries in parallel; before, the system could only parallelize the parts of a single query. I also became the person people across the company asked about the system: I treated every question on Slack as a chance to learn more, and could often find answers that colleagues with years more tenure couldn't.
- After SymphonyAI acquired 1010data, R&D prototypes for new AI products, including an MCP server and a rate-limited, metered AI API gateway. I also helped my team get up to speed with AI tools.
- #link("https://implish.org")[implish], a high-level language that combines array programming (APL, J, K) with the flexible dialects of Racket and Red. Long term, it's meant to support verified programs. The site has a live interpreter.
- Two book-scale Lean 4 formalizations: Eric Hehner's #link("https://github.com/tangentproofs/laptop")[A Practical Theory of Programming] and #link("https://github.com/tangentproofs/conway-knots")[Conway's classification of rational tangles]. I did my earlier proofs by hand; these were mostly a matter of herding AI agents toward the goal.
- #link("https://github.com/tangentstorm/bex")[bex], a Rust toolkit for Boolean expressions and binary decision diagrams, the core data structures of symbolic model checking.
- #link("https://minavo.app")[Minavo], an audio/video creation tool with a live demo. I'm launching it through my company, Minneron LLC, and would happily keep it to a few hours a week alongside the right job.

Most of my day-to-day coding now happens through AI agents: I run multi-agent workflows (Claude Code, Codex, Grok, Muse) with automated review gates, and I've built harnesses to evaluate their output. I also livestream about AI on my #link("https://www.youtube.com/@tangentstream")[tangentstream] channel.

I'm based in Hicksville, NY, work remotely, and am a US citizen who doesn't require sponsorship. If this lines up with what your team is doing, I'd love to talk.

#v(0.8em)
Best regards, Michal J. Wallace

#v(0.7em)
#line(length: 100%, stroke: 0.5pt + accent)
#v(0.3em)

#text(size: 8pt, weight: "bold", fill: muted)[Links mentioned]

#text(size: 7pt, fill: muted)[
- Dynamic API — #link("https://docs.1010data.com/DynamicAPI/")[https://docs.1010data.com/DynamicAPI/]
- implish — #link("https://implish.org")[https://implish.org]
- A Practical Theory of Programming — #link("https://github.com/tangentproofs/laptop")[https://github.com/tangentproofs/laptop]
- Conway's classification of rational tangles — #link("https://github.com/tangentproofs/conway-knots")[https://github.com/tangentproofs/conway-knots]
- bex — #link("https://github.com/tangentstorm/bex")[https://github.com/tangentstorm/bex]
- Minavo — #link("https://minavo.app")[https://minavo.app]
- tangentstream — #link("https://www.youtube.com/@tangentstream")[https://www.youtube.com/\@tangentstream]
]