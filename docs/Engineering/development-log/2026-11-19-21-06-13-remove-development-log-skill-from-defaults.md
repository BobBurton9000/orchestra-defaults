# 2026-11-19 — Remove the Development Log skill from Orchestra defaults

- Type: Source package migration
- Scope: `development-log` package, generated source manifest, and package catalogue
- Context and evidence: The shared `development-log` skill was listed as an installable package in Orchestra defaults, while the SpecFlow repository already maintained individual Development Log entries and referred users to the `core` package.
- Decision or change: Removed the skill from Orchestra defaults, regenerated its manifest, updated the package totals and catalogue, and moved the skill to the SpecFlow source.
- Observed result: The generated manifest check and `git diff --check` pass. The skill file is absent from Orchestra defaults and has been added to SpecFlow.
