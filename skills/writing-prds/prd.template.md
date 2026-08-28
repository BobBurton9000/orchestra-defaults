# PRD: [Title]

<!--
Metadata block. Keep at the top of every PRD.
- Status: Proposed | Accepted | Implemented | Superseded
- Date: the date the PRD is first drafted (YYYY-MM-DD)
- Supersedes (optional): reference any prior PRD, ADR, or doc this replaces
- Related ADRs (optional): list any ADRs that this PRD depends on or informs
-->

- **Status:** Proposed
- **Date:** YYYY-MM-DD
- **Supersedes:** (none)
- **Related ADRs:** (none)

---

## Guidance for authors

This template is the single source of truth for PRD structure. Every PRD saved in the project's requirements directory must follow it. The installed `writing-prds` skill explains *how* to fill each section; this template defines *what* sections exist and in what order. Do not reorder, rename, or omit sections. If a section genuinely does not apply, write "Not applicable" with a one-line reason rather than deleting the heading — the consistent shape is what makes PRDs scannable across features.

Each section below is narrated with: what it is for, what belongs there, what does **not** belong there, a weak example to avoid, a strong example to follow, and common mistakes. Strip the per-section guidance comments before saving a real PRD — they are scaffolding, not part of the document.

The examples use a running scenario — a feature with independently configurable options — purely to illustrate the shape. Replace the placeholders with your feature's domain terms.

---

## 1. Problem

**Purpose:** Explain the user-facing or business pain that this feature addresses, in terms a non-engineer could follow. This is the "why now, why us, why this" framing that justifies the whole document.

**What belongs here:** The concrete situation users face today, the friction or gap they hit, and the cost of doing nothing. Reference real workflows rather than abstract capabilities. If the problem is a reversal of a prior decision, name the prior decision and what changed in practice.

**What does not belong here:** Implementation rationale ("we need a new boolean column"), solution sketches, or acceptance criteria. Save those for §5 and §10. Avoid restating the product vision — assume the reader has read the project's product context.

**Weak:**

> The system lacks explicit controls for an important part of the user experience, which is a limitation.

**Strong:**

> Today a feature's options are inferred from unrelated data or actions. There is no user-facing control to set them independently, so users can encounter behaviour they did not choose or expect.

**Common mistakes:**

- Writing the solution here instead of the problem ("we will add three toggles…").
- Describing an internal architecture gap rather than a user-experienced pain.
- Omitting the cost of inaction, which is what makes the problem worth solving now.

## 2. Goals

**Purpose:** State the outcomes this feature must achieve to be considered successful. Goals are the contract between the PRD and the implementation.

**What belongs here:** Short, verifiable outcome statements written as "the system should …" or "users can …". Each goal should be something a tester or user could confirm by performing an action, not an internal quality attribute.

**What does not belong here:** Non-goals (those go in §3), implementation tasks, or vague aspirations ("improve UX"). Do not list every nice-to-have — three to six focused goals is healthier than fifteen diffuse ones.

**Weak:**

> Improve the feature configuration experience.

**Strong:**

> Users can choose any supported options when configuring the feature, and only the options they enable are used.

**Common mistakes:**

- Writing goals that are indistinguishable from the problem statement.
- Bundling multiple outcomes into one goal ("add toggles and a wizard and migrate data" — split these).
- Including engineering goals ("reduce query count") that belong in an ADR or implementation plan, not a PRD.

## 3. Non-Goals

**Purpose:** Explicitly name the things this feature will **not** do, to prevent scope creep and to set reviewer expectations.

**What belongs here:** Capabilities, edge cases, integrations, or follow-ups that a reasonable reader might *expect* this feature to include but which are deliberately deferred or rejected. Each non-goal should be specific enough that a reviewer could point to a request and say "that's a non-goal".

**What does not belong here:** Things that are obviously out of scope ("this will not fix the login page"). Trivial exclusions add noise. Also avoid using non-goals to list undiscovered work — only list things someone might plausibly ask for.

**Weak:**

> Out of scope: everything not listed above.

**Strong:**

> - Batch option editing across multiple feature records on a single page.
> - Per-option permissioning for different user groups.
> - Retirement of a legacy compatibility path that is no longer needed after the feature ships.

**Common mistakes:**

- Leaving this section empty — an empty non-goals list invites scope creep during review.
- Listing non-goals that no one would ever ask for, which reads as padding.

## 4. Users & Use Cases

**Purpose:** Identify who benefits and the concrete situations in which they benefit. This keeps the requirements grounded in real usage rather than abstract capability.

**What belongs here:** The primary actor(s) and one or two sentence use cases that describe the situation, the actor's intent, and the desired outcome. If different user types experience the feature differently, list each separately.

**What does not belong here:** Full user stories with acceptance criteria (those go in §10), or detailed screen-by-screen flows (those go in §6). Keep this at the "who and when" level.

**Weak:**

> Users can manage the feature better.

**Strong:**

> **User who wants every option:** wants to enable all supported options together so the configuration reflects their full needs.
> **User who wants one option:** wants to enable one option without changing the other options or removing related data.

**Common mistakes:**

- Describing only the happy path actor and ignoring edge-case users (e.g. users migrating existing data).
- Writing use cases that are really implementation tasks in disguise.

## 5. Requirements

**Purpose:** The detailed behavioural specification — the rules the system must enforce and the capabilities it must provide. This is the part an engineer reads to know what to build.

**What belongs here:** Split into two subsections. **Functional requirements** describe what the system does (capabilities, inputs, outputs, state changes). **Rules & edge cases** describe the constraints, invariants, and boundary behaviour that distinguish correct from incorrect implementations. Rules are where most ambiguity is resolved — be explicit about what happens when data conflicts with an option, when an option is turned off, when a required field is missing, etc.

**What does not belong here:** Implementation choices ("use a boolean column") — those belong in §7. UI layout details belong in §6. Test scenarios belong in §10.

**Weak (functional):**

> The system supports independently configurable options.

**Strong (functional):**

> - The system persists the selected options independently for each feature record.
> - The settings page presents the supported options independently; any combination, including none, is valid.

**Weak (rules):**

> Options and their related data should stay consistent.

**Strong (rules):**

> - Turning an option off does **not** delete its underlying data. The data is retained and the option only controls whether the related behaviour is active.
> - Enabling an option that has a prerequisite is rejected when that prerequisite is absent.

**Common mistakes:**

- Mixing rules into the functional list, making it hard to scan.
- Leaving edge cases implicit ("obviously it should keep the data") — what is obvious to the author is rarely obvious to the implementer.
- Writing requirements that cannot be tested because they describe internal state rather than observable behaviour.

## 6. User Experience

**Purpose:** Describe how a user moves through the feature — the screens, flows, and affordances they encounter, in enough detail that a designer or engineer could build it without further questions.

**What belongs here:** Key user flows as ordered step lists ("User clicks X, sees Y, then Z"). A short text wireframe or control inventory for each significant screen. Call out where this feature touches existing screens and what changes on them. Reference the project's UI/UX guidance where it applies.

**What does not belong here:** Visual design specifications (colour, spacing, typography) — those live in the project's style guide. Do not duplicate the style guide; link to it. Full Gherkin scenarios belong in §10.

**Weak:**

> A form guides the user through feature setup.

**Strong:**

> **Settings page (replaces the current single-purpose form):**
> 1. Step 1 — Options: independent controls for each supported option. No option selected is valid when the feature allows it.
> 2. Step 2 — Details: required and optional details relevant to the feature.
> 3. Step 3 — Conditional sections: show only the details required by the selected options.
>
> **Feature detail page:** controls for the supported options persist independently. Related sections render only when their option is enabled.

**Common mistakes:**

- Describing only the new screen and ignoring changes to existing screens the feature touches.
- Specifying layout down to pixel widths — that belongs in a mockup or the style guide, not the PRD.

## 7. Data Model & API Changes

**Purpose:** Specify the persisted and transmitted shape changes this feature requires, at the level of entities, fields, and endpoints. This is where the PRD meets the domain model.

**What belongs here:** New or modified entities and their fields (with types and defaults), new or modified API endpoints (method, path, request shape, response shape), and any DTO or validation changes. Reference the existing domain model and call out exactly what changes there. If a schema migration is required, describe it here at the intent level — the actual SQL lives in a migration file.

**What does not belong here:** Full implementation code, repository method signatures, or internal class structure — those belong in an implementation plan. The PRD defines the contract; the implementation plan defines the code.

**Weak:**

> Add fields to the feature record for the supported options.

**Strong:**

> Introduce explicit stored fields on the feature record for each independently configurable option. These fields are the single source of truth for option state; derived rules based on unrelated data are removed from the read path.
>
> The feature DTO gains fields for option state and create/update validation. The server rejects any update that enables an option without its required prerequisite.

**Common mistakes:**

- Duplicating the domain model instead of diffing against it.
- Describing repository internals (class names, method signatures) that belong in an implementation plan.
- Omitting the validation rules, which are part of the data contract.

## 8. Migration & Rollout

**Purpose:** Explain how existing data and users transition to the new behaviour without regression. This is the section that makes a feature shippable rather than just buildable.

**What belongs here:** The migration strategy for existing records (seed from derived state, default-off, etc.), any one-time data patches, rollout ordering (schema first, then code, then UI), and backward-compatibility notes. Reference the `immutable-migration-patches` skill's forward-only principle where it applies. If the feature reverts a prior ADR, name the ADR and state that a superseding ADR will be drafted.

**What does not belong here:** The actual SQL of the migration file, or rollout runbooks. Those belong in the project's established migration and operations locations.

**Weak:**

> Existing preferences will be migrated.

**Strong:**

> 1. Schema: add explicit fields for the independently configurable options.
> 2. Seed from current derived state using a one-time data patch, so existing users retain their current behaviour after rollout — now as explicit stored state, with no user-visible regression.
> 3. Do not destructively change or remove the underlying data.
>
> A new ADR will document any reversal of a prior architectural decision and its rationale.

**Common mistakes:**

- Assuming a fresh database. Existing records always need a stated transition.
- Forgetting to call out that a prior decision is being reversed, which leaves reviewers confused about why the PRD contradicts an accepted ADR.

## 9. Open Questions

**Purpose:** Record the decisions still to be made, so reviewers can answer them and so the PRD does not silently guess. A PRD with no open questions is either finished or under-scrutinised.

**What belongs here:** Specific, answerable questions that block a section of the PRD. Each question should be scoped (which section it affects) and offer the options being considered if the answer is not free-form. Number them so reviewers can reference them in review ("answering Q2: …").

**What does not belong here:** Questions that have already been resolved (move the answer into the relevant section and remove the question), or rhetorical questions that are really just notes.

**Weak:**

> Should we have a settings page?

**Strong:**

> Q1. Should the settings page replace the current form, or be offered as an alternative path alongside it? (Affects §6.) Recommendation: replace.

**Common mistakes:**

- Leaving resolved questions in this section, creating ambiguity about what the PRD actually proposes.
- Asking questions that are really implementation details no one can answer at the PRD stage.

## 10. Acceptance Criteria

**Purpose:** The observable, testable conditions under which the feature is considered done. This is the contract between the PRD and the test suite.

**What belongs here:** Gherkin scenarios written per the `writing-gherkin` skill: one behaviour per scenario, concrete `Given`/`When`/`Then` steps, observable outcomes. Cover the happy path and the important edge cases named in §5. If a scenario is too large, it is probably two scenarios.

**What does not belong here:** Implementation assertions ("the option field is set"), internal state checks, or prose acceptance criteria. Gherkin is the format; if prose is genuinely needed, keep it out of this section and in §5.

**Weak:**

> The feature works correctly.

**Strong:**

```gherkin
Scenario: Turning an option off retains its underlying data
  Given a user with an option enabled
  And the related data is present
  When the user turns the option off
  Then the related section is hidden on the feature page
  And the related data is retained
  And turning the option on again restores the section with the data listed
```

**Common mistakes:**

- Writing scenarios that bundle multiple behaviours ("configure the feature, edit it, toggle an option, and check the list").
- `Given` steps that describe intent rather than setup ("Given the user wants to enable an option").
- `Then` steps that assert internal state rather than observable output.

## 11. Out-of-Scope Follow-ups

**Purpose:** Capture the work this feature intentionally *does not* do but which it makes more likely, more obvious, or more necessary. This is the forward-looking sibling of §3 Non-Goals.

**What belongs here:** Specific follow-up tasks or features that a reviewer or implementer might identify once this feature ships. Each item should be concrete enough to become its own ticket, PRD, or ADR. Flag whether each is a candidate for a future PRD or a future ADR.

**What does not belong here:** Vague aspirations, or work that is simply "the rest of the feature". If a follow-up is genuinely just unfinished scope, it belongs in §3, not here.

**Weak:**

> More feature configuration options in future.

**Strong:**

> - Bulk option editing across multiple feature records (candidate for a future PRD).
> - Per-option permissioning (candidate for a future PRD).
> - Retirement of the legacy compatibility path, which becomes dead code once the settings page ships (candidate for a cleanup task).

**Common mistakes:**

- Listing items that are really still in scope but unfinished.
- Omitting this section entirely, causing follow-ups to be lost during review.
