---
name: github-cli
description: Guidance for using GitHub CLI (`gh`) for pull requests, issues, comments, checks, and API queries in this repository.
---

# GitHub CLI

## Purpose
Use GitHub CLI as the default interface for GitHub work from a local agent session in this repository.

## When to Use
- Inspect pull requests, issues, comments, reviews, and status checks.
- Create or update issues, pull requests, labels, or comments.
- Fetch structured GitHub data from REST or GraphQL endpoints.
- Script or automate GitHub work from the terminal.

## Core Rules

1. Prefer `gh` over other GitHub interfaces unless the task explicitly requires a different tool.
2. Use `--repo OWNER/REPO` whenever repository context could be ambiguous.
3. Prefer high-level subcommands first, then fall back to `gh api` or `gh api graphql` when needed.0
4Do not use `gh` to bypass repository workflow rules

## Command Reference

### Authentication and Context
- `gh auth status`
- `gh repo view OWNER/REPO`
- `gh api user`

### Pull Requests
- `gh pr list --repo OWNER/REPO`
- `gh pr view <number> --repo OWNER/REPO --comments`
- `gh pr diff <number> --repo OWNER/REPO`
- `gh pr checks <number> --repo OWNER/REPO`
- `gh pr create --repo OWNER/REPO --base main --head <branch> --title <title> --body-file <file>`
- `gh pr edit <number> --repo OWNER/REPO --title <title> --body-file <file>`

### Issues
- `gh search issues --repo OWNER/REPO --state open <keywords>`
- `gh search issues --repo OWNER/REPO --state closed <keywords>`
- `gh issue view <number> --repo OWNER/REPO --comments`
- `gh issue create --repo OWNER/REPO --title <title> --body-file <file>`
- `gh issue edit <number> --repo OWNER/REPO --title <title> --body-file <file>`
- `gh issue close <number> --repo OWNER/REPO --reason completed`
- `gh issue reopen <number> --repo OWNER/REPO`

### Comments and Reviews
- `gh pr comment <number> --repo OWNER/REPO --body-file <file>`
- `gh issue comment <number> --repo OWNER/REPO --body-file <file>`
- `gh api repos/OWNER/REPO/pulls/<number>/reviews`

### Low-Level API Access
- `gh api repos/OWNER/REPO/pulls/<number>/files`
- `gh api repos/OWNER/REPO/issues/<number>/comments`
- `gh api graphql -f owner=OWNER -f repo=REPO -F number=<number> -f query='...graphql...'`

## Standard Workflows

### Review a Pull Request
1. Inspect the pull request metadata with `gh pr view <number> --repo OWNER/REPO --comments`.
2. Inspect the changed files with `gh pr diff <number> --repo OWNER/REPO` or `gh api repos/OWNER/REPO/pulls/<number>/files`.
3. Check CI state with `gh pr checks <number> --repo OWNER/REPO`.

### Create or Update an Issue
1. Run duplicate checks with `gh search issues` against open and closed issues.
2. Inspect the closest matches with `gh issue view <number> --repo OWNER/REPO --comments`.
3. Create or update the issue with `gh issue create` or `gh issue edit`.

### Reach an Unsupported Endpoint
1. Start with the closest high-level `gh` command.
2. If the high-level command is insufficient, switch to `gh api` for REST.
3. Use `gh api graphql` for GitHub graph relationships or bulk structured queries.

## Guardrails

- Follow task-specific prompt wording when it mandates a specific GitHub workflow.
- Keep repository commands and GitHub commands separate: use the documented `docker/` wrapper for local runtime operations and `gh` for GitHub operations.
- Prefer readable command composition over long one-liners when multiple `gh` calls are needed.
- Summarise the important outcome for the user after running commands; do not assume they can see terminal output.