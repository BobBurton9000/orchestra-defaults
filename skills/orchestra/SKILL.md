---
name: orchestra
description: Use the installed Orchestra CLI to manage, compile, and verify AI agent, prompt, and skill definitions.
---

# Orchestra Usage

## Purpose and Scope

This skill gives binding instructions for using the modern Orchestra CLI in a project. It covers package discovery, installation, upgrades, definition authoring, platform export, and the optional delegation workflow.

This skill does not govern product code, domain rules, architectural ownership, or the implementation of Orchestra itself. Applicable repository policies remain authoritative for those concerns.

## Instruction Summary

1. You MUST invoke the configured CLI as `orchestra` from the repository root. The Orchestra program may be installed outside the repository.
2. You MUST treat `.agents/orchestra/` as the canonical definition tree.
3. You MUST treat `.agents/orchestra/.state/` as Orchestra's project state directory.
4. You MUST treat `.agents/skills/`, `.opencode/`, and `.github/` output as generated platform material.
5. You MUST inspect relevant package state before a mutating command.
6. You MUST stop and report the exact failure when a command, dependency, source, package, or export is unavailable or invalid.
7. You MUST report the command run, its result, and any changed paths.

## Definitions

- **Orchestra CLI**: The installed command available in the active shell as `orchestra`; its installation path is independent of the project.
- **Canonical definition**: An agent, prompt, or skill definition stored under `.agents/orchestra/`.
- **Project state**: Source configuration, package lockfile, cache, model configuration, and export metadata stored under `.agents/orchestra/.state/`.
- **Generated output**: A platform-specific file produced from canonical definitions by `orchestra export`.
- **Package**: An installable agent, prompt, prompt directory, or skill from an Orchestra source.
- **Source**: A GitHub repository with an `orchestra-source.yaml` manifest.
- **Lockfile**: `.agents/orchestra/.state/pkg.lock.yaml`, which records each installed package's source, commit SHA, type, and paths.
- **Export**: Compilation of canonical definitions into platform output and `.agents/skills/`.
- **Orchestrator**: The `mode: primary` agent that delegates work to installed `mode: subagent` agents.

## Authority and Precedence

You MUST apply authority in this order:

1. System and developer instructions.
2. The explicit user task and its constraints.
3. Repository instructions, constitutions, and mandatory policies.
4. This skill.
5. `orchestra help`, current Orchestra documentation, and observable CLI behaviour as tool references.

When tool documentation conflicts with command output, you MUST treat the command output as evidence, stop on unsafe ambiguity, and report the conflict.

## Inputs and Preconditions

You MUST establish all of the following before using a mutating Orchestra command:

- The current working directory is the repository root.
- `orchestra --version` succeeds in the active shell.
- The requested package, source, platform, or definition path is identified.
- The user task authorises the requested side effect.
- The command's prerequisites are available. Orchestra requires Bash 4.3+, `gh`, and `yq`; remote package operations require authenticated `gh` access.

If `orchestra` is unavailable, you MUST stop and report that prerequisite. You MUST NOT search for or invoke a repository-local Orchestra script as a fallback.

## Canonical Locations

| Purpose | Path |
|---|---|
| Canonical agents | `.agents/orchestra/agents/` |
| Canonical prompts | `.agents/orchestra/prompts/` |
| Canonical skills | `.agents/orchestra/skills/` |
| Sources | `.agents/orchestra/.state/sources.yaml` |
| Package lockfile | `.agents/orchestra/.state/pkg.lock.yaml` |
| Package cache | `.agents/orchestra/.state/pkg-cache/` |
| Default model configuration | `.agents/orchestra/.state/config.yml` |
| Export manifest and temporary files | `.agents/orchestra/.state/.manifest` and `.agents/orchestra/.state/.temp/` |
| Exported skills | `.agents/skills/` |
| OpenCode output | `.opencode/agents/` and `.opencode/commands/` |
| GitHub Copilot output | `.github/agents/` and `.github/prompts/` |

Project state and definitions are project files. You MUST follow repository version-control policy and explicit user instructions; you MUST NOT assume these paths are ignored or force-add/remove them without authorisation.

## Command Reference

All commands in this section MUST be run from the repository root using the configured `orchestra` command.

### Inspect

```bash
orchestra --version
orchestra help [command]
orchestra source list
orchestra list
orchestra list --available
orchestra search <term>
orchestra info <package>
orchestra status
```

`status` audits locked package paths and reports missing or untracked definition files. It does not refresh remote sources or modify package state.

### Install and Remove

```bash
orchestra install <package>[@<source>]
orchestra install <package> --locked
orchestra install --all <source>
orchestra remove <package>
```

`install --locked` uses the package SHA already recorded in the lockfile. Ordinary installation uses the cached source HEAD. On first state-managing use, Orchestra creates project state and the default `core` source configuration. `install` refreshes a cold package cache; you MAY run `orchestra update` first to explicitly refresh source metadata. `remove` deletes the paths recorded for the package and its lockfile entry.

For agents, Orchestra injects a model from `.agents/orchestra/.state/config.yml` during installation. You MUST NOT add a model to a shared agent source merely to choose a local model. Upgrades preserve the installed agent's existing model.

### Sources and Upgrades

```bash
orchestra source add <owner/repository> [name]
orchestra source subscribe <name>
orchestra source unsubscribe <name>
orchestra source list
orchestra source remove <name>
orchestra update
orchestra upgrade [package]
```

`source add` fetches a manifest and makes its packages available. It does not install packages. `source subscribe` enables discovery of packages added after the subscription baseline during a bulk upgrade. `source remove` MUST NOT be used while packages from that source remain installed.

Packages are versioned by source commit SHA rather than a static version number. You MUST use `update` before an upgrade when the current source manifest or HEAD SHA is unknown.

### Export and Convert

```bash
orchestra export opencode
orchestra export copilot
orchestra convert opencode [name]
orchestra convert copilot [name]
```

Both platform exports copy skills to `.agents/skills/`. `export opencode` also writes `.opencode/` output, while `export copilot` also writes `.github/` output. You MUST export the target platform after changing a canonical definition when that platform must consume the change.

`convert` imports existing platform agents into `.agents/orchestra/agents/`; it does not update the original platform file.

### Source Publishing

You MAY use:

```bash
orchestra generate-manifest [--check|--force] [directory]
```

Before creating or publishing an Orchestra source, you MUST consult the current Orchestra source-publishing documentation. Source publishing is outside the scope of this package-use workflow.

## Process

You MUST follow these steps for a package or definition task:

1. **Inspect:** Confirm the repository root, read relevant repository instructions, verify `orchestra --version`, and run `status` when package state matters.
2. **Discover:** Use `source list`, `list --available`, `search`, or `info` to verify package and source names before installation.
3. **Select:** Choose one exact command and target platform. You MUST NOT install, upgrade, remove, or export unrelated packages or platforms.
4. **Execute:** Run the command and preserve its output. You MUST NOT hide a non-zero exit status or continue as if the command succeeded.
5. **Export:** When a canonical definition changed and a platform consumes it, export that platform.
6. **Validate:** Inspect `status`, the relevant generated path, and the final repository diff. A failed validation MUST be reported as a failure.
7. **Report:** State the exact commands, results, changed canonical paths, and generated paths. State unavailable checks as unavailable.

## Output Contract

For each Orchestra command, you MUST report:

- **Command:** The exact command and arguments.
- **Result:** The exit result and the observable output.
- **Changed paths:** Every canonical or generated path changed by the command, or `None` when no path changed.
- **Verification:** The check that established success, or `Unavailable` with the reason.

When a command fails, you MUST report the failure before performing any dependent command.

## Definition Authoring and Compilation

When adding a local skill, you MUST create `.agents/orchestra/skills/<name>/SKILL.md` with `name` and `description` frontmatter. You MUST keep reusable companion files in the same skill directory.

When a definition uses an include, the include path MUST resolve from the project root. A section include uses `:#Heading`; missing files, missing headings, and circular includes are hard failures during export. You MUST fix the source definition rather than editing compiled output.

The canonical flow is:

```text
canonical definition -> compile and transform -> platform output
```

The platform output is derived material. You MUST NOT edit `.agents/skills/`, `.opencode/`, `.github/agents/`, or `.github/prompts/` as the source of truth.

## Orchestration Workflow

The delegation workflow is optional. A direct agent, prompt, or skill MAY be used without installing the Orchestrator.

When the Orchestrator is installed and exported:

1. The user invokes the `orchestrator` primary agent.
2. The Orchestrator delegates each scoped unit of work to a suitable subagent.
3. Subagents implement or review the delegated unit.
4. The Orchestrator coordinates review, scope checks, adjudication, and iteration.

The Orchestrator MUST coordinate rather than perform direct repository work. Delegation prompts MUST include all context required by the subagent because subagents do not share conversational context.

## Failure Behaviour

You MUST stop and report when any of the following occurs:

- `orchestra` is unavailable in the active shell.
- `gh` authentication or network access fails.
- `yq` or Bash does not satisfy the prerequisite.
- A source, package, lockfile entry, definition, include, or heading is absent.
- A command rejects an argument or an unsupported platform is requested.
- An export or conversion fails.
- The lockfile, canonical tree, or generated output is inconsistent.

You MUST NOT recover from an unexpected failure with a fabricated default, partial result, silent retry, repository-local fallback command, or unrelated command. You MAY rerun the same command only after identifying a bounded, observable cause and reporting the rerun.

## Valid Example

The user requests the `architect` agent for OpenCode. You run `orchestra list --available` or `orchestra info architect`, install the package if it is available, run `orchestra export opencode`, confirm `.opencode/agents/architect.md` exists, and report each command and result.

## Invalid Example

You edit `.opencode/agents/architect.md` directly and skip the canonical definition and export steps. This is invalid because generated platform output is not the source of truth and the change will be overwritten by a later export.

## Validation Checklist

You MUST confirm all applicable items before reporting completion:

- [ ] The modern `orchestra` command and required dependencies were identified.
- [ ] The requested package, source, definition, and platform were verified.
- [ ] The command was authorised by the task.
- [ ] Canonical definitions were kept under `.agents/orchestra/`.
- [ ] Generated output was produced through `export` where applicable.
- [ ] Lockfile and generated-path state were checked where applicable.
- [ ] Failures and unavailable checks were exposed rather than hidden.
- [ ] The final report names commands, results, and changed paths.
