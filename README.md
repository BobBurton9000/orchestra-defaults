# orchestra-defaults

Default package source for [Orchestra](https://github.com/BobBurton9000/orchestra) — the apt-style package manager for agents, prompts, and skills.

This repository is the canonical `core` source that ships preconfigured with Orchestra. It also serves as the reference example for anyone publishing their own Orchestra source.

## Contents

- **30 agents** in `agents/` — `*.agent.md`
- **12 prompts** in `prompts/` — `*.prompt.md` plus a `snippets/` companion directory
- **5 skills** in `skills/` — one directory per skill, each with a `SKILL.md`
- **Include files** in `include/` — shared markdown bodies referenced via `#include`

## Using this source with Orchestra

If you have Orchestra installed in `.orchestra/` of your project, `core` is already configured to point here:

```bash
.orchestra/orchestra.sh install orchestrator           # single agent
.orchestra/orchestra.sh install writing-gherkin        # single skill
.orchestra/orchestra.sh install --all core             # everything in this source
```

## Publishing your own source

See the Orchestra repo's `PUBLISHING.md` for the full guide. In short:

1. Create a GitHub repository
2. Add an `orchestra-source.list` at the root listing your packages
3. Push
4. Tell others to run `orchestra source add <your-owner>/<your-repo>`

The format of `orchestra-source.list`:

```
# package_name        type        path
triage-agent          agent       agents/triage-agent.agent.md
my-skill              skill       skills/my-skill/
my-prompt             prompt      prompts/my-prompt.prompt.md
snippets              prompt-dir  prompts/snippets/
```

Valid types: `agent`, `prompt`, `prompt-dir`, `skill`. For `skill` and `prompt-dir`, the path is a directory — every file in it is installed. For `agent` and `prompt`, the path is a single file.

You can regenerate this file from the directory layout by running:

```bash
orchestra generate-manifest /path/to/your/source/repo
```