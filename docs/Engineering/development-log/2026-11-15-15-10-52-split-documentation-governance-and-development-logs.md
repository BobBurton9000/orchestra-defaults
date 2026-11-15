# 2026-11-15 — Split documentation governance and Development Logs

- Type: Skill maintenance
- Scope: Development Log skill, default-source manifest, and package catalogue
- Context and evidence: The default `project-documentation-governance` skill combined a broad documentation gate with its Development Log policy. SpecFlow has a distinct staged documentation lifecycle, so the user approved moving that lifecycle guidance to the SpecFlow source while retaining a portable log convention in defaults.
- Decision or change: Renamed the defaults skill and package to `development-log`, narrowed it to Development Log records, removed documentation-governance templates from that package, and updated the generated manifest and README catalogue.
- Observed result: `bash orchestra-manifest.sh --check .` passed. `git diff --check` passed. Local Markdown-link and whitespace checks passed for the updated README and skill. No application tests were run because this change affects only skills, package metadata, and documentation.
