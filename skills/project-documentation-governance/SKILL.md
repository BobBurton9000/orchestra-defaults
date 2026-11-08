---
name: project-documentation-governance
description: Records every completed project-file change in an individual development log and governs current, evidence-based documentation for consequential product and engineering work.
---

# Project Documentation Governance

## Purpose

Keep project documentation aligned with current approved product intent and the actual engineering system. Use documentation as a decision gate for consequential work, maintain canonical documents as living current-state references, and place concise module guides beside behaviour-owning code.

This skill is self-contained. Do not require another writing skill, template package, or validator to apply it.

## Normative terms

- **MUST** and **MUST NOT** state mandatory rules and prohibitions.
- **SHOULD** states the expected default. Depart only for a clear project-specific reason and report it.
- **MAY** states an optional practice.

Distinguish rules from recommendations, verified facts, rationale, examples, and unresolved questions. Never make uncertain facts sound certain.

## When this skill applies

The Development Log requirement in this skill applies to every completed task that changes project files intended for version control. This requirement applies even when a task does not trigger the full documentation gate.

Apply the full documentation gate to work that changes or creates:

- Product scope, user-visible behaviour, product rules, or user workflows.
- Engineering invariants, security, ownership, data boundaries, or architecture.
- Technology choices, deployment configuration, or verification strategy.
- Meaningful behaviour owned by a vertical module with a public capability contract.
- Project documentation itself.

Do not run a full documentation gate for a clearly mechanical change that has no effect on product behaviour, engineering decisions, module responsibility, or verification. If that impact is uncertain, inspect the relevant docs and code before deciding. The Development Log requirement still applies to every task that changes project files intended for version control.

## Canonical document set and authority

For a product-bearing software project, use these canonical paths and filenames:

```text
docs/
  Engineering/
    Architecture.md
    Constitution.md
    Tech_Stack.md
    Testing_Strategy.md
    decisions/                 # Material, current ADRs only
  Product/
    Specification.md
    Vision.md
```

For an engineering-only project, the four Engineering documents are the baseline. Do not invent Product documents; report that they are not applicable. Adapt the document contents to the project rather than copying product-specific material from another repository.

The documents have distinct responsibilities:

| Document | Current responsibility |
|---|---|
| `Constitution.md` | Durable engineering, ownership, security, data, and architectural invariants. |
| `Specification.md` | Detailed, approved product behaviour and observable requirements. |
| `Vision.md` | Current approved product direction and outcomes where the Specification is not detailed. It is not a claim that every intended behaviour is already implemented. |
| `Architecture.md` | The actual system/module map, boundaries, ownership, and implementation conventions. |
| `Tech_Stack.md` | Technology actually selected and configured, including versions when verifiable. |
| `Testing_Strategy.md` | Current verification boundaries, commands, prerequisites, and evidence. |
| ADRs | Current accepted rationale and consequences for material engineering decisions; they do not override the Constitution or approved product contract. |

Project/system instructions and applicable security requirements remain higher authority. The Constitution governs engineering constraints. The Specification governs detailed product behaviour within those constraints. The Vision guides product questions the Specification does not settle. Architecture, Tech Stack, Testing Strategy, and ADRs MUST remain consistent with those authorities.

Map changes to the documents they affect; do not edit every document mechanically:

- Product direction, audience, or outcomes → Vision.
- Product scope or behaviour → Specification.
- Durable engineering invariants or ownership/security rules → Constitution.
- Actual boundaries, modules, data flows, or implementation conventions → Architecture.
- Technology/configuration choices → Tech Stack.
- Verification commands, coverage boundaries, or prerequisites → Testing Strategy.
- A material, durable technical choice → a current ADR.
- Behaviour owned by a vertical module → its module guide and code references, as well as any affected canonical documents above.

Cross-check related documents and references even when only one needs substantive editing.

## Development-log records

### Definitions

- **Development Log**: The project archive at `docs/Engineering/development-log/`, containing one Markdown file for each completed development task in that repository.
- **Development-log entry**: One immutable Markdown record of the work performed in a completed task.
- **Project-file change**: A creation, modification, or deletion of a file intended to be version-controlled in the repository.

### Recording completed work

- The assistant MUST create one Development Log entry for each completed task that changes project files in the repository. A task that changes files in multiple repositories MUST receive one entry in each affected repository.
- The assistant MUST create the first Development Log entry and its parent directory when a task changes project files in a repository without an existing Development Log archive.
- The assistant MUST create the entry as part of the task it records. Creating that entry MUST NOT trigger a separate recursive entry for the act of logging.
- The assistant MUST NOT create a Development Log entry for discussion or investigation that changes no project files.
- If a task stops after making project-file changes, the assistant MUST record the work completed, the failure or unresolved verification, and any follow-up before reporting the task outcome.
- The assistant MUST NOT wait for human review or approval before creating a Development Log entry. The Development Log records the assistant's work for future agent and human reference; it is not an approval gate.
- If the assistant cannot create or validate the required entry, it MUST report the exact failure and MUST NOT claim the task is fully complete.

### File path and naming

Each Development Log entry MUST use this path and filename pattern:

```text
docs/Engineering/development-log/YYYY-MM-DD-HH-mm-ss-{slug}.md
```

- The timestamp MUST be the UTC time when the entry is created, in 24-hour time.
- The slug MUST be derived from the entry title as lowercase ASCII kebab-case and MUST preserve meaningful identifiers such as issue or PR numbers.
- If the timestamp and slug would produce a filename that already exists, the assistant MUST preserve the timestamp and append `-2`, `-3`, or the next available numeric suffix to the slug.
- Each file MUST contain exactly one Development Log entry. The assistant MUST NOT append entries to a single monolithic `development-log.md` file and MUST NOT create an index that duplicates the individual entries.

### Entry content

Each entry MUST include `Type`, `Scope`, `Context and evidence`, `Decision or change`, and `Observed result`. `Type` MUST be a concise project-appropriate category. An entry MUST include `Lesson learned`, `Expected effect`, `Follow-up`, and `Related entries` when they are applicable, and MUST omit inapplicable fields rather than adding filler values:

```markdown
# YYYY-MM-DD — Short title

- Type: <short work category>
- Scope: <affected project area>
- Context and evidence: <reason for the work and verified starting facts>
- Decision or change: <work performed>
- Lesson learned: <reusable learning, if any>
- Expected effect: <prediction, if one is useful; identify it as unmeasured>
- Observed result: <actual outcome; checks run and their results, or state that no verification was run>
- Follow-up: <remaining action, if any>
- Related entries: <relative links to related entries, if any>
```

- The assistant MUST distinguish predictions from observed results and MUST NOT claim that a check passed unless it ran or other evidence establishes that result.
- The assistant MUST NOT include a `Status`, `Last updated`, or human-approval metadata field in a Development Log entry.
- The entry heading MUST retain the event date where the recorded work occurred on a different date from the entry's creation. Otherwise, the heading date MUST match the UTC date in the filename.
- Links between Development Log entries MUST target the individual entry files using relative Markdown links.

### Existing single-file logs and corrections

- The assistant MUST NOT append a new entry to an existing single-file log.
- The assistant MUST obtain explicit user authorisation before migrating a single-file log or deleting its source file. Without that authorisation, it MUST leave the source file intact, create new entries in the canonical directory, and report the legacy file.
- During an authorized migration, the assistant MUST create one file per dated entry, preserve each entry's heading and substantive content, remove `Status` metadata fields, update moved relative links, and update references to the migrated records.
- During migration, the assistant MUST use verifiable source timestamps when available. For entries introduced in Git history, it MUST use the UTC committer timestamp of the commit that introduced the entry. If no verifiable source timestamp exists, it MUST use the UTC time when the individual file is created and preserve the original event date in the heading.
- The assistant MUST verify that every source entry has a corresponding individual file and that all migrated links resolve before removing the old single-file log.
- After creation or migration, the assistant MUST NOT edit or delete an individual Development Log entry. A correction or later evidence MUST be recorded in a new entry with a relative link to the earlier entry.

## Current-state and history policy

All maintained project documentation, except individual Development Log entries defined above, MUST describe current approved intent or current verified system behaviour. Product documents describe approved intent; engineering descriptions describe the actual system. If those disagree, report the discrepancy and ask whether the implementation must change or the approved product decision is changing. Do not silently make code the product authority or rewrite a specification to match code.

The Development Log is the sole exception to the current-state rule. Its entries preserve completed work as known when recorded and provide context for future agents and people. A Development Log entry MUST NOT establish or override current approved intent, current verified behaviour, or current task status.

All other project documentation MUST NOT retain historical behaviour, superseded decisions, obsolete alternatives, changelogs, decision timelines, status metadata, or links to prior decisions. Do not add `Status`, `Last updated`, version-history, or superseded-status fields to those documents or their templates. Git history is outside the documentation set and MUST NOT be rewritten.

Record an ADR only for a material decision with lasting consequences (for example, a change to security boundaries, ownership, persistence, architecture, or a major technology choice). Do not create ADRs for routine implementation choices. When an accepted decision changes, delete its obsolete ADR and stale references. If the current replacement still merits an ADR, write a new current-only record. Do not mention the prior decision in it.

When a project has no established ADR location or naming convention, use:

```text
docs/Engineering/decisions/YYYYMMDD-kebab-case.md
```

The filename date is the acceptance date of the current decision, not a history. Do not add status or date metadata inside the ADR. Respect a clear existing ADR convention only when it is compatible with the current-only policy; otherwise propose a migration and obtain approval before moving or deleting files.

## Markdown inventory and audit scope

For every relevant product or engineering change:

1. Enumerate project `.md` files outside dot-prefixed directories. Any directory whose name begins with `.` is out of scope, including `.agents`, `.pi`, `.opencode`, `.github`, and `.git`, even if it contains Markdown.
2. Exclude generated, vendored, and build output when repository evidence (such as ignore rules, build configuration, or project instructions) establishes those paths as generated or external. Do not exclude a directory merely because its name looks generic.
3. Search the in-scope Markdown for the affected feature, terms, module names, and referenced paths. Read each relevant match and its linked documents. For a broad behaviour or architecture change, read the complete canonical set and search the complete Markdown inventory.
4. Include relevant code comments and declaration links in the audit. Markdown templates and reusable generic instructions are inventory assets, not statements of host-project state; preserve generic placeholders. Audit them for project-specific claims, which must be current.

A portable initial inventory command is:

```bash
find . -mindepth 1 -type d -name '.*' -prune -o -type f -name '*.md' -print
```

Inspect repository ignore/build configuration to identify additional generated or vendored paths, then search the in-scope files for affected claims. Use available search tools and account for filenames containing spaces.

## Gate and change workflow

### 1. Establish the project state

- Identify the project root and read its instructions and applicable canonical documentation.
- Inventory the in-scope Markdown as above. Inspect relevant implementation, configuration, tests, and package manifests to verify technical facts.
- Treat code and tests as evidence of implementation, not proof of product intent or the reason for an architectural choice.
- Determine whether the project has product scope and which canonical documents apply.

### 2. Find gaps, conflicts, and stale claims

- Identify missing required documents, unsupported claims, conflicts, duplicate descriptions, broken links, and documentation made obsolete by the requested change.
- For an existing noncanonical layout, do not create duplicate documents or silently rename files. Propose a migration to the canonical paths, describe the reference updates, and obtain approval before destructive moves.
- When product intent, a governing rule, or an architectural decision is missing or ambiguous, the assistant MUST ask the user. Code, tests, and convention MUST NOT establish approval for a product or engineering decision. A clear, explicit user request MAY authorise a change that conflicts with current approved documentation; when the requested outcome or the affected decision remains ambiguous, the assistant MUST ask the user before changing it.
- Never leave unresolved placeholders or guesses in approved canonical documents. If an unknown does not block the task, omit the unsupported claim and report the gap; if it blocks the work, pause for the user's answer.

### 3. Keep governing documents aligned with implementation

For a code task that changes product behaviour, an engineering invariant, security, or architecture:

1. The assistant MUST identify the affected governing documents and determine whether the user has clearly authorised the requested decision before changing the implementation.
2. When the user explicitly authorises a behaviour or decision that differs from current approved documentation, the assistant MUST implement the requested change and update the affected canonical documents in the same work. The assistant MUST NOT require a separate doc-only proposal or pre-implementation documentation approval.
3. When the task does not clearly authorise the conflicting behaviour, or a material decision remains ambiguous, the assistant MUST ask a focused question before changing code or governing documents. The assistant MUST NOT implement dependent code until the user resolves the ambiguity.
4. The assistant MUST include necessary stale-content and reference cleanup with the governing-document updates.

A direct doc-only request authorises its requested non-destructive documentation edits; it does not need a second approval. The assistant MUST obtain explicit approval before deleting a whole documentation file or migrating its path. Replacing stale sections or claims in an otherwise current document is ordinary maintenance when the governing change is authorised.

Verified descriptive facts, such as current package versions, module maps, test commands, and prerequisites, MAY be updated alongside or after implementation once evidence establishes them.

### 4. Implement and maintain embedded module documentation

A meaningful product-behaviour vertical module with a public capability Contract SHOULD have a colocated guide at:

```text
src/modules/<module>/README.md
```

A clear exception is appropriate for a trivial module or infrastructure-only module with no meaningful product behaviour. Do not create empty guides merely to satisfy a directory rule. A guide explains the module's purpose and ownership, public capability/Contract, important behaviour and rules, boundaries/interactions, and relevant verification. Keep it subordinate to the Product Specification and Constitution; do not duplicate them.

Update the module guide and code references alongside the implementation and any affected canonical-document changes. A code change that alters module behaviour MUST leave its guide, public Contract, and relevant declaration links accurate.

For a documented module:

- Place a concise TSDoc-style comment above its primary public Contract declaration, with a one-sentence purpose and a relative Markdown link to the relevant guide section.
- When the primary behaviour is encapsulated in a distinct behaviour-owning class, put the same kind of comment above that class too. Do not add links to every helper or class mechanically.
- Resolve the Markdown path relative to the source file. Link to a specific section using the project's heading-anchor convention (normally a unique lowercase hyphenated heading fragment).
- Verify that both the path and section anchor exist after edits. Update links when a heading or module path changes.
- Keep detailed behaviour in Markdown rather than duplicating it in comments. Put comments on declarations, never inside function bodies, and respect stricter project language rules.

Example from `src/modules/claims/private/ClaimCompletion.ts`:

```ts
/**
 * Coordinates claim completion and participant awards.
 * @see [Claims module guide](../README.md#behaviour-and-rules)
 */
export class ClaimCompletion {}
```

The module guide template is `templates/module-guide.template.md`.

### 5. Reconcile all current documentation after implementation

After relevant code work:

1. Re-enumerate in-scope `.md` files and search for affected terms, old behaviour, old decisions, and obsolete paths.
2. Read every relevant hit and cross-linked document. Update all project-specific claims that the change made inaccurate; remove obsolete explanations and references rather than appending a historical account.
3. Verify that the Product Specification still expresses approved behaviour and that implementation discrepancies are resolved or reported. Verify engineering descriptions against the resulting code/configuration and actual commands where feasible.
4. Check relevant relative links, heading fragments, module guides, code declaration comments, and README entry points.
5. Report any remaining gap or unavailable verification. Do not claim a check passed unless it was run or otherwise established.

## Authoring rules

- Use `templates/` as scaffolds, not as project facts. Read the relevant template before drafting. Replace every placeholder; remove an inapplicable section or state why it does not apply. Do not leave template instructions in a final document.
- Use project evidence for current engineering facts: source/configuration, dependency manifests and locks, test definitions, CI configuration, and runnable commands. Verify exact versions and commands rather than guessing.
- Ask the user for product intent, authority, and decisions that repository evidence cannot establish. Do not infer product requirements from existing behaviour.
- The Constitution and Specification MUST define `MUST`, `MUST NOT`, and `MAY` near the beginning when they use them normatively. Use each term with its defined force. State recommendations as recommendations, not as disguised requirements.
- Make product requirements observable and testable. Separate requirements from rationale, verified facts, examples, and recommendations. Use stable terminology and link related canonical documents rather than copying their full content.
- Keep Architecture, Tech Stack, Testing Strategy, and module guides descriptive of the current system. A future capability belongs in approved product intent, not in an engineering description as though it already exists.
- Add concise relative links between related documents. If a root README exists, link it to the Engineering and Product entry points that apply. Check links and fragments during audits.
- Do not add historical timelines, prior-state descriptions, changelogs, status/version-history metadata, stale decisions, or unverified claims.

## Bundled templates

These project-neutral templates are part of this skill and are not host-project documentation:

- `templates/engineering-constitution.template.md`
- `templates/architecture.template.md`
- `templates/tech-stack.template.md`
- `templates/testing-strategy.template.md`
- `templates/product-specification.template.md`
- `templates/product-vision.template.md`
- `templates/adr.template.md`
- `templates/module-guide.template.md`

Templates establish a small baseline. Adapt them to the project without weakening the authority model or adding unsupported content. The host project's final documents MUST describe only current approved intent or verified current state.

## Completion report

For relevant work, report:

- The Development Log entry created for each affected repository, or the exact reason it could not be created.
- Which canonical and module documents were read, created, revised, or proposed.
- Any conflicts, gaps, approvals, or explicit non-applicability decisions.
- Which stale claims, ADRs, links, or references were removed.
- Which code declaration links and Markdown paths/fragments were checked.
- Verification actually performed and any unavailable checks.
