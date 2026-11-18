---
name: development-log
description: Records completed implementation and substantive maintenance work in immutable, evidence-based Development Log entries.
---

# Development Log

## Purpose

Create a concise, reliable record of completed implementation and substantive maintenance work. The Development Log is an archive of observed work, not a source of current product intent, engineering policy, or task status.

This skill governs Development Log records only. It does not prescribe a project's canonical documentation layout or require a general documentation audit. Follow a more specific, applicable workflow policy when it defines which workflow stages require a log entry.

## Normative terms

- **MUST** and **MUST NOT** state mandatory rules and prohibitions.
- **SHOULD** states the expected default. Depart only for a clear project-specific reason and report it.
- **MAY** states an optional practice.

Never state an unverified fact or claim a check passed unless it ran or other evidence establishes that result.

## When to record work

- Create one Development Log entry for each completed, user-directed implementation or substantive maintenance task that changes files intended for version control. A task executed across multiple repositories MUST receive one entry in each affected repository.
- Treat a cohesive batch performed as one user-directed task as one entry; record its material task IDs or work items in the entry where useful.
- A workflow-specific policy MAY exempt temporary planning artefacts, generated files, or particular stages, or define a more precise logging boundary. Follow that policy rather than logging each intermediate artefact change automatically.
- If work stops after changing project files, record the work completed, the failure or unresolved verification, and any follow-up before reporting the outcome.
- Do not create an entry for discussion or investigation that changes no project files.
- Create the entry as part of the task it records. Creating the entry MUST NOT trigger a separate recursive entry for the act of logging.
- Do not wait for human review or approval before creating an entry. If the entry cannot be created or validated, report the exact failure and do not claim the task is fully complete.

## Location and filename

Use the project's established Development Log location and naming convention when one exists. Otherwise, use:

```text
docs/Engineering/development-log/YYYY-MM-DD-HH-mm-ss-{slug}.md
```

- The timestamp MUST be the UTC time when the entry is created, in 24-hour time.
- Derive the slug from the entry title as lowercase ASCII kebab-case. Preserve meaningful identifiers such as issue or PR numbers.
- If the timestamp and slug would produce a filename that already exists, preserve the timestamp and append `-2`, `-3`, or the next available numeric suffix to the slug.
- Each file MUST contain exactly one Development Log entry. Do not append entries to a monolithic log or create an index that duplicates the individual entries.
- Create the parent directory and first entry when needed.

## Entry content

Each entry MUST include `Type`, `Scope`, `Context and evidence`, `Decision or change`, and `Observed result`. Include `Lesson learned`, `Expected effect`, `Follow-up`, and `Related entries` when applicable; omit inapplicable fields rather than adding filler values.

```markdown
# YYYY-MM-DD — Short title

- Type: <short work category>
- Scope: <affected project area>
- Context and evidence: <reason for the work and verified starting facts>
- Decision or change: <work performed>
- Lesson learned: <reusable learning, if any>
- Expected effect: <prediction, if useful; identify it as unmeasured>
- Observed result: <actual outcome; checks run and their results, or state that no verification was run>
- Follow-up: <remaining action, if any>
- Related entries: <relative links to related entries, if any>
```

- Distinguish predictions from observed results.
- Do not include `Status`, `Last updated`, or human-approval metadata fields.
- The heading MUST retain the event date if the recorded work occurred on a different date from entry creation. Otherwise, it MUST match the UTC date in the filename.
- Links between Development Log entries MUST target individual entry files using relative Markdown links.

## Existing logs and corrections

- Do not append a new entry to an existing single-file log.
- Obtain explicit user authorisation before migrating a single-file log or deleting its source file. Without authorisation, leave the source file intact, create new entries in the established individual-entry location, and report the legacy file.
- During an authorised migration, create one file per dated entry, preserve each entry's heading and substantive content, remove `Status` metadata fields, update moved relative links, and update references to migrated records.
- Use verifiable source timestamps during migration. For entries introduced in Git history, use the UTC committer timestamp of the commit that introduced the entry. If no verifiable source timestamp exists, use the UTC time when the individual file is created and preserve the original event date in the heading.
- Verify that every source entry has a corresponding individual file and all migrated links resolve before removing the old single-file log.
- After creation or migration, treat an individual Development Log entry as immutable in substance. Formatting-only edits MAY be made, including whitespace, line wrapping, and Markdown formatting changes, provided they preserve all wording, facts, links, and meaning. Review formatter diffs to confirm they change presentation only. Do not edit or delete an entry to correct or change its recorded facts, decisions, scope, or other substantive content. Record corrections or later evidence in a new entry with a relative link to the earlier entry.

## Authority and completion

Development Log entries preserve completed work as it was known when recorded. They MUST NOT establish or override current approved intent, current verified behaviour, or current task status. Consult current project documentation and implementation evidence for those facts.

When reporting a completed task, identify the Development Log entry created, or report the exact reason it could not be created. State verification actually performed and any unavailable checks.
