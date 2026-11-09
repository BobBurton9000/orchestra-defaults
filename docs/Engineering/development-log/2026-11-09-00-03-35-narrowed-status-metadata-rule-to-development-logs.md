# 2026-11-09 — Narrowed status metadata rule to development logs

- Type: Documentation governance
- Scope: Status-metadata policy in the shared project documentation governance skill
- Context and evidence: The initial skill update retained a general prohibition on `Status` metadata in project documents. The user clarified that development-log entries must omit `Status`, while current roadmap status fields are acceptable.
- Decision or change: Kept the `Status` prohibition specific to Development Log entries. Permitted `Status` fields in other project documents when they communicate current approval, planning, or operational state. Retained the restrictions on `Last updated` and version-history metadata.
- Lesson learned: Status metadata can support current planning while remaining redundant in historical work records.
- Expected effect: Agents can preserve useful current-state status fields outside the Development Log while recording work in status-free entries; this effect has not yet been measured.
- Observed result: `bash orchestra-manifest.sh --check .` confirmed the package manifest remains current. `git diff --check` passed.
- Related entries: [Initial individual development-log policy](2026-11-08-23-30-48-updated-project-documentation-governance-for-individual-development-logs.md)
- Follow-up: Commit and push the clarified policy and this entry to `main`.
