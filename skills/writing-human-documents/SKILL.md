---
name: writing-human-documents
description: Guidance for writing clear, engaging documents for human readers. Use when creating, updating, or reviewing plans, reports, design documents, guides, specifications, runbooks, or other prose intended to be read and acted on by people.
---

# Writing Human Documents

## Purpose

Human attention is limited. A document that presents a wall of text asks the
reader to do too much work before they understand its purpose, structure,
or conclusions. The reader will eventually skim, lose the thread, or zone out.

This skill helps authors make documents easy to enter, scan, understand,
remember, and act on. The goal is not to make every document entertaining. The
goal is to respect the reader's attention by making the information clear and
varied.

The author MUST treat the document as an interface for a human reader. Structure
is part of the content, not decoration added after the writing is complete.

## Instruction language

This skill uses three terms with instruction force:

- **MUST** imposes a mandatory instruction on the author.
- **MUST NOT** means the author is prohibited from taking the action.
- **MAY** permits the author to take the action, but does not impose the action.

These terms are not interchangeable. `MAY` expresses permission, not a weaker
recommendation. A sentence without one of these terms is explanatory unless its
surrounding instruction clearly gives it another purpose.

The author MUST treat every `MUST` and `MUST NOT` instruction as binding. The
author MUST NOT infer a hidden requirement from a preference, example, rationale,
or failure-mode description.
The author MUST express every instruction with `MUST`, `MUST NOT`, or `MAY`. The
author MUST NOT use `SHOULD`, `SHOULD NOT`, `prefer`, `avoid`, or another
undefined modal form to create a weaker requirement.

## Non-negotiable rules

For every human-facing document:

1. The author MUST identify its intended reader and the outcome that reader needs.
2. The author MUST explain its purpose and most important conclusion near the
   beginning.
3. The author MUST use clear sections with headings that describe the information
   in them.
4. The author MUST break complex information into short paragraphs, lists, tables,
   examples, or diagrams rather than presenting an unbroken block of prose.
5. The author MUST use a format that matches the information being conveyed.
6. The author MUST use plain ASCII diagrams whenever a diagram improves
   understanding.
7. The author MUST include a short prose explanation for every diagram.
8. The author MUST define necessary specialist terms before relying on them.
9. The author MUST make decisions, actions, risks, and unresolved questions easy
   to find.

For every human-facing document, the author MUST NOT:

- The author MUST NOT present a long wall of text when a clearer structure exists.
- The author MUST NOT hide the conclusion, recommendation, or requested action at
  the end of a long introduction.
- The author MUST NOT use vague headings such as "Overview", "Details", or
  "Miscellaneous" when a more informative heading is possible.
- The author MUST NOT add visual elements merely as decoration.
- The author MUST NOT use Mermaid, Graphviz, PlantUML, or any other diagram
  syntax that requires a specialist renderer or reader.

## Reader-first process

Before drafting substantial prose, the author MUST follow this process:

1. **Name the reader.** The author MUST identify who will read the document and
   what they already know. If there are several audiences, the author MUST
   identify the primary audience and MAY identify secondary audiences.
2. **Name the job.** The author MUST state what the reader will understand,
   decide, or do after reading. If there is no useful reader outcome, the author
   MAY reject the document format or ask for a clearer purpose.
3. **Write the answer first.** The author MUST capture the central conclusion,
   recommendation, or result in one or two sentences before writing the
   supporting context.
4. **Build the outline.** The author MUST turn the major reader questions into
   sections and MUST give each section one clear job.
5. **Choose the format.** The author MUST decide whether each idea is best
   expressed as prose, a list, a table, a timeline, a checklist, an example, or
   an ASCII diagram.
6. **Draft for scanning.** The author MUST use meaningful headings, short
   paragraphs, and visible signposts. The author MUST NOT bury useful
   information in background detail.
7. **Edit for attention.** The author MUST remove repetition, split overloaded
   sections, move important information forward, and replace prose with a
   clearer format when that improves comprehension.
8. **Run the scan test.** The author MUST read only the title, headings, bold
   text, lists, tables, and diagrams. These elements MUST reveal the document's
   purpose, shape, major conclusion, and next action.

## Document structure

The author MUST use the following shape as a default and MAY adapt it to the
document's purpose:

1. **Title:** The author MUST state the subject and MAY state the outcome or
   decision.
2. **At a glance:** The author MUST give the reader the essential conclusion in
   three to five bullets or a short paragraph.
3. **Context:** The author MUST explain only the background needed to understand
   the main content. The author MUST link to deeper background instead of
   reproducing it when that detail is not needed by most readers.
4. **Main sections:** The author MUST present the argument, instructions, design,
   findings, or other substantive content in a logical sequence.
5. **Implications:** When implications exist, the author MUST state what changes,
   who is affected, and what trade-offs or risks follow.
6. **Next steps:** The author MUST identify actions, owners, decisions, or open
   questions when the document leads to further work.

The author MUST NOT force irrelevant sections into a document. The author MUST
preserve the underlying principles: orient the reader, provide a clear path
through the information, and make the intended outcome visible.

### Headings

- The author MUST use headings to divide changes in subject, question, or reader
  task.
- The author MUST make headings meaningful when read as a list on their own.
- The author MUST keep heading levels logical and MUST NOT jump from a top-level
  heading to a deeply nested heading merely for visual styling.
- The author MUST split a section when it answers more than one substantial
  question.
- The author MAY add a table of contents to a long document when it improves
  navigation.

### Paragraphs and lists

- The author MUST keep paragraphs focused on one idea, reason, or step.
- The author MUST keep paragraphs short and MUST split a paragraph that grows
  beyond three or four sentences unless keeping it intact clearly improves
  comprehension.
- The author MUST use a list when presenting three or more parallel items,
  alternatives, requirements, or steps.
- The author MUST keep list items parallel in grammar and concise enough to scan.
- The author MUST use numbered lists for ordered work and unordered lists for
  collections.
- The author MUST NOT turn every sentence into a bullet. The author MAY use prose
  for relationships, explanation, and transitions.
- The author MUST limit bold text to terms or conclusions rather than whole
  paragraphs.

### Progressive disclosure

The author MUST put information in layers:

1. The opening MUST give the answer and why it matters.
2. The main body MUST give the reasoning, evidence, instructions, or detail
   needed by most readers.
3. The author MAY place supporting appendices, linked references, and technical
   detail after the main body so readers who need to go deeper are supported
   without blocking everyone else.

The author MUST NOT make every reader pay the cost of detail that only a few
readers need. The author MUST NOT omit important caveats merely to make the
opening short; the author MUST surface them as clear warnings, constraints, or
implications.

## Choosing the right format

The author MUST use variety deliberately. Different shapes help readers
recognise different types of information quickly.

| Information | The author MUST use | The author MUST NOT use |
|---|---|---|
| A sequence or procedure | Numbered steps | A paragraph containing hidden steps |
| A comparison | A table with named criteria | Repeating the same sentence shape for each option |
| A date-based sequence | A timeline | A dense chronological paragraph |
| A decision | Recommendation, options, and trade-offs | Making the reader infer the decision |
| A relationship or flow | An ASCII diagram plus prose | Explaining every connection only in prose |
| A set of checks | A checklist | A vague statement that something is complete |
| A concrete idea | An example or worked example | Several paragraphs of abstraction first |
| A warning or constraint | A labelled callout | Hiding it in an ordinary sentence |
| A repeated question | A short FAQ | Repeating the answer throughout the document |

The author MUST use a table only when the rows share comparable criteria. The
author MUST use a list when column-by-column comparison is unnecessary.
The author MUST use prose to explain meaning, causation, nuance, and exceptions
that a table would make difficult to read.

## ASCII diagrams

ASCII diagrams are the only permitted diagram format in this skill. They work in
plain text, survive copying and version control, and work without a diagram
renderer or specialist syntax.

The author MUST use a diagram when spatial arrangement, sequence, dependency,
ownership, or state transition is easier to understand visually than in prose.
The author MAY use flows, lifecycles, boundaries, decision paths, and simple
maps.

The author MUST write diagrams with ordinary ASCII characters such as `+`, `-`,
`|`, `>`, `<`, `^`, and `v`. The author MUST keep diagrams compact, align
related elements, and use labels that a non-specialist understands.

Example flow:

```text
+----------------+       +----------------+       +----------------+
| Identify need  | ----> | Choose format  | ----> | Review scan    |
+----------------+       +----------------+       +----------------+
                                  |
                                  v
                         +----------------+
                         | Draft content  |
                         +----------------+
```

The diagram shows a simple writing loop: identify the reader's need, choose a
format, draft the content, and review whether the result remains scannable. The
prose explanation is mandatory because the diagram MUST NOT be the only way to
understand the process.

Diagram rules:

- A diagram MUST communicate one idea. The author MUST split a large diagram
  into smaller diagrams.
- Every node MUST have a short, meaningful label.
- The author MUST make direction and relationships explicit with consistent
  arrows.
- The author MUST include a legend when symbols or colours risk ambiguity. The
  author MUST NOT depend on colour alone.
- The author MUST put the diagram in a fenced `text` block so whitespace is
  preserved.
- The author MUST follow the diagram with a plain-language explanation or text
  equivalent.
- The author MUST NOT use Mermaid or embed Mermaid-style declarations in a code
  block.
- The author MUST NOT make a diagram wider than is practical to read on a normal
  screen.
- The author MUST remove the diagram if the same information is clearer as a
  list or table.

## Clear and engaging prose

- The author MUST use plain English and concrete nouns.
- The author MUST use active voice when it makes responsibility clearer.
- The author MUST explain acronyms and specialist terms at first use.
- The author MUST use examples to anchor abstract rules or concepts.
- The author MAY vary sentence length and document format without sacrificing
  clarity.
- The author MUST use transitions to show why the next section follows from the
  previous one.
- The author MUST state uncertainty honestly and distinguish facts, assumptions,
  recommendations, decisions, and open questions.
- The author MUST use British English spelling and grammar.

Interesting does not mean noisy. The author MUST NOT add jokes, rhetorical
flourishes, decorative headings, or excessive emphasis when they compete with
the content. The author MUST use useful variety by choosing the clearest form
for each idea.

## Review checklist

Before finalising a human-facing document, the author MUST verify:

- [ ] The document MUST make the intended reader and reader outcome clear.
- [ ] The title MUST tell the reader what the document is about.
- [ ] The opening MUST give the essential conclusion, recommendation, or result.
- [ ] The headings MUST form a useful outline when read without the body text.
- [ ] Each section MUST have one clear purpose.
- [ ] The document MUST NOT contain an unbroken wall of text.
- [ ] Paragraphs MUST be short enough to scan and lists MUST be used for parallel
      items.
- [ ] Tables, examples, checklists, timelines, and diagrams MUST be used when
      they make information easier to understand.
- [ ] Every diagram MUST be plain ASCII, compact, labelled, and explained in
      prose.
- [ ] The document MUST NOT contain Mermaid, Graphviz, PlantUML, or other
      specialist diagram syntax.
- [ ] Important decisions, actions, risks, constraints, and open questions MUST
      be easy to locate.
- [ ] Jargon and acronyms MUST be explained for the intended reader.
- [ ] Detail MUST be layered so readers MAY stop when they have what they need.
- [ ] The scan test MUST reveal the document's purpose, conclusion, and next
      action.
- [ ] The document MUST use British English spelling and grammar.

## Common failure modes

- **The essay wall:** Many paragraphs appear with no headings or visual breaks.
  The author MUST split the content by reader question and MAY change format
  where that improves comprehension.
- **The buried answer:** The recommendation or result appears after extensive
  context. The author MUST put it in the opening and use the body to support it.
- **The heading catalogue:** Headings exist, but they are vague or decorative.
  The author MUST rewrite them to state the question, finding, or action in the
  section.
- **The format monoculture:** Everything is prose, or everything is bullets.
  The author MUST match the format to the information and use transitions
  between formats.
- **The decorative diagram:** A visual looks interesting but adds no information.
  The author MUST replace it with a useful diagram, a simpler format, or nothing.
- **The specialist trap:** The document assumes readers understand unexplained
  jargon or diagram syntax. The author MUST define terms and use plain ASCII
  diagrams.
- **The detail dump:** Every caveat and implementation detail appears in the
  opening. The author MUST surface important constraints, then move supporting
  detail deeper.
- **The no-exit document:** The reader reaches the end without knowing what to
  decide or do. The author MUST add explicit next steps, owners, or open
  questions when needed.
