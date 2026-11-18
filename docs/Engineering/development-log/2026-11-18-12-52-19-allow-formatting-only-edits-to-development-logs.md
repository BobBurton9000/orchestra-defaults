# 2026-11-18 — Allow formatting-only edits to Development Logs

- Type: Policy clarification
- Scope: Development Log skill
- Context and evidence: The skill prohibited all edits to an individual Development Log entry after creation or migration, which also blocked harmless formatting-only cleanup.
- Decision or change: Clarified that formatting-only edits are permitted when they preserve all wording, facts, links, and meaning. Substantive corrections and changes remain prohibited and must be recorded in a new linked entry.
- Observed result: `git diff --check` passed. No tests were run; this was a documentation-only change.
