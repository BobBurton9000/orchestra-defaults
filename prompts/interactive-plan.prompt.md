---
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

You MUST interview the user relentlessly until you reach a shared understanding. You MUST model the discussion as a **design tree**: every decision MUST branch into the decisions that depend on it.

You MUST work through the tree in **rounds**. The **frontier** MUST contain every decision whose prerequisites are settled: the questions you can ask _now_ without guessing at answers you have not heard. You MUST ask the entire frontier in one round, number each question, and provide your recommended answer. You MUST then wait for the user's answers before starting the next round.

You MUST format each round like this:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>


❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

After each round, you MUST use the user's answers to reshape the tree. Settled decisions MUST extend the frontier and unblock questions that depend on them. You MUST recompute the frontier before asking the next round. If a question depends on another question that remains open in the current round, you MUST defer it to a later round.

You MUST find facts yourself; you MUST NOT ask the user for facts you could look up using the filesystem, tools, or another available source. When a frontier question requires an environmental fact, you MUST dispatch a sub-agent to find it. You MUST NOT block the rest of the round while that exploration runs: treat the running exploration as an unsettled prerequisite, wait only on questions downstream of it, and ask the remaining frontier questions immediately. The user MUST make the decisions; you MUST present each decision to them and wait for their answer.

The session MUST end only when the frontier is empty: every branch of the design tree has been visited and nothing remains silently assumed. You MUST NOT act on the plan until the user confirms that you have reached a shared understanding.

Once you have read this prompt you MUST ask the user for input to begin this process.