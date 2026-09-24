---
name: how-to-delegate-to-subagents
description: Use when launching a subagent so its delegation prompt contains the context it needs.
---

# How to Delegate to Subagents

## Quick Reference

| Remember | Do |
| --- | --- |
| No shared parent context | Include all task details in the delegation prompt. |
| No implicit references | Replace "as discussed", "above", and "previous result" with the actual content. |
| Missing context | Ask for it or provide a complete follow-up prompt; do not guess. |

## The Rule

A subagent cannot see the parent agent's conversation, earlier tool results, or sibling-agent messages. The delegation prompt is the only context the parent agent supplies for the delegated task.

The subagent still has its own instructions, skills, tools, and permitted repository access. Do not assume that any parent context is available through them.

Include the objective, relevant context or evidence, exact paths, constraints, boundaries, and expected output in every delegation prompt. If another subagent's findings matter, copy the findings into the next prompt instead of referring to the earlier delegation.

## Examples

### Valid example

> Investigate the failing input-validation test in `tests/input-validation.test.ts`. The expected behaviour is that invalid input is rejected and the input value is left unchanged. Read `src/input-validation.ts` and the relevant tests. Report the cause, the files involved, and a focused fix proposal. Do not edit files.

This prompt is self-contained and gives the subagent enough information to begin.

### Invalid example

> Please fix the issue we discussed and use the previous agent's findings.

This prompt depends on the parent conversation and another agent's message, neither of which the subagent can see.
