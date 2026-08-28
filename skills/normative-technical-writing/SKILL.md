---
name: normative-technical-writing
description: Writes technical requirements as explicit, unambiguous obligations using MUST, MUST NOT, and MAY. Use when a document must state rules, constraints, decisions, or permitted behaviour definitively, including specifications, policies, RFCs, ADRs, and constitutions.
---

# Normative Technical Writing

## Purpose and Scope

Use this skill when a technical document needs to state requirements,
prohibitions, permissions, or other binding rules with explicit force.

This skill governs how obligations are expressed. It does not define the domain
rules, the document's authority, or its structure. Compose it with
`engineering-constitution`, `writing-human-documents`, or
`writing-llm-documents` when those concerns apply.

Normative language MUST be definitive about obligations without pretending that
uncertain facts are certain. A document MUST distinguish a binding requirement
from a fact, assumption, recommendation, rationale, example, or open question.

## Normative Vocabulary

A document containing binding requirements MUST define its normative vocabulary
near the beginning. Unless the document explicitly establishes another
vocabulary:

- **MUST** means that the requirement is mandatory.
- **MUST NOT** means that the action is prohibited.
- **MAY** means that the action is permitted but not required.

The author MUST use uppercase modal terms when they carry normative force. The
author MUST NOT use lowercase `must`, `should`, `required`, `prefer`, `avoid`,
`normally`, or similar terms to create an undefined requirement. A document MAY
define additional modal terms, but it MUST define their force and relationship
to the existing vocabulary first.

`MAY` expresses permission, not a recommendation or a weaker form of `MUST`.
The author MUST state a recommendation as a recommendation and MUST NOT disguise
it as a mandatory requirement.

## Normative Rules

The author MUST write each independently testable obligation as a separate
clause. Each clause MUST identify:

1. The responsible actor or boundary.
2. The modal strength.
3. The required, prohibited, or permitted action or state.
4. The object or boundary affected.
5. The condition under which the rule applies.
6. The observable result when that result matters.

The author MUST state conditions and exceptions in the clause itself. The author
MUST NOT hide a requirement in a definition, example, rationale, comment,
diagram, or implication.

The author MUST use one canonical term for each concept within the document.
Terms MUST be defined before normative use when their meaning affects
interpretation. The author MUST use active voice and concrete subjects when that
makes responsibility clearer.

The author MUST use absolute words such as `only`, `sole`, `all`, and `complete`
only when the intended obligation really has that strength. Normative language
MUST NOT claim authority or certainty that the governing evidence does not
support.

## Examples

Valid normative clauses identify the actor, force, and boundary:

```text
The domain service MUST be the sole authoritative owner of order status.
The user interface MUST NOT mutate order status directly.
An adapter MAY cache a read-only representation of order status.
```

The following language is not sufficiently normative:

```text
Keep ownership clear where possible.
The UI should normally use the service.
Caching is fine if it does not cause problems.
```

The author MUST label examples and non-examples clearly. Examples MUST illustrate
the governing rules and MUST NOT silently add narrower requirements.

## Review Checklist

Before finalising a document written in normative technical language, verify:

- [ ] The normative vocabulary is defined near the beginning.
- [ ] `MUST`, `MUST NOT`, and `MAY` have the intended force.
- [ ] No undefined modal language creates a hidden requirement.
- [ ] Every obligation has an explicit actor, action, object, and condition.
- [ ] Each independently testable obligation is a separate clause.
- [ ] Conditions and exceptions are stated where they apply.
- [ ] Requirements are separate from facts, assumptions, rationale, and examples.
- [ ] The language is definitive about obligations without overstating uncertain facts.
