---
name: github-cli
description: Guidance for using GitHub CLI (`gh`) to work with repositories, pull requests, issues, checks, and GitHub APIs.
---

# GitHub CLI

## Purpose and Scope

This skill guides GitHub operations performed with GitHub CLI (`gh`) from a local agent session. It covers repository inspection, pull requests, issues, comments, checks, and API queries.

This skill does not override the task's instructions, repository policies, approval requirements, or documented local workflows.

## Instruction Summary

1. You MUST use `gh` as the primary interface for GitHub operations unless the task requires another interface.
2. You MUST specify a repository when the current context does not identify it unambiguously.
3. You MUST use high-level `gh` commands when they provide the required operation.
4. You MUST NOT use `gh` to bypass repository workflow or approval requirements.
5. You MUST report the important result and any failure to the user.

## Definitions

- **GitHub CLI (`gh`)**: The command-line interface for GitHub operations.
- **Repository selector**: The `--repo OWNER/REPO` argument that identifies a GitHub repository.
- **High-level command**: A dedicated `gh` command such as `gh pr view` or `gh issue create`.
- **API command**: A REST or GraphQL request made with `gh api` or `gh api graphql`.

## Command Selection

- You MUST use GitHub CLI as the primary interface for GitHub operations unless the task explicitly requires another interface.
- You MUST include `--repo OWNER/REPO` whenever the current directory or task context does not identify the repository unambiguously.
- You MUST choose a high-level command when it provides the required operation.
- You MAY use `gh api` when a high-level command cannot provide the required data or operation.
- You MUST NOT use GitHub CLI to bypass a repository's branch, review, approval, or release workflow.
- You MUST follow the repository's documented workflow for local commands and runtime operations; this skill does not prescribe a project-specific wrapper.

## Command Reference

### Authentication and Context

```bash
gh auth status
gh repo view OWNER/REPO
gh api user
```

### Pull Requests

```bash
gh pr list --repo OWNER/REPO
gh pr view NUMBER --repo OWNER/REPO --comments
gh pr diff NUMBER --repo OWNER/REPO
gh pr checks NUMBER --repo OWNER/REPO
gh pr create --repo OWNER/REPO --base BASE_BRANCH --head BRANCH --title TITLE --body-file FILE
gh pr edit NUMBER --repo OWNER/REPO --title TITLE --body-file FILE
```

### Issues

```bash
gh search issues --repo OWNER/REPO --state open KEYWORDS
gh search issues --repo OWNER/REPO --state closed KEYWORDS
gh issue view NUMBER --repo OWNER/REPO --comments
gh issue create --repo OWNER/REPO --title TITLE --body-file FILE
gh issue edit NUMBER --repo OWNER/REPO --title TITLE --body-file FILE
gh issue close NUMBER --repo OWNER/REPO --reason completed
gh issue reopen NUMBER --repo OWNER/REPO
```

### Comments and Reviews

```bash
gh pr comment NUMBER --repo OWNER/REPO --body-file FILE
gh issue comment NUMBER --repo OWNER/REPO --body-file FILE
gh api repos/OWNER/REPO/pulls/NUMBER/reviews
```

### Low-Level API Access

```bash
gh api repos/OWNER/REPO/pulls/NUMBER/files
gh api repos/OWNER/REPO/issues/NUMBER/comments
gh api graphql -f owner=OWNER -f repo=REPO -F number=NUMBER -f query='...graphql...'
```

## Standard Workflows

### Review a Pull Request

1. You MUST inspect the pull request metadata with `gh pr view NUMBER --repo OWNER/REPO --comments`.
2. You MUST inspect the changed files with `gh pr diff NUMBER --repo OWNER/REPO` or the pull request files API.
3. You MUST check CI state with `gh pr checks NUMBER --repo OWNER/REPO` when CI status is part of the requested review.

### Create or Update an Issue

1. You MUST search open and closed issues for duplicates before creating an issue.
2. You MUST inspect the closest matches before deciding whether to create or update an issue.
3. You MUST use `gh issue create` or `gh issue edit` for the selected operation.

### Reach an Unsupported Endpoint

1. You MUST start with the closest high-level `gh` command.
2. You MAY use `gh api` for REST when a high-level command cannot satisfy the task.
3. You MAY use `gh api graphql` for graph relationships or bulk structured queries when REST or high-level commands are insufficient.

## Failure Behaviour

- You MUST check authentication with `gh auth status` when an operation requires authentication and authentication state is unknown.
- When authentication, permissions, network access, or a required endpoint is unavailable, you MUST report the exact failure and stop dependent GitHub operations.
- You MUST NOT hide a failed command or report success without observable evidence.
- You MUST summarise the outcome for the user; you MUST NOT assume the user can see terminal output.

## Valid Example

A user asks for the status of a pull request in `OWNER/REPO`. You run `gh pr view NUMBER --repo OWNER/REPO --comments`, inspect any required checks with `gh pr checks NUMBER --repo OWNER/REPO`, and report the observed result.

## Invalid Example

A repository requires review before merging. You use `gh` to merge the pull request without the required approval. This is invalid because GitHub CLI MUST NOT bypass repository workflow or approval requirements.
