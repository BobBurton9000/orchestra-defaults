---
name: review-orchestrator-instructions
description: Exclusive procedure for reviewing the committed changes on the current Git branch, dynamically delegating same-language batches to all applicable code-review subagents, and writing a complete Markdown report
---

# Use Restriction

This skill is exclusively for the dedicated `review-orchestrator` primary agent.

- Any other agent MUST NOT load or use this skill.
- A code-review subagent MUST review only its delegated batch and MUST NOT invoke this orchestration procedure.
- An agent other than `review-orchestrator` that receives this skill as a task MUST refuse to run it and MUST direct the user to the dedicated primary agent.

# Purpose and Scope

The skill directs `review-orchestrator` through a read-only review of the committed changes on the current branch, compared with a base branch as a pull request would be compared. It extracts changed Git hunks, creates same-language review batches, delegates them to every applicable dynamically discovered code-review subagent, and writes a consolidated Markdown report under `.temp/`.

The skill does not author fixes, run tests on behalf of reviewers, alter Git state, or post pull-request reviews.

# Normative Vocabulary

- `MUST` means mandatory. `MUST NOT` means prohibited. `MAY` means permitted but not required.
- `Review run` means one complete invocation of this procedure.
- `Base` means the target branch or commit against which the branch is compared.
- `Review batch` means one same-language set of related changed hunks sent to reviewers.
- `Applicable reviewer` means an available code-review subagent whose declared remit covers the batch and whose language or framework constraints do not exclude it.
- `Constitution reviewer` means an applicable reviewer whose logical name contains the case-insensitive substring `constitution`.
- `Bug reviewer` means an applicable reviewer whose logical name contains the case-insensitive substring `bug`, unless it is already classified as a constitution reviewer.
- `Other reviewer` means an applicable reviewer matching neither higher-priority tier.
- `Review phase` means one tier of reviewer assignments processed in priority order.
- `Incomplete review` means at least one changed unit or required reviewer result is unavailable, failed, or not accounted for.

Higher-priority system, developer, and user instructions take precedence over this skill.

# Authority and Boundaries

- The caller's requested review boundary and explicit `--base` value MUST be preserved.
- The current repository's `.gitignore` is authoritative for ignoring `.temp/`. This skill MUST NOT create or edit `.gitignore`.
- The orchestrator MUST remain read-only with respect to reviewed source files, Git refs, the index, and pull-request state.
- The orchestrator MAY execute the co-located helper, inspect its temporary bundle, inspect agent definitions and review evidence, delegate to subagents, and create a report under `.temp/`.
- The orchestrator MUST NOT fix findings, stage changes, commit, fetch or push, or submit or modify a pull-request review.
- The orchestrator MUST delegate code analysis to reviewers rather than replacing their independent review with its own.

# Inputs and Preconditions

The review compares the current `HEAD` with one Base. The helper accepts only an optional `--base REF` argument. It MUST NOT accept or include working-tree changes.

The environment MUST provide Git, Bash 4 or later, and Python 3. The helper uses only Python's standard library. The invocation MUST start in the target Git working tree. The orchestrator MUST NOT fetch remote refs; the report MUST identify the exact commits actually used.

The review MUST stop before diff extraction if `git status --porcelain` reports staged, unstaged, untracked, or submodule changes. Git's ignore rules apply. The repository owner is responsible for ignoring `.temp/`; this skill MUST NOT bypass dirty-tree checks for report files or other paths.

# Definitions

- **PR-style diff:** the tree diff from `merge-base(Base, HEAD)` to `HEAD`, equivalent to `git diff Base...HEAD`. Commits that exist only on Base MUST NOT be included as changes from the current branch.
- **Changed lines:** additions plus deletions in a patch hunk. Context lines do not count.
- **Hunk unit:** one native unified-diff hunk, including its file headers and context.
- **Temporary bundle:** an external-to-repository directory containing `manifest.json`, the full diff, and one patch file per hunk. A file-level patch MAY also be present for a textual file change that has no hunk.
- **Reviewer roster:** the set of subagents currently available to the runtime, not a fixed list of agent names.

# Review Process

## 1. Resolve the repository and working-tree state

1. The orchestrator MUST locate the Git repository root and resolve `HEAD`. If the invocation is outside a Git repository or `HEAD` cannot be resolved, the orchestrator MUST stop.
2. The orchestrator MUST inspect the working-tree status, including untracked files and submodule changes. If the working tree is dirty, the orchestrator MUST stop before selecting a Base or extracting a diff. It MUST record the status entries for a blocker report and MUST NOT read or review uncommitted content.
3. The orchestrator MUST honour `.gitignore` exactly as configured by the repository owner and MUST NOT alter ignore rules.

## 2. Resolve the Base and PR-style diff

1. If the caller supplies `--base REF`, the orchestrator MUST resolve that ref to a commit. If it is invalid, the orchestrator MUST stop and report the exact ref.
2. Otherwise, the orchestrator MUST choose the Base using this precedence:
   1. The commit named by `refs/remotes/origin/HEAD`, if it resolves.
   2. Exactly one of `origin/main` or `origin/master`, if exactly one resolves.
   3. Exactly one of local `main` or `master`, if exactly one resolves.
3. If no candidate resolves or a fallback level has more than one candidate, the orchestrator MUST stop and require an explicit `--base`. It MUST NOT guess from the current branch's upstream.
4. The orchestrator MUST compute `merge-base(Base, HEAD)`. If no merge base exists, it MUST stop and MUST NOT substitute a two-dot comparison or another ref.
5. The orchestrator MUST compare that merge-base commit to `HEAD`. It MUST NOT include changes that exist only on Base or fetch/update refs.
6. The orchestrator MUST record the Base ref, Base commit, merge-base commit, current branch name (or detached-HEAD identity), and `HEAD` commit in the report.

## 3. Run the helper and account for the diff

The helper `review-orchestrator.sh` is co-located with this `SKILL.md` in the installed skill package. The orchestrator MUST locate that sibling helper from the active skill installation and MUST NOT substitute an unrelated script.

The orchestrator MUST run it as `bash <skill-directory>/review-orchestrator.sh [--base REF]`. It MUST NOT add flags that include working-tree changes.

- Exit status `0` with `STATUS: no_changes` means the comparison is empty. The orchestrator MUST write a report stating `No changes to review`, with zero batches and zero reviewer delegations.
- Exit status `0` with `STATUS: ready` supplies the temporary-bundle path and metadata. The orchestrator MUST read `manifest.json` and each relevant patch before creating batches.
- Any non-zero exit status is a pre-review blocker. The orchestrator MUST write a uniquely named blocker report when the repository and `.temp/` are available. It MUST include the exact error and helper diagnostics, mark the review `Not performed`, and dispatch no reviewers.
- When the helper reports a dirty tree, the orchestrator MUST include its Git status entries in the blocker report. It MUST NOT continue even if the caller's requested Base is resolvable.
- When a bundle exists and a later step fails or coverage is incomplete, the orchestrator MUST retain it and record its path in the report. It MUST remove the bundle only after a complete review report is successfully written.

The helper records all changed paths, including binary and submodule changes. The orchestrator MUST keep every path in the coverage ledger. Binary files and submodules MUST be reported as not reviewable by code hunk delegation; the orchestrator MUST NOT silently omit them. A textual change with no native hunk MUST be recorded as a file-level change and assigned to reviewers when its change is assessable.

## 4. Classify and batch the changed hunks

The helper's extension-based language label is a hint. The orchestrator MUST inspect the path and available patch evidence to correct an ambiguous or unknown classification before dispatch.

- Every textual hunk MUST be assigned to exactly one review batch.
- A review batch MUST contain one programming or document language only.
- The orchestrator MUST group related hunks by a shared feature, symbol, call chain, or other evidence visible in the diff and repository context. It MUST NOT group unrelated changes merely to meet the size limit.
- The orchestrator MUST limit each batch to 500 changed lines, except for a batch containing only all changes to one file whose total exceeds 500 changed lines.
- If a related multi-file group exceeds 500 changed lines, the orchestrator MUST split it at file boundaries and preserve the cross-batch relationship as context.
- If all changes to one file exceed 500 changed lines, the orchestrator MUST keep every hunk from that file together in one file-level batch, even when that batch exceeds 500 lines. It MUST NOT split that file's hunks.
- The helper MUST NOT split native Git hunks. The orchestrator MUST preserve each hunk's full patch and line range.
- Each batch MUST have a stable identifier, language, changed paths and hunks, changed-line total, and any cross-batch context.
- Every changed path and hunk MUST appear in a coverage ledger with its assigned batch or a specific non-reviewable/uncovered reason.

If the diff contains no textual or reviewable changes but contains binary or submodule changes, the report MUST still record those paths and the capability gap; it MUST NOT claim a code review covered them.

## 5. Discover the reviewer roster dynamically

The orchestrator MUST resolve the roster at runtime. It MUST NOT maintain a static reviewer-name list.

- The orchestrator MUST first query the runtime's current list of delegatable agents. It MUST select agents whose logical name matches `code-review.<specialty>` and whose mode is subagent/delegatable.
- If the runtime does not expose a roster, the orchestrator MUST inspect only its configured agent-definition directories. It MUST match filenames `code-review.<specialty>.agent.md` and MUST require matching agent frontmatter/name where available. It MUST NOT treat arbitrary files in the reviewed source tree as available agents.
- The `<specialty>` portion MUST be non-empty. The dedicated `review-orchestrator` primary and any other primary agent MUST NOT be treated as reviewers.
- The orchestrator MUST read each candidate's current description and remit before selecting it. A candidate is applicable unless its stated language/framework constraint excludes the batch or its explicit remit clearly excludes the change type. Uncertainty about applicability MUST favour dispatch, not omission.
- The reviewer set MAY differ between batches. For every exclusion, the orchestrator MUST record the agent and a concise, evidence-based reason.
- After determining applicability, the orchestrator MUST assign each reviewer to exactly one priority tier using its logical name: constitution reviewers first, then bug reviewers, then other reviewers. A name matching both `constitution` and `bug` MUST be assigned only to the constitution tier. Name matching MUST be case-insensitive and MUST use the logical name, not the description or remit.
- Tier assignment MUST NOT change reviewer applicability or cause the orchestrator to add, install, or assume the availability of any agent.
- If no applicable reviewer is available for a reviewable batch, the orchestrator MUST report that batch as uncovered and MUST mark the review incomplete.

## 6. Delegate every applicable review

The orchestrator MUST create one independent delegation for every `(review batch, applicable reviewer)` pair. Each delegation MUST include:

- The Base, merge-base, `HEAD`, and exact PR-style comparison boundary.
- The review scope, exclusions, and prohibition on changes or pull-request actions.
- The batch identifier, language, changed paths, complete hunk patches, line ranges, and changed-line total.
- Relevant surrounding code, callers, consumers, and available test/configuration context, or an exact statement that a context item is unavailable.
- The reviewer's remit and a request to assess the batch within that remit.
- A request for exact locations, evidence, impact/failure condition, severity or classification when the reviewer contract defines one, bounded recommendations, and explicit `None`/unavailable results.
- A request that the reviewer load every skill applicable to its own remit before analysis.

Subagents do not share the orchestrator's conversation. Every delegation MUST be self-contained. Reviewers MUST be instructed not to modify source, tests, Git state, or pull requests.

The orchestrator MUST process reviewer assignments in three sequential phases across all batches: constitution reviewers, then bug reviewers, then other reviewers. Within each phase, it MUST dispatch as many queued assignments as available capacity permits, up to 10 active reviewer subagents globally. As slots become available, it MUST dispatch the next assignment from the current phase. It MUST NOT dispatch a lower-priority phase while any assignment in a higher-priority phase is pending, active, or undergoing its permitted retry. An assignment reaches a terminal state when it returns a usable result or when a failure or unusable result remains after any retry. The orchestrator MUST proceed to the next non-empty phase only after every assignment in the current phase reaches a terminal state; terminal failures MUST be recorded and MUST NOT prevent later phases from running. It MUST wait for every dispatched task to finish before writing the final report.

The orchestrator MAY retry a failed or unusable delegation once, using a complete replacement prompt. It MUST NOT retry a task more than once. If the retry fails or the reviewer returns no usable result, record the exact missing result and mark coverage incomplete.

## 7. Consolidate reports

The final report MUST contain both a consolidated review and each reviewer's full response.

- The orchestrator MUST merge findings only when they identify the same underlying issue and MUST preserve each contributing reviewer and its evidence.
- The orchestrator MUST keep distinct issues separate, including issues in the same file.
- The orchestrator MUST preserve reviewer-provided severity, classification, and terminology. It MUST NOT invent or silently normalise an unsupported severity.
- If reviewers disagree, the orchestrator MUST record each position and its evidence as an unresolved conflict. It MUST NOT adjudicate facts or severity without an explicitly available adjudicator; it MUST NOT add an extra reviewer outside the naming rule.
- The orchestrator MUST order consolidated findings by available severity and then by location. It MUST preserve original severity if reviewers disagree.
- The orchestrator MUST keep missing input, failed reviewers, non-reviewable files, and uncovered changes visible as `Unavailable input` or `Not reviewed`. It MUST NOT infer approval from silence or partial output.
- The orchestrator MUST include each reviewer response verbatim in a clearly attributed appendix, including responses that report no findings.

## 8. Write the report and finish

The orchestrator MUST create `.temp/` if needed and MUST NOT modify `.gitignore`. It MUST use a unique path of the form `.temp/code-review-<branch-slug>-<UTC-timestamp>.md`; it MUST replace characters outside letters, digits, `.`, `_`, and `-` in the branch slug with `-`. If the path already exists, it MUST append an incrementing numeric suffix. It MUST NOT overwrite an earlier report.

The Markdown report MUST include these sections:

1. `Review status` — `Complete`, `Incomplete`, `Not performed`, or `No changes to review`.
2. `Review source` — repository, Base ref and commit, merge-base, `HEAD` commit, branch identity, and committed-only boundary.
3. `Batch coverage` — each batch, language, paths, hunks/line ranges, changed-line totals, and uncovered or non-reviewable changes.
4. `Reviewer coverage` — each applicable reviewer per batch, its priority tier and phase dispatch/retry/result state, and each excluded candidate with its reason.
5. `Consolidated findings` — deduplicated findings with reviewer attribution, location, evidence, impact, severity/classification as supplied, and bounded recommendation. The orchestrator MUST write `None` when no finding was reported.
6. `Conflicts and uncertainty` — disagreements, unavailable evidence, and unresolved questions, or `None`.
7. `Follow-up work` — important non-blocking work, or `None`.
8. `Raw reviewer feedback` — all full reviewer responses, each labelled by batch and reviewer.
9. `Unavailable input` — exact blockers or `None`.

`Complete` means every changed unit was reviewable and assigned, every applicable reviewer returned a usable result, and no changed path remains unreviewable. `Incomplete` means any changed path is unreviewable, any reviewable unit is uncovered, or any required reviewer result is missing. `Not performed` means a pre-review blocker stopped the run. The status MUST NOT imply that the branch is safe, approved, or free of defects.

After a complete report is written and all required reviewer results are present, the orchestrator MUST remove the temporary bundle. If the report is incomplete or report writing fails, it MUST retain any bundle and record its path. A blocker report MUST state that no review was performed and MUST include no fabricated findings.

# Output Contract

The final user-facing response MUST identify the report path and state whether the review is complete, incomplete, blocked, or empty. It MUST NOT substitute a summary for the Markdown report or claim code changes were made.

# Failure Behaviour

- If the repository is not a Git working tree, `HEAD` is absent, the working tree is dirty, the Base is invalid or ambiguous, no merge base exists, the helper fails, or a report cannot be written, the orchestrator MUST stop the affected workflow and report the exact failure.
- A pre-review failure MUST dispatch no reviewers and MUST produce a blocker report when the repository and `.temp/` are available.
- A delegation failure MUST be retried at most once. A second failure MUST remain visible as incomplete coverage.
- A missing reviewer roster, unavailable reviewer definition, unreviewable binary/submodule, or batch with no applicable reviewer MUST be reported as a capability gap; the review MUST NOT be marked complete.
- The orchestrator MUST NOT claim that a pull-request review was posted, a branch was changed, or a fix was implemented.
