# orchestra-defaults

The default `core` package source for [Orchestra](https://github.com/BobBurton9000/orchestra), the package manager and universal format for AI coding agents, prompts, and skills.

This repository is the source that ships preconfigured with Orchestra. It is also a complete example of a publishable Orchestra source. The [source manifest](orchestra-source.yaml) is the authoritative package list. See the [repository on GitHub](https://github.com/BobBurton9000/orchestra-defaults) for the published source.

## Contents

The current package layout contains **23 installable packages**:

| Type | Count | Location |
| --- | ---: | --- |
| Agents | 7 | [`agents/`](agents/) |
| Prompts | 4 | [`prompts/`](prompts/) |
| Skills | 12 | [`skills/`](skills/) |

## Package Catalogue

### Agents

Agents are markdown definitions with YAML frontmatter. One is a primary orchestrator; six are subagents.

#### Primary agent

| Package | Purpose |
| --- | --- |
| [`review-orchestrator`](agents/review-orchestrator.agent.md) | Loads the dedicated skill to coordinate a complete, evidence-based branch review and report. |

#### Subagents

| Package | Purpose |
| --- | --- |
| [`information-gatherer`](agents/information-gatherer.agent.md) | Collects bounded research from the codebase and GitHub. |
| [`judge`](agents/judge.agent.md) | Determines whether claims are supported by submitted and independent evidence. |

#### Review agents

| Package | Purpose |
| --- | --- |
| [`code-review.bugs`](agents/code-review.bugs.agent.md) | Reviews introduced code for logic errors, unhandled cases, and unintended consequences. |
| [`code-review.maintainability`](agents/code-review.maintainability.agent.md) | Reviews structure, readability, boundaries, and long-term maintenance risks. |
| [`code-review.simplify`](agents/code-review.simplify.agent.md) | Finds duplication, unnecessary complexity, missed reuse, and speculative abstractions. |
| [`code-review.solid`](agents/code-review.solid.agent.md) | Reviews introduced code for adherence to SOLID principles. |

### Prompts

| Package | Purpose |
| --- | --- |
| [`commit`](prompts/commit.prompt.md) | Removes temporary files and commits outstanding changes. |
| [`interactive-plan`](prompts/interactive-plan.prompt.md) | Based on Matt Pocock’s “Grill Me” skill; challenges an idea through focused questions. |
| [`refine-prompt`](prompts/refine-prompt.prompt.md) | Optimises a supplied prompt for LLM consumption. |
| [`transcribe-plan`](prompts/transcribe-plan.prompt.md) | Transcribes a plan to a uniquely named markdown file under `.temp/`. |

### Skills

| Package | Purpose |
| --- | --- |
| [`ado-import`](skills/ado-import/) | Fetches and parses Azure DevOps work items through ADO MCP tools. |
| [`how-to-delegate-to-subagents`](skills/how-to-delegate-to-subagents/) | Ensures delegation prompts contain the context required by independent subagents. |
| [`how-to-write-engineering-constitutions`](skills/how-to-write-engineering-constitutions/) | Creates and revises durable engineering constitutions. |
| [`github-cli`](skills/github-cli/) | Provides guidance for GitHub CLI work. |
| [`monozukuri`](skills/monozukuri/) | Applies Monozukuri, Kaizen, and Jidoka to engineering work. |
| [`normative-technical-writing`](skills/normative-technical-writing/) | Writes precise requirements using explicit normative language. |
| [`orchestra`](skills/orchestra/) | Describes the repository-local Orchestra package and export workflow. |
| [`review-orchestrator-instructions`](skills/review-orchestrator-instructions/) | Defines the exclusive review workflow and includes its Git hunk extraction helper. |
| [`writing-human-documents`](skills/writing-human-documents/) | Guides clear, engaging human documents. |
| [`writing-llm-documents`](skills/writing-llm-documents/) | Guides precise documents for reliable LLM interpretation. |
| [`writing-prds`](skills/writing-prds/) | Guides authoring and review of product requirements documents. |
| [`writing-typescript`](skills/writing-typescript/) | Defines the project's TypeScript conventions and rules. |

## Using This Source

Install Orchestra in a project first. Its local entry point is `.orchestra/orchestra.sh`. The `core` source is configured by default, so no source setup is needed for the packages in this repository. See the [Orchestra README](https://github.com/BobBurton9000/orchestra#setup) for installation instructions.

Using Orchestra requires Bash 4+, the GitHub CLI (`gh`), and `yq`. Remote package operations also require authenticated GitHub CLI access. The `review-orchestrator-instructions` helper additionally requires Git and Python 3.

### Quick start

Install the review orchestrator, its instructions skill, and selected reviewers, then export them to a platform:

```bash
.orchestra/orchestra.sh install review-orchestrator
.orchestra/orchestra.sh install review-orchestrator-instructions
.orchestra/orchestra.sh install code-review.bugs
.orchestra/orchestra.sh export opencode
```

To install every package in the default source:

```bash
.orchestra/orchestra.sh install --all core
```

The Orchestrator is optional. Any agent, prompt, or skill can be installed and used independently.

### Discover packages

```bash
.orchestra/orchestra.sh --version
.orchestra/orchestra.sh help [command]
.orchestra/orchestra.sh source list
.orchestra/orchestra.sh list --available
.orchestra/orchestra.sh search review
.orchestra/orchestra.sh info review-orchestrator
.orchestra/orchestra.sh status
```

### Install and remove packages

```bash
.orchestra/orchestra.sh install <package>
.orchestra/orchestra.sh install <package>@<source>
.orchestra/orchestra.sh install <package> --locked
.orchestra/orchestra.sh install --all <source>
.orchestra/orchestra.sh remove <package>
```

`--locked` installs the commit recorded in the local lockfile. Normal installation uses the cached source HEAD. Removing a package deletes the paths recorded for it and its lockfile entry.

### Update and upgrade

```bash
.orchestra/orchestra.sh update
.orchestra/orchestra.sh upgrade
.orchestra/orchestra.sh upgrade <package>
```

Packages are versioned by the source repository's commit SHA rather than a static version number. Run `update` to refresh source manifests and HEAD SHAs, then `upgrade` to install newer package content. Upgrades preserve the model selected for an installed agent.

Adding a source makes its packages available; it does not install them:

```bash
.orchestra/orchestra.sh source add <owner>/<repository> [name]
.orchestra/orchestra.sh source subscribe <name>
.orchestra/orchestra.sh source unsubscribe <name>
.orchestra/orchestra.sh source remove <name>
```

Subscriptions opt in to discovering packages added to a source after the subscription baseline. Use `install --all` when you want the source's current packages as well. A source cannot be removed while packages from it remain installed.

### Export to a platform

Canonical definitions are installed under `.agents/orchestra/`. Export them after installation or after changing a canonical definition:

```bash
.orchestra/orchestra.sh export opencode
.orchestra/orchestra.sh export copilot
.orchestra/orchestra.sh convert opencode [name]
.orchestra/orchestra.sh convert copilot [name]
```

Exports write platform-specific agents and prompts to `.opencode/` or `.github/`, and copy skills to `.agents/skills/`. `convert opencode` and `convert copilot` can import existing platform agents into canonical Orchestra definitions.

Source agent definitions do not contain a `model:` line. Orchestra injects the user's configured model during installation, allowing the same source to work with different models.

## Source Format

An Orchestra source is a Git repository with an `orchestra-source.yaml` file at its root. Package names must be unique within the source and paths are relative to the repository root.

```yaml
packages:
  - name: triage-agent
    type: agent
    path: agents/triage-agent.agent.md
  - name: my-prompt
    type: prompt
    path: prompts/my-prompt.prompt.md
  - name: snippets
    type: prompt-dir
    path: prompts/snippets/
  - name: my-skill
    type: skill
    path: skills/my-skill/
```

| Type | Manifest path | Package contents |
| --- | --- | --- |
| `agent` | A single file, conventionally `agents/*.agent.md` | One agent definition. |
| `prompt` | A single file, conventionally `prompts/*.prompt.md` | One prompt definition. |
| `prompt-dir` | A directory | Every file in the directory, installed as one prompt package. |
| `skill` | A directory containing `SKILL.md` | Every file in the directory, installed as one skill package. |

The manifest is generated from the source layout. Do not hand-maintain package entries when the generator can regenerate them.

## Generating the Manifest

This repository includes a standalone generator, so a source repository does not need a complete Orchestra installation:

```bash
bash orchestra-manifest.sh --force .
```

The generator discovers top-level `agents/*.agent.md` files, top-level `prompts/*.prompt.md` files, `prompts/snippets/`, and skill directories containing `SKILL.md`.

Useful options:

```bash
bash orchestra-manifest.sh --check .
bash orchestra-manifest.sh --force .
bash orchestra-manifest.sh --self-update --force .
```

`--check` fails when `orchestra-source.yaml` is missing or out of date and is suitable for CI. `--force` overwrites an existing manifest without prompting. `--self-update` downloads the latest generator from Orchestra and reruns the remaining arguments. The generator needs Bash and standard command-line utilities; self-update additionally needs `curl` or `wget`.

When Orchestra is installed, the equivalent command is:

```bash
.orchestra/orchestra.sh generate-manifest [--check|--force] [directory]
```

Run the generator and commit the updated `orchestra-source.yaml` whenever packages are added, removed, or renamed.

## Publishing a Source

For the complete publishing guide, see [Orchestra's `PUBLISHING.md`](https://github.com/BobBurton9000/orchestra/blob/master/PUBLISHING.md).

The short workflow is:

1. Create a GitHub repository.
2. Add agents, prompts, and skills using the conventional layout.
3. Generate the manifest with `bash orchestra-manifest.sh --force .`.
4. Check it with `bash orchestra-manifest.sh --check .`.
5. Commit and push the source repository.
6. Tell users to run `source add` with the repository path.

Users can give a source a custom local name and install a package from it explicitly:

```bash
.orchestra/orchestra.sh source add alice/orchestra-extras extras
.orchestra/orchestra.sh install triage-agent@extras
```

There are no static package versions or required releases. Pushing a new source commit makes new content available; users choose when to run `update` and `upgrade`.

## Repository Layout

```text
agents/                  Agent definitions
prompts/                 Prompt definitions
skills/                  Skill directories, each with SKILL.md
orchestra-source.yaml    Generated package manifest
orchestra-manifest.sh    Standalone manifest generator
RECOMMENDED_AGENTS.MD    Agent-selection guidance
README.md                This guide
```

Keep the package catalogue and counts in this README aligned with the repository layout and generated [`orchestra-source.yaml`](orchestra-source.yaml). Use `bash orchestra-manifest.sh --check .` to catch stale manifest entries.
