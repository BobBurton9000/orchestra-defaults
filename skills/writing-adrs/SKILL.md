---
name: writing-adrs
description: Creates, revises, audits, and prunes accepted architectural decision records (ADRs) as current, project-specific Markdown records. Use when the user requests ADR work or when an architectural decision is being made and this skill is in use.
---

# Writing ADRs

## Purpose

An architectural decision record (ADR) captures a consequential architectural choice as it applies now. It is a maintained, current record, not an immutable history of every decision ever made. Keep ADRs concise, relevant, and supported by verifiable information.

Use this skill to create, revise, review, or maintain ADRs, including during closely related architectural decision work when this skill is in use. Do not create ADRs for routine implementation choices. A decision is worth recording when it has meaningful alternatives, lasting architectural consequences, or significant effects on system boundaries, data, operations, or future change.

## Operating rules

- A saved ADR MUST represent an accepted decision. Do not save drafts, work in progress, or rejected proposals.
- `Accepted` is the only valid status for a saved ADR. Do not retain ADRs marked with another status.
- Do not infer architectural intent from code or tests. They establish observed implementation, not why it was chosen or whether it is still desired.
- Keep only current, relevant, verifiable facts and rationale. Do not preserve obsolete alternatives, assumptions, consequences, or decision history merely for completeness.
- Git history is the revision history. Do not add a change log to an ADR or rewrite Git history.
- Apply justifiable changes autonomously; do not request approval for a draft or for changes supported by clear evidence. Ask only when the intended decision, project authority, status, or applicable convention is unclear or conflicting.

## Workflow

### 1. Discover project conventions and inventory ADRs

1. Identify the project root and read its applicable agent instructions and canonical engineering documentation, such as engineering constitutions or architecture guidance.
2. Locate the project's ADR directory and template by inspecting its documentation and existing ADR files. Do not assume a directory or naming scheme when the project already establishes one.
3. Inventory and read the full ADR collection on every use of this skill. Look for outdated or non-canonical decisions, duplicated records, invalid statuses, and stale references.
4. If the project has multiple plausible ADR locations, conflicting templates, or incompatible conventions, ask the user which convention governs before modifying records.
5. If no ADR directory is established, use `<project-root>/docs/Engineering/` and create it if necessary. Independently, if no ADR format or template is established, use the co-located `adr.template.md` fallback.

Follow an established project format where it is compatible with this skill's lifecycle rules. If the project requires retaining superseded, retired, or draft ADRs, stop and ask rather than silently violating either convention.

### 2. Establish the accepted decision from evidence

Use the following evidence to establish intent:

- An explicit decision from the current user.
- A clearly designated project authority or canonical project document, when its authority is unambiguous.
- Repository documentation and implementation evidence to verify factual claims and consequences.

A project authority document and the current user's direction may both be authoritative. If they conflict, ask which governs. If code or tests conflict with an ADR, report the discrepancy and ask unless an explicit user decision or clearly authoritative project document resolves it. Never treat implementation alone as proof that the intended architecture changed.

Record a decision only when the user or a clearly designated project authority has explicitly chosen it. If the decision is still open, ask focused questions and do not save a WIP ADR. Omit or remove claims that cannot be verified from an authoritative source or explicit user input; do not invent rationale.

### 3. Choose the record to create, revise, or remove

- Keep one primary architectural decision per ADR. Group choices only when they are tightly coupled and cannot be understood separately.
- If the same decision is being clarified or refined, revise its existing ADR in place.
- If an accepted decision is reversed or replaced by a distinct decision, create a new ADR for the current decision and delete the old ADR. Do not retain a superseded or retired record, and do not mention the old decision in the new ADR.
- Search current project documentation for references to a deleted ADR. Replace a reference with the new ADR only when it still points to the current decision; otherwise remove it. Keep Git history intact.
- Before choosing a filename, search by subject as well as filename. Update the existing ADR when it records the same decision. Never overwrite a distinct record because its filename collides.

### 4. Purge non-canonical and outdated records

During the full collection scan:

- Delete any ADR explicitly marked with a status other than `Accepted`, including proposed, superseded, or retired records. Do this autonomously; do not preserve them as archives.
- If an ADR has no status or uses an unfamiliar status, do not assume it is invalid. Inspect its project context and ask the user how to handle it before deleting or changing it.
- Remove obsolete or unverifiable information from accepted ADRs when authoritative evidence establishes what is current. Keep only context, rationale, alternatives, consequences, and references that remain relevant and supportable.
- If an accepted ADR appears inconsistent with implementation but no authoritative source establishes a changed decision, ask rather than changing or deleting the architectural choice.
- Remove or update stale references in current project documentation as described above. Do not rewrite Git history.

### 5. Write autonomously and validate

Once an accepted decision and the applicable project conventions are clear, create or revise the ADR without a separate draft-approval step. For justifiable cleanup, apply the changes directly. If a decision, authority, status, or convention remains ambiguous, pause only that change and ask a focused question; do not guess.

After every create, revision, or deletion:

1. Verify the destination, filename, required sections, `Accepted` status, and dates.
2. Search current project documentation for stale references to deleted or renamed ADRs and confirm relevant links resolve.
3. Confirm the record contains only current, verifiable information and no obsolete decision history.
4. Report the files created, revised, or deleted, the evidence used, validation results, and anything left unresolved.

## Location, format, and naming

- Reuse a clear project ADR directory; otherwise use `<project-root>/docs/Engineering/`.
- Reuse a clear project ADR format or template; otherwise use the co-located `adr.template.md`.
- Use the existing project filename convention when one is established. Otherwise use `YYYY-MM-DD-kebab-case-title.md`, where the date is the date the decision is accepted.
- Keep the original filename and decision date when revising the same ADR. Update `Last updated` only for substantive revisions.
- If a distinct ADR has the same fallback date and title, add a numeric suffix such as `-2`; never overwrite it.
- Use `Status: Accepted` for every saved ADR. The fallback template includes the decision date and last-updated date. Add an owner only when one is known and useful.
- The fallback body has `Context`, `Decision`, and `Consequences` sections. Add `Alternatives considered` and `References` only when they contain useful, current information; omit empty sections.
- Keep authoring guidance in this skill, not in the copy-ready template.

## Review checklist

- [ ] The decision is consequential enough to warrant an ADR and has been explicitly accepted by the user or a clearly designated project authority.
- [ ] The full ADR collection was inspected; non-`Accepted` records were removed, and missing or unfamiliar statuses were handled by asking.
- [ ] The established project location, format, and naming convention were followed, or the fallback was used only when none exists.
- [ ] The ADR contains one primary decision, current context, a clear decision, and relevant consequences.
- [ ] Factual claims are verifiable; code and tests are not treated as proof of architectural intent.
- [ ] Same-decision refinements updated the existing record; reversals or distinct replacements created a new record and removed the old one.
- [ ] Current documentation references were updated or removed, without leaving references to deleted ADRs.
- [ ] The saved record has `Accepted` status, valid dates, no empty optional sections, and no change log.
- [ ] Validation and a concise action report were completed.
