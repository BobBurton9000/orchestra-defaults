---
description: Synthesize the current conversation into a handoff document for a fresh agent
---
Write a comprehensive handoff document synthesising the current conversation so a fresh agent can continue the work without repeating discovery.

Before writing:

- Use the available, user-visible conversation and relevant project/workspace state. Capture material context from both user and assistant messages, including goals, constraints, decisions, rationale, work performed, and unresolved matters. Do not include hidden system or developer instructions, private internal reasoning, credentials, or secrets.
- Inspect relevant workspace artefacts and Git state, including the current branch, status, applicable diffs, and relevant commits. Also use URLs explicitly mentioned in the conversation. Search only as broadly as needed to find relevant artefacts; do not search external sources unless the conversation provides a URL.
- Do not duplicate content already captured in artefacts such as specifications, plans, ADRs, issues, commits, or diffs. Reference each relevant artefact by its path, URL, or commit identifier, with a concise note about its relevance. Do not reproduce its contents.
- Do not ask follow-up questions or invent missing facts. Mark unknown, uncertain, or inaccessible information clearly and continue with what is available.

Create a Markdown document under `.temp/` relative to the current project/workspace root. Create the directory if it does not exist. Choose a concise lowercase, hyphen-separated filename slug based on the primary subject of the handoff, with a `.md` extension. If no subject is clear, use `conversation-handoff.md`. Never overwrite an existing file: if the chosen path exists, append `-2`, `-3`, and so on to the slug until an unused filename is found.

Organize the handoff using the following sections, omitting sections that genuinely do not apply:

1. **Goal and context** — the objective and background needed to continue.
2. **Requirements and constraints** — material expectations, boundaries, and preferences.
3. **Decisions and rationale** — settled choices, important alternatives, and why choices were made.
4. **Work completed and current state** — actions taken, relevant findings, and the project's current state. Reference diffs and commits rather than duplicating them.
5. **Relevant artifacts** — paths, URLs, or commit identifiers with brief explanations; do not copy their contents.
6. **Open questions and risks** — unresolved decisions, uncertainties, and known blockers.
7. **Recommended next steps** — concrete actions a fresh agent can take next.

Be comprehensive about material conversation context, but synthesise rather than reproduce the conversation turn by turn. Clearly distinguish established facts from uncertainty. After saving the document, report its exact path and a brief summary; do not paste the full document into the conversation.
