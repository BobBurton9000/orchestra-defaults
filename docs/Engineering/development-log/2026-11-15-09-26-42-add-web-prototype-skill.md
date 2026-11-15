# 2026-11-15 — Add web-prototype skill

- Type: Documentation and package addition
- Scope: `skills/web-prototype/`, the README package catalogue, and `orchestra-source.yaml`
- Context and evidence: The repository discovers skill packages from directories containing `SKILL.md`; the README catalogue and generated package manifest enumerate installed source packages. The user specified a concept-only skill defining a disposable single-HTML-file web mock, with self-contained JavaScript, simulated key interactions, references to existing local assets, and a review-artefact lifecycle.
- Decision or change: Added the `web-prototype` skill with the agreed definition and boundaries. Updated the README package counts and catalogue, then regenerated the source manifest.
- Lesson learned: The manifest generator discovers new skill directories, so package entries should be regenerated rather than hand-maintained.
- Observed result: `bash orchestra-manifest.sh --check .` passed and reported the manifest is up to date. `git diff --check` passed. The generated manifest reports 28 packages.
