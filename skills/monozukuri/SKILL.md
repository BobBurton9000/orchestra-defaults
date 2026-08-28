---
name: monozukuri
description: Applies Monozukuri, Kaizen, and Jidoka to engineering work without weakening governing project rules.
---

# Monozukuri Engineering

## Purpose and Scope

This skill is a binding instruction for a practitioner who investigates, plans,
implements, reviews, or verifies engineering work in a repository.

It covers evidence-led development, quality at source, bounded change,
continuous improvement, failure handling, and honest verification.

It does not define product behaviour, replace a repository constitution, or
create an exception to an applicable contract or policy.

Monozukuri is applied as an engineering practice. It does not require cultural
imitation, unnecessary Japanese terminology, or perfection without bounded
value.

## Instruction Summary

1. The practitioner MUST begin from repository evidence and applicable authoritative
   documents.
2. The practitioner MUST identify the intended outcome, owning boundary, contract, and
   completion condition.
3. The practitioner MUST implement the smallest complete change that satisfies the
   applicable contract.
4. The practitioner MUST build quality into the boundary that owns the relevant rule or
   state.
5. The practitioner MUST stop normal processing when an unexpected condition or
   invariant violation is detected.
6. The practitioner MUST keep Kaizen improvements bounded, related, and verifiable.
7. The practitioner MUST report verification results, assumptions, and unfinished work
   without fabrication.

## Definitions

- **Monozukuri** means creating useful, durable, understandable work through
  direct evidence, quality at source, bounded change, and continuous
  improvement.
- **Kaizen** means a bounded, evidence-led improvement to an existing system or
  process.
- **Jidoka** means detecting an abnormal condition at its source, stopping
  normal propagation, and exposing the failure.
- **Quality at source** means validating behaviour at the boundary that owns
  the relevant rule or state.
- **Evidence** means observable information from source, documentation, tests,
  tooling, runtime behaviour, or explicit requirements.
- **Bounded improvement** means an improvement with an identified boundary,
  reason, completion condition, and verification method.
- **Complete change** means a change that includes all implementation and
  verification work required by its applicable contract.
- **Practitioner** means the person or system performing repository work under
  this skill.
- **Unexpected condition** means a condition that violates an applicable
  contract or invariant and has no defined safe outcome.
- **Expected condition** means a condition for which an applicable contract or
  domain rule defines an intentional outcome, including rejection or recovery.

## Authority and Precedence

The practitioner MUST identify the authorities that govern the requested work before
changing the system.

When authorities conflict, the practitioner MUST apply them in this order:

1. System and developer instructions.
2. Explicit task requirements that do not conflict with a higher authority.
3. Repository constitutions and mandatory architectural policies.
4. Applicable product, domain, testing, and technical requirements.
5. This skill.
6. Existing implementation and tests as evidence of current behaviour.

This skill explains how to apply higher authorities. It MUST NOT weaken,
reinterpret, or replace them.

## Inputs

The practitioner MUST use the following inputs when they are applicable:

- **Task request:** The requested outcome and stated constraints.
- **Authoritative documents:** Constitutions, requirements, policies, and
  applicable skills.
- **Repository evidence:** Source, tests, documentation, configuration,
  dependencies, runtime observations, and the current working tree.
- **Acceptance conditions:** Observable conditions that establish completion.
- **Existing changes:** The current diff and uncommitted work not created by
  the practitioner.

The practitioner MUST distinguish missing input from unknown input.

When a missing requirement could change ownership, public behaviour, data
shape, failure handling, or scope, the practitioner MUST ask a focused clarification
question before implementation.

When a missing requirement cannot change those boundaries, the practitioner MAY proceed
with a bounded assumption. The practitioner MUST state that assumption in its output.

The practitioner MUST NOT invent an API, contract, domain rule, asset, test result, or
current behaviour to fill an information gap.

The practitioner MUST preserve existing worktree changes that it did not create. It MUST
NOT revert, overwrite, or stage unrelated changes.

## Normative Rules

### Value and Ownership

1. The practitioner MUST identify the intended outcome or stakeholder value that the
   work enables or protects.
2. The practitioner MUST identify the owning boundary and applicable contract or
   invariant affected by the work.
3. The practitioner MUST keep authoritative rules and state inside their owning
   boundary.
4. The practitioner MUST NOT create a second source of truth to make a change
   convenient.
5. The practitioner MUST NOT move ownership into a composition point, adapter, test
   fixture, or generic shared area merely to simplify implementation.

### Bounded Change

1. The practitioner MUST implement the smallest complete change that satisfies the
   applicable contract.
2. The practitioner MUST NOT add speculative abstractions, compatibility paths,
   dependencies, or unrelated refactors.
3. The practitioner MAY improve directly related clarity when the improvement preserves
   the existing contract, remains within the identified boundary, and has
   verification evidence.
4. The practitioner MUST record unrelated improvements as follow-up work instead of
   including them in the current change.
5. The practitioner MUST NOT widen product scope from an inferred future need.

### Kaizen

1. After completing a change, the practitioner MUST inspect whether the work exposed a
   recurring defect, unclear boundary, repeated workaround, or avoidable
   workflow friction.
2. The practitioner MAY implement a Kaizen improvement when the improvement is directly
   related to the changed boundary, has a bounded completion condition, and can
   be verified within the available scope.
3. The practitioner MUST record a Kaizen improvement as follow-up work when it is not
   directly related, cannot be bounded, or cannot be verified.
4. The practitioner MUST NOT use Kaizen as a reason to refactor unrelated areas,
   redesign a contract without a requirement, or bypass review.
5. The final output MUST state whether a relevant improvement was made,
   deferred, or not identified.

### Jidoka

1. The practitioner MUST validate behaviour at the earliest boundary that can establish
   its correctness.
2. When an Unexpected condition or invariant violation is detected, the practitioner
   MUST stop normal processing and expose the failure.
3. The practitioner MUST NOT hide an Unexpected condition with a fabricated value,
   partial result, arbitrary default, fallback state, or log-and-continue path.
4. The practitioner MUST NOT continue dependent implementation work as though an
   Unexpected condition had not occurred.
5. The practitioner MUST distinguish an Expected condition from an Unexpected
   condition.
6. The practitioner MUST preserve the evidence needed to diagnose an exposed failure.
7. Tests and tooling MAY provide evidence of a failure, but they MUST NOT be
   used to legitimise a constitutional violation.

### Verification

1. The practitioner MUST verify behaviour at the public boundary that owns the changed
   behaviour.
2. The practitioner MUST use the verification method required by the applicable
   contract, testing policy, or technical boundary.
3. The practitioner MUST report a verification command or observation for every claimed
   verification result.
4. The practitioner MUST report unavailable verification as unavailable.
5. The practitioner MUST NOT claim that an unrun check passed.

## Process

The practitioner MUST follow this sequence when performing repository work:

1. **Observe:** Read the relevant authorities, source, tests, documentation,
   and current diff.
2. **Establish authority:** Identify which documents define behaviour,
   ownership, boundaries, and failure outcomes.
3. **Define the change:** State the value, owning boundary, contract,
   acceptance conditions, and explicit exclusions.
4. **Choose the smallest complete change:** Include the implementation,
   boundary changes, and verification required for a usable result.
5. **Build quality at source:** Validate at the owning boundary and preserve
   the existing ownership and dependency direction.
6. **Apply Jidoka:** Stop and expose Unexpected conditions instead of hiding
   them.
7. **Apply Kaizen:** Inspect for a bounded, evidence-led improvement and either
   implement it within scope or record it as follow-up work.
8. **Verify and report:** Run the applicable checks, inspect the final diff,
   and report changes, evidence, assumptions, and remaining work.

## Failure and Ambiguity Behaviour

When the task conflicts with an applicable constitution or mandatory policy, the
practitioner MUST stop and report the conflict.

When ownership or public behaviour is ambiguous, the practitioner MUST ask for
clarification before changing the affected boundary.

When an API, contract, or domain rule is missing, the practitioner MUST NOT invent one.
The practitioner MUST report the missing seam or ask for the required decision.

When an Expected condition has an identifiable contract-defined outcome, the practitioner
MAY implement that outcome.

When an Unexpected condition is detected, the practitioner MUST fail fast and MUST NOT
continue normal processing.

When verification cannot run because of a missing tool, environment, or test
seam, the practitioner MUST report the limitation and MUST NOT fabricate evidence.

When an adjacent improvement is outside the approved scope, the practitioner MUST leave
the current change bounded and report the improvement as follow-up work.

## Output Contract

When implementation or review work is completed, the practitioner MUST report:

```markdown
## Outcome

[The user-visible or system-visible result.]

## Changes

- [Changed file or bounded change.]
- [Changed file or bounded change.]

## Verification

- `[command]`: [result].
- [Runtime, browser, or repository observation]: [result].

## Assumptions and Uncertainty

- [Assumption or `None`.]
- [Unverified condition or `None`.]

## Follow-up

- [Bounded follow-up work or `None`.]
```

The practitioner MUST omit claims that cannot be supported by evidence.

When no files are changed, the practitioner MUST state that no files were changed and
MUST provide the reason.

When implementation is blocked, the practitioner MUST state the blocking condition, the
last verified state, and the decision required to continue.

## Valid Example

A domain service validates a request at its owning boundary, applies the
authoritative rule, publishes the result through its contract, and an adapter
represents that result. The change is verified at the service and adapter
boundaries.

This is valid because ownership, communication direction, quality at source,
and verification boundaries remain explicit.

## Invalid Example

An adapter mutates a domain flag because the adapter already receives the user
interaction, while the domain later reads that flag.

This is invalid because the adapter has created or mutated authoritative state
and bypassed the domain boundary.

## Valid Kaizen Example

A change to a public read boundary exposes a repeated mutable conversion. The
conversion is corrected within that boundary, the public contract checks are
updated, and the final report names the improvement and its verification.

## Invalid Kaizen Example

A small user-interface change triggers a repository-wide replacement of all
domain contracts without a requirement or bounded completion condition.

This is invalid because the improvement is unbounded, unrelated to the changed
boundary, and unsupported by direct evidence.

## Valid Jidoka Example

An internal exhaustive value receives an unrecognised member. The implementation
exposes the failure instead of selecting arbitrary behaviour.

This is valid because the condition violates an invariant and normal processing
cannot safely continue.

## Invalid Jidoka Example

A user submits an invalid request that the contract explicitly rejects. The
implementation raises an unexpected internal failure instead of returning the
defined rejection outcome.

This is invalid because an Expected condition has been misclassified as an
Unexpected condition.

## Validation Checklist

The practitioner MUST confirm all applicable items before reporting completion:

- [ ] The intended outcome and completion condition are explicit.
- [ ] The owning boundary is explicit.
- [ ] The applicable contract or invariant is identified.
- [ ] Repository evidence was inspected.
- [ ] No API, rule, or result was invented.
- [ ] The change is bounded and complete.
- [ ] No duplicate authoritative state or bypass was introduced.
- [ ] Kaizen was considered without expanding scope.
- [ ] Jidoka behaviour is correct for Unexpected conditions.
- [ ] Expected rejections remain Expected outcomes.
- [ ] Verification was performed at the owning public boundary.
- [ ] Unavailable checks and uncertainty are reported honestly.
- [ ] The final diff contains only intended changes.
