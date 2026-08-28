---
name: orchestra
description: Use the repository's local Orchestra CLI to manage, compile, and verify AI agent, prompt, and skill definitions.
---

# Orchestra Usage

## Purpose and Scope

This skill is a binding instruction for an operator using the Orchestra tool in
this repository. It covers package discovery, installation, upgrades,
definition authoring, platform export, and the optional delegation workflow.

This skill does not govern product code, game rules, architectural ownership,
or the implementation of Orchestra itself. The Engineering Constitution and
other repository policies remain authoritative for those concerns.

## Instruction Summary

1. The operator MUST invoke the repository-local CLI at `.orchestra/orchestra.sh`.
2. The operator MUST treat `.agents/orchestra/` as the canonical definition tree.
3. The operator MUST treat `.agents/skills/`, `.opencode/`, and `.github/` output as
   generated platform material.
4. The operator MUST inspect the current Orchestra state before a mutating command.
5. The operator MUST stop and report the exact failure when a command, dependency,
   source, package, or export is unavailable or invalid.
6. The operator MUST report the command run, its result, and any changed paths.

## Definitions

- **Orchestra**: The repository-local CLI and definition system under
  `.orchestra/`.
- **Canonical definition**: An agent, prompt, or skill definition stored under
  `.agents/orchestra/`.
- **Generated output**: A platform-specific file produced from canonical
  definitions by `orchestra export`.
- **Package**: An installable agent, prompt, prompt directory, or skill from an
  Orchestra source.
- **Source**: A GitHub repository with an `orchestra-source.yaml` manifest.
- **Lockfile**: `.orchestra/pkg.lock.yaml`, which records each installed
  package's source, commit SHA, type, and paths.
- **Export**: Compilation of canonical definitions into platform output and
  `.agents/skills/`.
- **Operator**: The person or system using the Orchestra tool.
- **Orchestrator**: The `mode: primary` agent that delegates work to installed
  `mode: subagent` agents.

## Authority and Precedence

The operator MUST apply authority in this order:

1. System and developer instructions.
2. The explicit user task and its constraints.
3. Repository instructions, constitutions, and mandatory policies.
4. This skill.
5. `.orchestra/README.md`, `.orchestra/PUBLISHING.md`, command help, and the
   current Orchestra implementation as tool references.

When tool documentation conflicts with command output, the operator MUST treat the
command output as evidence, stop on unsafe ambiguity, and report the conflict.

## Inputs and Preconditions

The operator MUST establish all of the following before using a mutating Orchestra
command:

- The current working repository contains `.orchestra/`.
- The requested package, source, platform, or definition path is identified.
- The user task authorises the requested side effect.
- The command's prerequisites are available. Orchestra requires Bash 4+, `gh`,
  and `yq`; remote package operations require authenticated `gh` access.

When `.orchestra/` or a required dependency is missing, the operator MUST stop and
report the missing prerequisite. The operator MUST NOT substitute a global
`orchestra` command or invent a package, source, model, or path.

## Canonical Locations

| Purpose | Path |
|---|---|
| Orchestra implementation | `.orchestra/` |
| Canonical agents | `.agents/orchestra/agents/` |
| Canonical prompts | `.agents/orchestra/prompts/` |
| Canonical skills | `.agents/orchestra/skills/` |
| Installed package state | `.orchestra/sources.yaml`, `.orchestra/pkg.lock.yaml`, and `.orchestra/config.yml` |
| Exported skills | `.agents/skills/` |
| OpenCode output | `.opencode/agents/` and `.opencode/commands/` |
| GitHub Copilot output | `.github/agents/` and `.github/prompts/` |

The package state and platform output are local, generated state. The operator MUST
NOT add those ignored files to a commit unless an explicit task changes that
policy.

## Command Reference

All commands in this section MUST be run from the repository root using
`.orchestra/orchestra.sh`.

### Inspect

```bash
.orchestra/orchestra.sh --version
.orchestra/orchestra.sh help [command]
.orchestra/orchestra.sh source list
.orchestra/orchestra.sh list
.orchestra/orchestra.sh list --available
.orchestra/orchestra.sh search <term>
.orchestra/orchestra.sh info <package>
.orchestra/orchestra.sh status
```

`status` audits locked package paths and reports missing or untracked files. It
does not refresh remote sources or modify package state.

### Install and Remove

```bash
.orchestra/orchestra.sh install <package>[@<source>]
.orchestra/orchestra.sh install <package> --locked
.orchestra/orchestra.sh install --all <source>
.orchestra/orchestra.sh remove <package>
```

`install --locked` uses the package SHA already recorded in the lockfile.
Ordinary installation uses the cached source HEAD. `remove` deletes the paths
recorded for the package and its lockfile entry.

For agents, Orchestra injects a model from `.orchestra/config.yml` during
installation. The operator MUST NOT add a model to a shared agent source merely to
choose a local model. Upgrades preserve the installed agent's existing model.

### Sources and Upgrades

```bash
.orchestra/orchestra.sh source add <owner/repository> [name]
.orchestra/orchestra.sh source subscribe <name>
.orchestra/orchestra.sh source unsubscribe <name>
.orchestra/orchestra.sh source list
.orchestra/orchestra.sh source remove <name>
.orchestra/orchestra.sh update
.orchestra/orchestra.sh upgrade [package]
```

`source add` fetches a manifest and makes its packages available. It does not
install packages. `source subscribe` enables discovery of packages added after
the subscription baseline during a bulk upgrade. `source remove` MUST NOT be
used while packages from that source remain installed.

Packages are versioned by source commit SHA rather than a static version
number. The operator MUST use `update` before an upgrade when the current source
manifest or HEAD SHA is unknown.

### Export and Convert

```bash
.orchestra/orchestra.sh export opencode
.orchestra/orchestra.sh export copilot
.orchestra/orchestra.sh convert opencode [name]
.orchestra/orchestra.sh convert copilot [name]
```

Both platform exports copy skills to `.agents/skills/`. `export opencode` also
writes `.opencode/` output, while `export copilot` also writes `.github/`
output. The operator MUST export the target platform after changing a canonical
definition when that platform must consume the change.

`convert` imports existing platform agents into
`.agents/orchestra/agents/`; it does not update the original platform file.

### Source Publishing

Source authors MAY use:

```bash
.orchestra/orchestra.sh generate-manifest [--check|--force] [directory]
```

The operator MUST read `.orchestra/PUBLISHING.md` before creating or publishing an
Orchestra source. Source publishing is outside the scope of the package-use
workflow in this skill.

## Process

The operator MUST follow these steps for a package or definition task:

1. **Inspect:** Confirm the repository root, read relevant repository
   instructions, and run `status` when package state matters.
2. **Discover:** Use `source list`, `list --available`, `search`, or `info` to
   verify package and source names before installation.
3. **Select:** Choose one exact command and target platform. The operator MUST NOT
   install, upgrade, remove, or export unrelated packages or platforms.
4. **Execute:** Run the command and preserve its output. The operator MUST NOT hide
   a non-zero exit status or continue as if the command succeeded.
5. **Export:** When a canonical definition changed and a platform consumes it,
   export that platform.
6. **Validate:** Inspect `status`, the relevant generated path, and the final
   repository diff. A failed validation MUST be reported as a failure.
7. **Report:** State the exact commands, results, changed canonical paths, and
   generated paths. State unavailable checks as unavailable.

## Output Contract

For each Orchestra command, the operator MUST report:

- **Command:** The exact command and arguments.
- **Result:** The exit result and the observable output.
- **Changed paths:** Every canonical or generated path changed by the command,
  or `None` when no path changed.
- **Verification:** The check that established success, or `Unavailable` with
  the reason.

When a command fails, the operator MUST report the failure before performing any
dependent command.

## Definition Authoring and Compilation

When adding a local skill, the operator MUST create
`.agents/orchestra/skills/<name>/SKILL.md` with `name` and `description`
frontmatter. The operator MUST keep reusable companion files in the same skill
directory.

When a definition uses an include, the include path MUST resolve from the
project root. A section include uses `:#Heading`; missing files, missing
headings, and circular includes are hard failures during export. The operator MUST
fix the source definition rather than editing compiled output.

The canonical flow is:

```text
canonical definition -> compile and transform -> platform output
```

The platform output is derived material. The operator MUST NOT edit
`.agents/skills/`, `.opencode/`, `.github/agents/`, or `.github/prompts/` as the
source of truth.

## Orchestration Workflow

The delegation workflow is optional. A direct agent, prompt, or skill MAY be
used without installing the Orchestrator.

When the Orchestrator is installed and exported:

1. The user invokes the `orchestrator` primary agent.
2. The Orchestrator delegates each scoped unit of work to a suitable subagent.
3. Subagents implement or review the delegated unit.
4. The Orchestrator coordinates review, scope checks, adjudication, and
   iteration.

The Orchestrator MUST coordinate rather than perform direct repository work.
Delegation prompts MUST include all context required by the subagent because
subagents do not share conversational context.

## Failure Behaviour

The operator MUST stop and report when any of the following occurs:

- `gh` authentication or network access fails.
- `yq` or Bash does not satisfy the prerequisite.
- A source, package, lockfile entry, definition, include, or heading is absent.
- A command rejects an argument or an unsupported platform is requested.
- An export or conversion fails.
- The lockfile, canonical tree, or generated output is inconsistent.

The operator MUST NOT recover from an unexpected failure with a fabricated default,
partial result, silent retry, or unrelated fallback command. The operator MAY rerun
the same command only after identifying a bounded, observable cause and
reporting the rerun.

## Valid Example

The user requests the `architect` agent for OpenCode. The operator runs
`.orchestra/orchestra.sh list --available` or
`.orchestra/orchestra.sh info architect`, installs the package if it is
available, runs `.orchestra/orchestra.sh export opencode`, confirms
`.opencode/agents/architect.md` exists, and reports each command and result.

## Invalid Example

The operator edits `.opencode/agents/architect.md` directly and skips the canonical
definition and export steps. This is invalid because generated platform output
is not the source of truth and the change will be overwritten by a later
export.

## Validation Checklist

The operator MUST confirm all applicable items before reporting completion:

- [ ] The local `.orchestra/` tool and required dependencies were identified.
- [ ] The requested package, source, definition, and platform were verified.
- [ ] The command was authorised by the task.
- [ ] Canonical definitions were kept under `.agents/orchestra/`.
- [ ] Generated output was produced through `export` where applicable.
- [ ] Lockfile and generated-path state were checked where applicable.
- [ ] Failures and unavailable checks were exposed rather than hidden.
- [ ] The final report names commands, results, and changed paths.
