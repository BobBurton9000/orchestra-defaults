---
name: engineering-constitution
description: Creates and revises engineering constitutions with Articles, Sections, numbered clauses, authority, ownership, invariants, compliance, and exceptions. Use when defining the durable architectural rules that govern how a system is designed and changed.
---

# Engineering Constitution Authoring

Use this skill when writing a durable engineering constitution: an internal,
authoritative specification that governs how a system is designed and changed.
Treat the constitution as normative engineering law within its declared scope.
It is not statutory law, legal advice, or a description of how the current code
happens to work.

Apply `normative-technical-writing` when expressing the constitution's binding
requirements. This skill defines what a constitution contains and how its
authority is structured; the writing skill defines the language used to express
obligations.

## Constitutional Authoring

- State architectural intent as enforceable boundaries and obligations.
- Do not turn framework conventions, implementation convenience, existing code, or a passing test into an exception unless the constitution explicitly permits it.
- Do not invent domain rules when ownership, authority, or system boundaries are unclear. Ask for the missing context.
- Preserve existing numbering and cross-references when revising a constitution unless the change deliberately restructures the document.

## Normative Language

Every constitution MUST define its normative terms near the beginning. Unless
the constitution explicitly establishes another vocabulary, `MUST` means a
mandatory requirement, `MUST NOT` means a prohibition, and `MAY` means a
permission that is not required. The definitions in the constitution are
authoritative within its declared scope.

## Required Document Shape

Use this structure as the default:

```markdown
# [System] Engineering Constitution

## Preamble

[Authority, scope, purpose, and precedence over conflicting guidance.]

## Article 1: Normative Language

### Section 1.1: Modal Terms

[Definitions of MUST, MUST NOT, and MAY.]

## Article 2: Definitions

### Section 2.1: Core Terms

[Terms that have a specific meaning in this constitution.]

## Article 3: [First Architectural Domain]

### Section 3.1: [Boundary or Ownership Rule]

1. [Normative clause.]
2. [Normative clause.]

### Section 3.2: [Related Rule]

1. [Normative clause.]

## Article 4: [Next Architectural Domain]

### Section 4.1: [Rule Group]

1. [Normative clause.]

## Article 5: Compliance

### Section 5.1: Compliance

1. [How compliance is determined.]
```

Use `##` headings for Articles and `###` headings for Sections. Use Arabic
numerals for Article identifiers, and number Sections with the Article identifier
followed by a decimal point and the Section number. Use Arabic numerals for
numbered clauses. Give every Article and Section a descriptive title.

Articles represent major, durable domains of authority. Typical Articles cover
normative language, definitions, ownership, boundaries, communication, data
flow, independence, and compliance. Adapt the domains to the
system; do not copy product-specific concepts into an unrelated constitution.

Sections group clauses that govern one coherent responsibility or boundary.
Use Sections when an Article contains more than one such group, but do not add
empty or decorative Sections merely to satisfy the template.

## Preamble

The Preamble MUST establish:

- The document's authority and the system or code to which it applies.
- The architectural or engineering concerns it governs.
- The fact that production code, tests, and technical decisions within scope are subject to it.
- Precedence when this constitution conflicts with implementation practice, framework guidance, or another document.

Keep the scope explicit. A constitution that governs only a subsystem MUST NOT
silently claim authority over unrelated systems. If the document is subordinate
to an external legal, regulatory, or organisational requirement, say so rather
than claiming absolute precedence.

## Definitions

Define terms that affect ownership, authority, boundaries, or compliance. A
definition MUST be specific enough that two engineers can apply it to the same
implementation and reach the same result.

Define concepts before using them in normative clauses. Distinguish closely
related concepts such as:

- Authoritative state versus derived or cached state.
- An owner versus a reader or consumer.
- A command or request versus an applied state change.
- An event or notification versus the authority that caused it.
- A presentation, adapter, or integration layer versus the domain that owns the rule.

Do not hide a requirement in a definition. If a term imposes a boundary, state
that boundary as a numbered normative clause in the appropriate Article.

## Articles and Sections

Design the document in this order:

1. Establish the modal language and definitions.
2. Identify the authoritative owner of each important fact or decision.
3. State the permitted boundaries and direction of communication.
4. State independence, substitution, or deployment constraints where they matter.
5. State compliance rules.

For each architectural domain, identify the actor or component first, then its
authority, then the permitted or prohibited interaction. The resulting
constitutional clauses MUST make that actor, authority, and interaction
observable.

Use one primary concern per Section. If a Section becomes a list of unrelated
rules, split it. Keep related clauses together so a reviewer can evaluate a
boundary without searching the whole document.

## Normative Clauses

Write requirements as numbered clauses inside an Article Section. Each clause
MUST express one constitutional obligation and any condition or exception that
changes its application. Apply `normative-technical-writing` to the wording.

If a rule describes a required sequence or direction, show the flow explicitly.
Use a compact diagram or code block when it removes ambiguity, then state the
rule in normative prose as well.

## Explanatory Material

Explanatory material MUST remain distinct from the constitution's numbered
normative clauses. Put terminology in Definitions, authority and precedence in
the Preamble, and design motivation in a clearly labelled `Rationale` section or
separate document. Examples MUST be labelled and MUST NOT silently override or
narrow a governing clause.

## Compliance

Every constitution MUST explain how it is interpreted.

The compliance Article MUST establish that:

- A violation of a `MUST` or `MUST NOT` clause is non-compliant even when the implementation works in current scenarios.
- Tests and tooling provide evidence of compliance but do not grant permission to violate the document.
- Implementation details MAY vary only when they preserve every applicable invariant and boundary.
- Conflicts are resolved according to the precedence established in the Preamble.
- The absence of a test, lint rule, runtime check, or other enforcement mechanism does not make a normative violation permissible. Enforcement mechanisms support the constitution; they do not define its authority.

## Revision Workflow

When creating a new constitution:

1. Ask for the system boundary, intended authority, and key architectural invariants if they are not known.
2. Draft the Preamble and normative vocabulary before writing domain rules.
3. Extract and define the actors, facts, decisions, and communication paths that the constitution governs.
4. Group the rules into Articles and Sections, with ownership and boundary rules before implementation preferences.
5. Write numbered clauses using only the defined normative vocabulary.
6. Add compliance handling before considering the document complete.
7. Add a small number of concrete examples only after the governing rules are unambiguous.
8. Review every clause for a clear subject, modal strength, scope, and observable compliance condition.

When revising an existing constitution:

1. Read the complete document before changing an Article, Section, definition, or cross-reference.
2. Identify whether the proposed change clarifies, strengthens, weakens, or removes an obligation.
3. Preserve the existing authority model unless the user explicitly requests a change to it.
4. Update dependent definitions, examples, links, and clauses when changing a term or boundary.
5. Check that no lower-precedence document or implementation overrides the constitution.

## Review Checklist

Before finalising a constitution, verify:

- The title, Preamble, Articles, and Sections make the authority and scope clear.
- `MUST`, `MUST NOT`, and `MAY` are defined and used consistently.
- Normative clauses follow `normative-technical-writing`.
- Important terms are defined before normative use.
- Each authoritative fact, decision, or rule has one clear owner.
- Boundaries and communication directions are explicit.
- Duplicate sources of truth and bypass paths are prohibited where necessary.
- Normative clauses are numbered and grouped by coherent Article Sections.
- Examples and rationale cannot be mistaken for exceptions.
- Compliance does not depend solely on tests or current runtime behaviour.
- Cross-references resolve and do not contradict the constitution.
- The document does not claim legal authority it does not possess.

If a requirement cannot be evaluated from the document and the relevant
implementation or design, rewrite it until its subject, scope, and consequence
are clear.
