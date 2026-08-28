---
name: writing-llm-documents
description: Guidance for writing precise, unambiguous documents that readers and systems can reliably interpret and follow. Use when creating or reviewing prompts, agent instructions, skills, specifications, context packs, structured requirements, or other documents whose primary consumer is expected to apply precise instructions.
---

# Writing Documents for Reliable Interpretation

## Purpose

A document consumer can only act on the instructions, definitions, context, and
contracts available in the provided input. Ambiguous wording, hidden assumptions,
conflicting rules, and examples that look like requirements make the intended
behaviour difficult to recover reliably.

This skill helps authors write documents that a consumer can parse, prioritise,
apply, and validate. Treat the document as an executable contract for
interpretation: every important behaviour MUST be explicit, bounded, and
distinguished from explanation.

A consumer is the person or system expected to interpret and apply the document.

## Scope

The author MUST apply this skill when the primary consumer of the document is
expected to apply precise, unambiguous instructions, including:

- Prompts and prompt templates.
- Agent definitions and delegation instructions.
- Skills and reusable guidance files.
- Specifications, structured requirements, and decision policies.
- Context packs, runbooks, and reference documents supplied to a consumer.
- Output instructions, schemas, and evaluation criteria.

When a document contains binding technical requirements, the author MUST apply
`normative-technical-writing` to their wording. The author MAY use this skill
together with `writing-human-documents` when a document will be read by multiple
consumers. The author MUST preserve the consumer-facing contract even when
adding explanatory material.

This skill does not define the product, domain, or engineering rules being
documented. It defines how those rules MUST be expressed for reliable
interpretation by the consumer.

## Instruction language

The instructions in this skill use three terms with instruction force:

- **MUST** imposes a mandatory instruction on the author or document consumer.
- **MUST NOT** prohibits the author or document consumer from taking the action.
- **MAY** permits the author or document consumer to take the action, but does
  not impose the action.

The author MUST treat every `MUST` and `MUST NOT` instruction as binding. The
author MUST NOT infer a hidden requirement from a heading, example, rationale,
comment, footnote, diagram, or conversational implication.

The authored document MUST use `normative-technical-writing` for its own
normative vocabulary and obligation wording.

## Document contract

For every consumer-facing document, the author MUST define or explicitly mark as not
applicable:

1. **Purpose:** What the document enables the consumer to understand or do.
2. **Scope:** Which task, behaviour, domain, or decision the document covers.
3. **Authority:** Which rules in the document are normative and which sources
   have higher or lower precedence.
4. **Consumer role:** What the consumer is responsible for in this context.
5. **Inputs:** What information the consumer receives, including required fields,
   allowed values, and assumptions.
6. **Outputs:** What the consumer MUST produce, including format, required content,
   and boundaries.
7. **Failure behaviour:** What happens when input is missing, invalid, ambiguous,
   contradictory, or outside the declared scope.
8. **Terminology:** What important terms mean in this document.

The author MUST NOT leave a contract item implicit when its absence could change
the consumer's behaviour. The author MAY omit genuinely irrelevant detail, but the
author MUST state when a contract item is not applicable if a reader could
reasonably expect it to exist.

## Authority and scope

The author MUST establish the document's authority near the beginning. The
document MUST state whether it is:

- A binding instruction.
- A reference document whose contents are informative.
- A contract that another instruction consumes.
- A quoted or summarised external source.

The author MUST distinguish the document's own rules from rules imported from
another source. The author MUST identify every external dependency that is
necessary to interpret a requirement.

The author MUST state precedence when multiple sources, sections, or rules can
apply to the same situation. The author MUST NOT rely on position, recency, or
the consumer's presumed common sense as an unstated conflict-resolution mechanism.

The author MUST define the boundary of the document. The document MUST state
what it does not govern when a nearby responsibility could be confused with its
scope.

## Document shape

The author MUST use a stable, recognisable structure and MAY adapt it when the
document's purpose makes a section irrelevant:

1. **Purpose and scope:** State the task and the boundary.
2. **Instruction summary:** State the highest-priority behaviour in a compact
   list.
3. **Definitions:** Define terms before normative use.
4. **Authority and precedence:** State which rules govern conflicts.
5. **Inputs:** Define the input contract and preconditions.
6. **Normative rules:** State the required and prohibited behaviour.
7. **Process or decision flow:** State ordered steps, branches, loops, and
   termination conditions when they apply.
8. **Outputs:** Define the output contract and validation conditions.
9. **Edge cases and failures:** Define boundary and exceptional behaviour.
10. **Examples and non-examples:** Show correct application without creating
    unlabelled requirements.
11. **Validation checklist:** State how an author or reviewer confirms compliance.

The author MUST keep headings stable and descriptive. The author MUST NOT use a
heading only for visual decoration. The author MAY omit a section that is not
applicable, but the author MUST either record that fact or make the omission
unambiguous from the document's stated scope.

## Atomic Requirements

The author MUST write each independently testable obligation as a separate
normative clause. For modal force, explicit actors, conditions, and exceptions,
the author MUST apply `normative-technical-writing`.

The author MUST NOT hide two unrelated obligations inside one sentence merely
because they share a subject. The author MUST split compound rules when each
part could be violated independently.

The author MUST state conditions explicitly. Words such as "appropriate",
"reasonable", "relevant", "sufficient", and "as needed" MUST be replaced with
observable criteria or defined terms when they affect behaviour.

The author MUST state the consequence of non-compliance when the consumer needs to
choose between continuing, asking a question, reporting an error, or refusing
the task.

## Definitions and terminology

The author MUST define a term before using it normatively. Definitions MUST be
specific enough that two readers apply the term to the same case.

The author MUST use one canonical term for one concept within a document. The
author MUST NOT alternate between synonyms when the distinction could matter.
The author MUST preserve the same capitalisation, spelling, and singular or
plural form for a canonical term.

The author MUST replace vague references such as "this", "it", "the above", or
"the usual process" with the named actor, rule, section, or object. The author
MUST use explicit cross-references such as a heading name or stable identifier
when a rule depends on another part of the document.

The author MAY assign stable identifiers to definitions, requirements, inputs,
outputs, and examples. If identifiers are used, they MUST be unique, stable,
descriptive enough for reference, and used consistently.

## Normative and explanatory content

The author MUST separate binding rules from material that explains or illustrates
those rules. The author MUST use explicit labels such as:

- `Normative rules`
- `Definitions`
- `Rationale`
- `Example`
- `Non-example`
- `Assumption`
- `Open question`
- `Out of scope`

The author MUST label every example and non-example. Examples MUST demonstrate
the governing rules and MUST NOT silently add a narrower requirement.

The author MUST NOT place a required instruction only in a comment, footnote,
diagram, image, alt text, example, or rationale section. Required behaviour MUST
appear in explicit normative prose.

If an example contains `MUST`, `MUST NOT`, or `MAY`, the author MUST make clear
whether the terms are part of the document's rules or quoted content. The author
MUST NOT allow an illustrative example to override a normative clause.

The author MAY include rationale after a rule when it improves understanding.
Rationale MUST explain the reason for a rule and MUST NOT introduce a conflicting
exception or alternative behaviour.

## Input contracts

When a document defines inputs, the author MUST state:

- The input's name and purpose.
- The type, shape, or permitted representation.
- Required and optional fields.
- Allowed values, ranges, or patterns.
- Defaults, if a default exists.
- Preconditions and dependencies.
- The behaviour for missing, malformed, invalid, or conflicting values.

The author MUST distinguish absent input from an empty, zero, false, unknown, or
invalid value when those cases produce different behaviour.

The author MUST NOT instruct the consumer to "fill in" unspecified values from an
unstated assumption. The author MUST define a default, require clarification,
permit an explicit assumption, or require a failure response.

If input fields have dependencies, the author MUST state the dependency and its
failure behaviour. For example, an optional field MAY become required when a
specific mode is selected, but that condition MUST be written explicitly.

## Output contracts

When a document requires an output, the author MUST define:

- The output format and syntax.
- Required sections, fields, or properties.
- Allowed and prohibited content.
- Ordering requirements when order affects interpretation.
- Length or quantity limits when they matter.
- The behaviour when the consumer cannot satisfy the contract.
- The validation conditions for a complete output.

The author MUST provide a schema, template, or concrete structural example when
the output shape is important. The author MAY use JSON, YAML, tables, Markdown,
or another format, but the author MUST identify the selected format and MUST NOT
mix incompatible formats without explaining the boundary.

The author MUST distinguish content requirements from presentation preferences.
If a field is required, the output contract MUST identify it as required through
explicit normative language rather than visual emphasis alone.

The author MUST define how the consumer represents uncertainty, unavailable data,
and assumptions in its output. The author MUST NOT require the consumer to invent
facts to complete an output.

## Processes and decision flows

When a task has an order, the author MUST use numbered steps or an ASCII diagram
with explicit direction. Each step MUST state its input, action, and resulting
state when that information affects the next step.

When a task has branches, the author MUST state:

- The condition that selects each branch.
- The action for each branch.
- The result of each branch.
- The next step or termination condition.

The author MUST define retry limits, loop termination, escalation, and fallbacks
when any of them are possible. The author MUST NOT use an unbounded instruction
such as "keep trying" without a stopping condition.

The author MUST use plain ASCII diagrams for relationships, flows, boundaries, or
state changes. Mermaid, Graphviz, PlantUML, and other specialist diagram syntaxes
MUST NOT be used.

Example flow:

```text
+----------------+       +------------------+
| Validate input | ----> | Apply rules      |
+----------------+       +------------------+
         |                         |
         | invalid                 | valid
         v                         v
+----------------+       +------------------+
| Report failure |       | Produce output   |
+----------------+       +------------------+
```

The author MUST follow every diagram with a plain-language explanation. The
diagram MUST NOT be the only source of a required rule.

## Context and token efficiency

The author MUST place high-priority scope, authority, and behavioural constraints
before supporting detail. The author MUST NOT bury a required instruction in a
long preamble or at the end of unrelated context.

The author MUST remove duplicated rules and keep one canonical statement for
each requirement. If a rule must be repeated for navigation, the repeated text
MUST identify the canonical source and MUST NOT introduce a variation.

The author MUST keep the document self-contained enough for its declared scope.
If interpretation depends on another document, the author MUST identify that
document and the required section or contract. The author MUST NOT assume that a
conversation, tool result, file, or prior instruction is available unless the
document declares that dependency.

The author MAY use progressive disclosure: a compact instruction summary first,
followed by definitions, rules, examples, and supporting detail. The author MUST
NOT move required information into an optional appendix or external reference
without stating that dependency in the contract.

The author MUST use explicit placeholders for values the consumer must provide.
The author MUST NOT use vague placeholders such as "insert details" or "fill in
as appropriate" when the required value or selection can be named.

## Ambiguity and conflicts

The author MUST resolve contradictions before finalising the document. Two
clauses MUST NOT require incompatible outcomes for the same condition unless the
document states which clause has precedence.

When ambiguity cannot be removed, the author MUST define the response. The
response MAY require the consumer to ask a clarifying question, state an assumption,
choose a bounded default, report an error, or refuse the task.

The author MUST distinguish an unknown fact from a false fact. The author MUST
define whether the consumer MAY proceed with an explicit assumption or MUST stop for
clarification.

The author MUST state how conflicts between this document and external sources
are resolved. The author MUST NOT rely on the consumer to infer authority from the
apparent confidence, length, or position of a source.

## Examples and non-examples

The author MAY include examples when they reduce ambiguity or demonstrate the
expected output shape. Examples MUST be short, representative, and consistent
with the normative rules.

Every example MUST have a label that states its purpose, such as `Valid example`,
`Invalid example`, `Input example`, or `Output example`. The author MUST NOT
present an illustrative value as the only definition of a permitted value.

Every non-example MUST state why it is invalid. The explanation MUST identify
the violated rule rather than merely calling the example bad or incorrect.

The author MUST update examples when a normative rule changes. Examples MUST NOT
be used to preserve an obsolete interpretation for compatibility unless that
compatibility requirement is itself normative.

## Markdown and machine-readable structure

The author MUST use Markdown headings to express document hierarchy. Heading
levels MUST progress logically, and headings MUST describe their content.

The author MUST use lists for parallel requirements and numbered lists for
ordered procedures. The author MUST use tables only when the rows share
comparable criteria.

The author MUST put schemas, templates, literal output, and diagrams in fenced
code blocks. The author MUST label a code fence with its language when a parser
or reader needs that information.

The author MUST NOT hide normative text in styling, colour, indentation, or
layout. The document MUST remain interpretable as plain text.

The author MUST use ASCII diagrams only. ASCII diagrams MUST have clear labels,
explicit direction, and a prose explanation. The author MUST NOT use Mermaid,
Graphviz, PlantUML, or another specialist diagram language.

## Review checklist

Before finalising a consumer-facing document, the author MUST verify:

- [ ] The author MUST make the purpose, scope, authority, and consumer role
      explicit.
- [ ] The author MUST define every applicable input, output, failure, and
      terminology contract or explicitly mark it as not applicable.
- [ ] The author MUST define and use `MUST`, `MUST NOT`, and `MAY` consistently.
- [ ] The author MUST NOT use `SHOULD`, `SHOULD NOT`, `prefer`, `avoid`, or an
      undefined modal form to create an ambiguous weaker instruction.
- [ ] Every normative clause MUST have an explicit actor, action, condition, and
      result where a result matters.
- [ ] The author MUST split compound obligations into independently testable
      clauses.
- [ ] Definitions MUST appear before normative use and canonical terms MUST
      remain stable.
- [ ] Cross-references MUST identify a specific heading, identifier, or contract.
- [ ] Normative rules, rationale, examples, non-examples, and open questions MUST
      be clearly separated and labelled.
- [ ] Examples MUST NOT silently add constraints or contradict the rules.
- [ ] Missing, invalid, ambiguous, and conflicting inputs MUST have explicit
      behaviour.
- [ ] Output format, required fields, limits, uncertainty, and failure behaviour
      MUST be explicit.
- [ ] Branches, retries, loops, fallbacks, and termination conditions MUST be
      bounded.
- [ ] Required instructions MUST NOT be hidden in comments, footnotes, examples,
      diagrams, or external references.
- [ ] Duplicate rules MUST have one canonical source and MUST NOT drift apart.
- [ ] External dependencies and precedence rules MUST be explicit.
- [ ] Diagrams MUST be ASCII-only, labelled, compact, and explained in prose.
- [ ] The document MUST NOT contain Mermaid, Graphviz, PlantUML, or other
      specialist diagram syntax.
- [ ] The document MUST use British English spelling and grammar.

## Common failure modes

- **The implied contract:** The document assumes the consumer knows an input, output,
  role, or domain rule. The author MUST state the dependency or remove it.
- **The rule soup:** Several obligations appear in one long sentence. The author
  MUST split them into atomic normative clauses.
- **The modal blur:** Guidance uses words such as "usually" or "prefer" without
  defining their force. The author MUST replace them with `MUST`, `MUST NOT`, or
  `MAY`.
- **The example trap:** An example contains an extra restriction that is absent
  from the rules. The author MUST label examples and MUST ensure they add no
  silent constraints.
- **The vague fallback:** The document says to handle an error appropriately.
  The author MUST define the exact response, stopping condition, or escalation.
- **The context dependency:** The document relies on a conversation or external
  source that is not declared. The author MUST state the dependency and required
  contract.
- **The conflict pair:** Two sections prescribe incompatible outcomes. The author
  MUST resolve the conflict or state precedence.
- **The output vacuum:** The document describes a task but not the required
  result. The author MUST define the output contract and validation conditions.
- **The repetition tax:** The same rule appears in several slightly different
  forms. The author MUST retain one canonical rule and link to it elsewhere.
- **The specialist diagram:** A diagram requires a renderer or notation the
  consumer may not support. The author MUST replace it with a plain ASCII diagram
  and prose explanation.
