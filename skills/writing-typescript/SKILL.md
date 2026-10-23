---
name: writing-typescript
description: The TypeScript Constitution for this project. Use when writing, modifying, or reviewing TypeScript code.
---
# TypeScript Constitution

## Preamble

This Constitution establishes the TypeScript standards. It exists to make code understandable at the point of use, keep application contracts strict, and make invalid states visible rather than hidden. It organises code around vertical capabilities with explicit behavioural contracts and private implementation spaces so changes can be understood and contained within a capability by human developers and coding agents.

The rules apply when writing, modifying, or reviewing project-authored TypeScript code. Third-party declarations and generated declarations not maintained by the project are outside scope; project-authored boundary adapters that consume them MUST translate their types before those types enter application Contracts. The examples are illustrative. The normative statements are authoritative.

## Article 1: Constitutional Language

### Section 1.1: Normative terms

- **MUST** and **MUST NOT** are binding requirements.
- **SHOULD** and **SHOULD NOT** are the default position and may be departed from only for a stated technical reason.
- **MAY** identifies a permitted choice.

### Section 1.2: Constitutional interpretation

These rules MUST be applied according to their stated intent, not bypassed by changing a name while retaining the same unclear design. Convenience alone is not a sufficient reason to depart from a MUST or MUST NOT rule.

An explicit normative rule in this Constitution MUST NOT be waived by the Necessity Gate. An element directly required by a normative MUST is justified by that requirement and needs no separate Gate evidence; the Gate applies to additional implementation choices. This Constitution MUST NOT require a conditional, class, interface, DTO, Contract, collaborator, proxy, Null Object, named constant, or test solely to satisfy a convention unless an explicit normative rule in this Constitution requires that element or form. For any implementation choice not expressly required by this Constitution, an added element is an implementation construct beyond the direct statements and bindings needed to implement an applicable behavior or rule, such as an extra branch, helper, abstraction, collaborator, class, interface, DTO, proxy, or test. For a test, supporting a required observable outcome means providing evidence that implementation meets a requirement or guards against a demonstrated regression; the test need not cause application behavior. For conditional behavior, evidence MUST identify a trigger reachable under Section 3.1 or its invariant-violation exception. A likely future trigger evidenced by the current task may justify planning, but MUST NOT justify adding an unreachable branch. For a non-conditional addition, evidence MUST identify current task use. Concrete ambiguity or repetition in code within the current task counts as current task use for a qualifying helper under Section 3.2, but does not justify unrelated helpers or abstractions. In either case, the element MUST support a required observable outcome and have a bounded place in the current task. A required observable outcome includes a code-quality result explicitly required or recommended by a normative SHOULD in this Constitution, such as resolving concrete ambiguity or repetition under Section 3.2 when its stated condition applies, even when runtime behavior is unchanged. Such a result may justify a non-conditional structural addition, but does not by itself justify a branch; every branch MUST satisfy Section 3.1. Reviewers MUST assess this evidence from the current task, applicable Contracts and application rules, and demonstrated production use; no separate comment or artifact is required when the evidence is apparent from those sources. Bounded means limited to the code and lifecycle needed for the current task; an element serving only hypothetical future use is not bounded. This is the Necessity Gate and applies whether or not another skill is loaded.

## Article 2: Names and Module Terms

### Section 2.1: Specific names

Identifiers MUST be specific enough to communicate their value or intent at the point of use. Unnecessary abbreviations MUST NOT be used.

**Invalid example:** `col` is an unnecessary abbreviation and does not identify the value.

```ts
function columnIndexFromRequest(requestedColumnIndex: number): number {
    const col = requestedColumnIndex;
    return col;
}
```

**Good**

```ts
function columnIndexFromRequest(requestedColumnIndex: number): number {
    return requestedColumnIndex;
}
```

### Section 2.2: Boolean names

A question-shaped predicate is a Boolean name that states a yes-or-no proposition in the name itself. It MUST remain understandable without an enclosing condition or other call-site context. A name qualifies when it can be read as a complete yes-or-no question whose answer is the Boolean value; it need not use a fixed prefix, but MUST express the proposition's polarity explicitly.

Boolean variables, parameters, properties, and query methods MUST be named as question-shaped predicates.

Boolean names MUST NOT be bare action verbs or third-person action phrases that require an auxiliary verb to become a yes-or-no question.

**Invalid example:** `auth` is not question-shaped, and the other names describe actions rather than yes-or-no propositions.

```ts
const auth = true;
const movesUp = false;
const zoomsIn = false;
```

**Good**

```ts
const isLoggedIn = true;
const shouldMoveUp = false;
const shouldZoomIn = false;
```

Predicate prefixes such as `is`, `has`, `can`, and `should` are question forms when they accurately describe the proposition. Boolean query functions MUST also be named as question-shaped predicates. The question-shaped naming rule for methods applies to queries; commands, including commands that return Boolean operation results, MUST use imperative names under Section 2.4.

### Section 2.3: Queries

The owning composition or lifecycle boundary for a collaborator is the smallest owner that creates or adopts it and controls its lifetime, including replacement and cleanup when applicable. A collaborator reference escapes that boundary when it is made available to code outside that owner.

A query produces a value or predicate. A query MAY update private instance state solely to memoize its result. It MAY lazily initialise a collaborator within the instance's owning composition or lifecycle boundary only as permitted below and only when needed to produce the returned value. Lazy setup MUST be limited to establishing an owned collaborator's initial state needed to produce the query result; any configuration applied MUST be initialization configuration belonging to the owning lifecycle, not configuration supplied as a new application command. This setup MAY be externally observable only to the minimum extent needed to initialize the owned collaborator and its assigned resources. It MUST NOT alter global state or affect unrelated collaborators or resources, and it is the only external setup permitted during a query. Lazy setup MUST NOT apply request-specific configuration, change domain state, or perform capability operations. Such internal initialisation does not by itself make the query a command. A query MUST NOT mutate authoritative application state, enforce application rules, or allow an owned Concrete collaborator, including a delegate, to escape its owning composition or lifecycle boundary.

Query functions and methods MUST use nouns, noun phrases, question-shaped predicates, or `<value>From<source>` constructions. Query functions and methods MUST NOT use command verbs or the accessor prefix `get`.

Private lazy accessor methods MUST use ordinary method syntax and MUST NOT use JavaScript getter or setter syntax. A private lazy accessor MAY return an owned Concrete collaborator only to code that remains within the collaborator's owning composition or lifecycle boundary.

**Invalid example:** `parseMultipartSection` uses a command verb for a query, and `getCurrentUser` uses the prohibited `get` prefix.

```ts
private parseMultipartSection(section: string): MultipartSection
private getCurrentUser(): User
```

**Good**

```ts
private multipartSectionFromString(section: string): MultipartSection
private currentUser(): User
```

A permitted private lazy accessor method MAY initialise an owned collaborator before returning it. This example is valid only when every caller remains within the collaborator's owning composition or lifecycle boundary; the returned Concrete collaborator MUST NOT be passed to an external consumer.

```ts
private cameraViewport(): CameraViewport {
    if (this.hasAppliedInitialConfiguration) {
        return this.cameraViewportDelegate;
    }
    this.cameraViewportDelegate.configure(this.initialConfiguration);
    this.hasAppliedInitialConfiguration = true;
    return this.cameraViewportDelegate;
}
```

### Section 2.4: Commands

A command changes authoritative application state, performs input/output, triggers an effect, or produces a new value representing a state transition, except for private-state memoisation or lazy initialisation permitted for a query under Section 2.3. This query exception includes the narrowly limited externally observable setup permitted by Section 2.3; that setup does not by itself make the query a command. A query returns information about existing state; an operation that performs an effect or state transition remains a command even when it returns an operation result or new value. A command MUST use an imperative verb that describes its effect.

`set` is a valid command verb, but it is not the only permitted command verb. Commands MAY return `void`, `this`, or an operation result. The return type does not determine whether a function is a query or a command. Commands MUST use imperative names even when they return Boolean results; a Boolean result binding MUST use a question-shaped predicate name under Section 2.2.

Persistent state-transition methods that return a new instance without mutating the receiver are an explicit exception to the imperative-verb naming rule. They MUST use the `with<Property>` naming form, where `<Property>` identifies the changed state property. They MUST declare an explicit return type that accurately describes the new instance. The return type MAY be `this` when the method preserves the receiver's subtype. These methods MUST leave the receiver unchanged and are commands despite the `with` prefix.

**Good**

```ts
private setAttributes(): void {
    const inputDescriptionAttributeName = 'aria-describedby';
    const validationErrorElementId = 'validation-error';
    if (isInvalid) {
        input.setAttribute(inputDescriptionAttributeName, validationErrorElementId);
        return;
    }
    input.removeAttribute(inputDescriptionAttributeName);
}
```

### Section 2.5: Variable scope and mutability

Variables MUST be declared at the narrowest scope that contains every use. A variable used by only one function MUST be declared within that function. A value used across methods MUST be placed at the boundary that owns the value. Class-owned values MUST remain private instance properties. Module-level values MUST have a deliberate module-level purpose and MUST NOT be introduced solely to name a value used by one function.

Local bindings MUST use `const` when the binding is not reassigned and MUST use `let` when the binding is reassigned. A private instance property MUST use `readonly` when it is not reassigned after construction and MAY remain mutable when the owning class changes its value.

### Section 2.6: Contract names

`Contract` is a type classification, not a naming suffix. Contract interfaces are the first-class descriptions of the behaviour they represent. Interface names MUST describe the capability, role, or domain concept they represent. Interface names MUST NOT end in `Contract` solely to identify their classification. The suffix MAY be used when `Contract` is part of the actual domain concept.

**Invalid example:** `Contract` is used only as a classification suffix instead of naming the repository capability.

```ts
interface AccountRepositoryContract {
    snapshots(): ReadonlyArray<AccountSnapshot>;
}
```

**Good**

```ts
interface AccountRepository {
    snapshots(): ReadonlyArray<AccountSnapshot>;
}
```

### Section 2.7: Module terms

A **vertical module** is a code boundary for one cohesive feature or capability. It owns its feature-specific application rules, authoritative state, data handling, and domain-specific adapters.

A module's **public space** is its declared consumer-facing entry point and the Contract interfaces, DTO classes, and other named data types required by public Contract signatures under Sections 4.6 and 5.7 that it exposes.

A module's **private space** is its implementation files and symbols that are not part of its public space.

A **composition entry point** is a module-owned, composition-only entry point that provides a factory for the composition root without exposing implementation details to ordinary consumers.

A **composition-only interface** is a factory return interface available only through the composition entry point. It MAY combine public consumer Contracts with composition-only lifecycle/setup and owner-facing operations; “composition-only” describes its exposure surface, not the purpose of every operation it declares.

A **module factory** is the composition-only function that constructs a module implementation and returns its public consumer Contract interface or interfaces, or the composition-only interface specified in Section 4.7(1).

A **composition root** is the system boundary that constructs modules and connects their Contracts.

A **workflow module** is a vertical module that coordinates a workflow across multiple capability modules through their Contracts.

A **composition-only lifecycle/setup operation** initializes, wires, or releases module-owned resources for composition and is not a capability exposed to ordinary feature consumers. This category excludes owner-facing operations under Section 5.6, including Stable Proxy shutdown, even when they release delegate resources.

An **owner-facing lifecycle operation** is an operation available only to the designated lifecycle owner. Replacement and pending-cleanup retry are Proxy owner-control operations; final shutdown is a separate owner-facing lifecycle operation. None is a consumer-facing capability.

A **shared infrastructure module** provides generic technical behaviour independent of a feature's rules, state, or domain-specific adapters.

A **boundary module** is a vertical module or a shared infrastructure module consumed by another module.

A **designated lifecycle owner** for a Stable Proxy is the single module or composition root assigned through composition to invoke its final shutdown and any replacement or cleanup-retry operations it supports. An **external lifecycle owner** is a designated owner outside the provider module, including the composition root whether or not it is a separate module. The designated lifecycle owner invokes owner-control operations; the lifecycle owner assigned to an individual resource is accountable for its release. These roles MAY be held by different components.

A **system shutdown coordinator** is the composition root when it initiates system shutdown, or the designated lifecycle owner when it initiates shutdown independently. It requests and awaits shutdown but is not automatically the lifecycle owner.

A **resource-owner lifecycle Contract** is the designated resource owner's Contract governing that resource's release.

A **resource-owner cleanup Contract** is a local owner-facing Contract declared by the Stable Proxy's module to type cleanup operations supplied by the resource-owner lifecycle Contract. Composition wiring passes its runtime implementation to that module; the local Contract does not import the resource owner's private implementation or transfer resource ownership.

## Article 3: Function Bodies

### Section 3.1: Necessary control flow

For this Section, a branch is a distinct execution path selected by a source-level decision construct or caught exception, including `if` statements, `switch` cases, conditional expressions, loop conditions, and exception handlers. A short-circuit operator alone is not a branch for this Section; when it conditionally evaluates an effect, the trigger is the operand value that controls evaluation and the outcomes are whether the effect occurs or is skipped. That effect MUST be required under its trigger by an applicable Contract, application rule, or boundary protocol. For example, `isCacheMiss && refreshCache()` is permitted only when the applicable rule requires refreshing on a cache miss and not otherwise. The trigger-and-outcome test applies to the guarded effect; the short-circuit operator does not create a separate branch for this Section. If the expression feeds an `if`, `switch`, loop, or conditional expression, that enclosing decision is assessed separately. Compound conditions used as branch conditions remain subject to Section 3.3. A short-circuit expression that only conditionally evaluates an effect and is not used as a branch, loop, or conditional-expression condition is not subject to Section 3.3's named-predicate requirement. Each distinct outcome path MUST have both an evidenced reachable trigger and a required outcome that differs from at least one alternative outcome path selected by the same decision. A required outcome is either behavior mandated for that trigger or, for a trigger-specific rule, the required omission of that behavior on the alternative path. A trigger is evidenced when it is reachable for an input or state permitted at the function's boundary. A branch required by Section 3.4 to detect and fail on an invariant violation MAY have a trigger outside the valid inputs or states permitted at the boundary; the violated invariant is evidence for that trigger, and the branch MUST fail fast. Intrinsic-value validation permitted in DTO constructors under Sections 5.4 and 6.2 is an invariant check for this rule, even when boundary validation should already have rejected the value. Two paths have different outcomes only when their required observable behavior differs, including returned values, failures, authoritative state changes, external effects, or externally observable ordering. Different statements or internal evaluation order alone do not count unless an applicable Contract, application rule, or boundary protocol requires that distinction. An applicable Contract, application rule, or boundary protocol MUST require behavior on at least one path; a single provision MAY prescribe both outcomes without separate clauses for each. When a rule requires behavior only for a particular trigger, the required alternative outcome may be omission of that behavior; that omission is the distinct required outcome and need not have a separate positive requirement. When both paths perform different behavior, each behavior MUST be required by an applicable rule. For this test, “the same decision” means one source-level decision construct. Syntactic arms of that construct that require the same behavior count as one outcome path; reviewers MUST group them before applying the branch test. They SHOULD be combined where this preserves evaluation order, side effects, and other required semantics. If separate arms are necessary to preserve those semantics, they are assessed together as one outcome path. A decision with only one required outcome MUST NOT introduce a conditional branch. A loop condition is assessed under the branch test only when both continuing and terminating are reachable outcomes required by the loop's purpose. Termination is required when the function's Contract, application rule, boundary protocol, or defined input boundary specifies a completion condition. Exhaustion of a finite collection is such a condition only when the loop's task requires consuming that collection to completion; finiteness alone does not require exhaustion when the task defines an earlier stopping condition. A constant condition with only one reachable outcome is not itself a branch under this Section. An explicit loop-exit guard is assessed as a branch between the required exit action and continuation of the loop body. For an exception handler, propagation of the caught exception is the alternative outcome; the handler MUST provide a distinct recovery, cleanup, or transformation only when required by an applicable Contract, application rule, or boundary protocol. When no such handling is required, code MUST NOT catch the exception solely to rethrow it; the exception MUST propagate naturally, and Section 3.4 prohibits swallowing it or continuing after it. When a handler is required to clean up after a caught failure and cleanup succeeds, it MUST rethrow the original failure unchanged unless an applicable Contract, application rule, or boundary protocol explicitly requires a different error transformation. Any required transformation MUST preserve the original failure as an identifiable cause. If cleanup also fails, it MUST propagate an aggregate containing the original failure and every cleanup failure encountered under the continuation policy required by Section 3.4 or Section 5.6(8), with the original failure identified as primary. Section 3.4 determines whether further cleanup is attempted after an individual failure. Multiple cleanup failures arising without a prior caught failure MUST be aggregated under Section 3.4; Stable Proxy replacement and retry operations also follow the more specific ordering rules in Section 5.6(8). Function bodies MUST NOT use `else` or `else if` clauses in `if` statements. Conditional expressions MAY be used subject to Section 3.3 and all other applicable rules. When a required outcome of an `if` statement is to exit the function, it MUST be expressed as a guard clause and early exit, such as `return` or `throw`, so the non-exiting path falls through. When both outcomes must continue, a semantics-preserving `if`, `switch`, or conditional-expression structure MAY be used without an early return. This guard-clause requirement applies only to `if` statements; multi-arm constructs such as `switch` need not be rewritten as guards, but every path MUST satisfy the preceding branch test and preserve required semantics. This requirement does not authorize introducing a branch prohibited by the preceding rules. For this Section, falling through means the normal path proceeds after guard clauses without an `else` arm; it does not prohibit a final `return` required to return a value. A return necessary to implement this requirement is not an extra return under the following rule. For this rule, an extra return is a return that is not needed to produce a required outcome, preserve function semantics, or satisfy an explicit normative rule; required invariant-failure returns and returns implementing distinct required guards are not extra. A branch, return, variable, or helper added for control-flow style MUST be required by an explicit rule or satisfy the Necessity Gate in Section 1.2; it MUST NOT be added solely to express stylistic preference. Such an addition remains subject to all other applicable rules.

**Invalid example:** Function bodies MUST NOT use `else`.

```ts
if (isInvalid) {
    rejectRequest();
} else {
    acceptRequest();
}
```

**Good**

```ts
if (isInvalid) {
    rejectRequest();
    return;
}
acceptRequest();
```

### Section 3.2: Function continuity

Function bodies MUST NOT contain empty lines. This is a constitutional structural principle, not a formatter preference. Adjacent function and method definitions MUST be separated by exactly one empty line. Related steps SHOULD be extracted into a named function only when the extraction resolves concrete ambiguity or repetition that makes the body difficult to follow; an extra helper MUST NOT be added solely to narrate direct steps or satisfy a stylistic convention. A qualifying extraction satisfies Section 1.2's code-quality outcome when that ambiguity or repetition impedes understanding, but remains subject to the Gate's task-bounded scope; this SHOULD does not require an out-of-scope helper. Any added helper remains subject to the Necessity Gate in Section 1.2.

### Section 3.3: Direct bodies

Function bodies MUST communicate intent through direct names and structure. Comments MUST NOT appear within function bodies, whether inline or on separate lines. A named function or variable MUST NOT be extracted merely to narrate a direct one-line expression. Extract it only when it removes real ambiguity or repetition.

A required local `const` naming a compound Boolean condition under this Section is not an extraction solely to narrate an expression and takes precedence over the preceding restriction. A compound Boolean expression combines two or more Boolean terms with `&&` or `||`. A compound Boolean expression MUST NOT be used directly as the condition of a branch, loop, or conditional expression, except as permitted for loop conditions below. It MUST first be assigned to a local `const` with a question-shaped predicate name that states the complete decision. The branch, loop, or conditional expression MUST use that named predicate as its condition, directly or negated when guard polarity requires the opposite path, such as a loop-exit guard. This naming requirement applies even when the original expression is already clear. A loop rewrite that introduces a named predicate MUST evaluate it once each time the original condition would be evaluated, preserving evaluation order, short-circuiting, frequency, and position relative to the loop body and increment. The rewrite MUST preserve `continue` behavior and all other loop semantics. If a local `const` cannot be introduced at the original condition-evaluation point without changing loop semantics, the compound expression MAY remain directly in that loop condition.

**Invalid example:** The compound Boolean condition is used directly in the branch instead of a named question-shaped predicate.

```ts
if (isOrderPaid && hasAvailableStock) {
    dispatchOrder();
}
```

**Good**

```ts
const canDispatchOrder = isOrderPaid && hasAvailableStock;
if (canDispatchOrder) {
    dispatchOrder();
}
```

For a loop whose compound condition must be reevaluated on every iteration, compute the named predicate inside the loop and exit through a guard:

```ts
while (true) {
    const shouldContinue = hasNext() && isValid();
    if (!shouldContinue) {
        break;
    }
    processNext();
}
```

### Section 3.4: Fail-fast behaviour

A required invariant MUST be established by an applicable Contract, application rule, or boundary protocol, which MUST state the invariant and the conditions under which it applies; those conditions MAY be boundary preconditions or internal state guarantees. Intrinsic DTO-value constraints under Sections 5.4 and 6.2 also qualify. Code MUST fail fast when a required invariant is violated. It MUST NOT swallow errors, log and continue, or invent fallback values merely to avoid failure. Required cleanup attempts during replacement and `retryPendingCleanup` under Section 5.6(8) MUST continue for independent eligible operations despite an individual failure, provided all failures are surfaced as that Section requires. This continue-after-failure requirement applies only to replacement/rollback cleanup and `retryPendingCleanup`; it MUST NOT be applied to final shutdown, which follows the shutdown policy in Section 5.6(8). For cleanup outside the replacement and retry rules in Section 5.6(8), including final-shutdown cleanup, an applicable existing lifecycle Contract MAY explicitly authorize continuation after the first failure. Such authorization MUST be documented on the cleanup method and applies only to operations within that Contract's scope; that method documentation is the Contract's explicit permission for Section 5.6(8), so no duplicate policy is required. A Contract's permission applies only to its own operations; a combined shutdown plan may continue only when every governing Contract authorizes continuation as required by Section 5.6(8). A lifecycle Contract MUST NOT be introduced solely to state this policy. Unless an applicable Contract explicitly authorizes continuation, cleanup MUST stop after the first failure. Every failure that occurs MUST be surfaced, and multiple failures MUST be aggregated under Section 3.1. Multiple cleanup failures in one operation MUST be aggregated in encounter order with the first cleanup failure as primary, unless Section 3.1 identifies a prior caught failure as primary. An aggregate MUST expose failures as ordered entries: the primary failure is first, and subsequent failures follow encounter or execution order. A failure already represented by an aggregate MUST remain one nested entry and MUST NOT be flattened.

Deliberate Null Objects and explicit normalisation of platform values at a boundary are not defensive fallbacks when they are part of the declared contract.

### Section 3.5: Constructor effects

Constructors MUST only validate their arguments and initialise state owned exclusively by the instance under construction. DTO constructors MAY validate intrinsic values, but MUST NOT replace validation of external input, application rules, or relationships between objects.

Constructors MAY allocate ordinary in-memory state owned exclusively by the instance. They MUST NOT acquire resources managed outside the instance or requiring explicit release. Constructors MUST NOT cause externally observable effects, including interaction with the DOM, a framework, global state, or a supplied collaborator; input/output; resource acquisition or release; or event registration.

External setup MUST be performed after construction by an explicitly named instance command, composition code, or a compliant private lazy accessor method under Section 2.3. A private lazy accessor MAY perform externally observable setup only as permitted by Section 2.3; all other external setup MUST use an instance command or composition code. Constructors MUST NOT invoke a lazy accessor or trigger its setup indirectly.

### Section 3.6: Function parameter layout

Function-like declarations and signatures with two or more parameters MUST place each parameter on its own line. The first parameter MUST start on a line after the opening parenthesis, and the closing parenthesis MUST start on a line after the final parameter.

**Invalid example:** A declaration with multiple parameters must put each parameter on its own line.

```ts
function move(horizontalOffset: number, verticalOffset: number): void {}
```

**Good**

```ts
function move(
    horizontalOffset: number,
    verticalOffset: number
): void {}
```

## Article 4: Composition and Data Structures

### Section 4.1: Necessary composition

Class inheritance MUST NOT be used. Interface extension MAY be used to compose Contracts as required by Section 5.2. Use a direct function, value, or object unless an independently necessary collaborator or Contract better represents current ownership or an applicable contract. Except where a Contract is required at a module boundary under Sections 4.6 or 5.7, a Contract or collaborator MUST NOT be introduced solely for one known implementation, a theoretical replacement, or a structural convention.

### Section 4.2: Structured data

Arrays MAY represent homogeneous collections or local algorithmic structures whose positions are computational indices rather than named domain fields. Arrays MUST NOT be used as implicit records or positional DTOs. When array positions represent distinct named fields of one domain datum, regardless of dimensionality, a DTO class MUST be used and MUST expose each field through a named query. Technical tuples used only in an API-defined role, such as `Map` entries, are not positional DTOs. This exception applies only to the positional-DTO rule and does not permit array destructuring beyond the `for...of` entry-binding exception below.

Except for the `for...of` entry binding permitted below, array destructuring MUST NOT be used in any binding pattern or assignment expression. Code MUST use explicitly named variables with indexed access or a named query instead. The only permitted array destructuring is a `for...of` entry binding for a technical tuple whose positional meaning is defined by the iterated API, such as `for (const [key, value] of map.entries())`; domain records MUST NOT be destructured this way, and array destructuring in every other variable initialiser or assignment expression is prohibited. This rule does not prohibit array literals or indexed reads.

### Section 4.3: Literal values

A magic string or magic number is a literal value that encodes a domain rule, configuration, protocol, or other behaviorally significant choice rather than syntax intrinsic to the operation. A repeated string literal is the same string value used for the same semantic purpose at two or more locations within one module. Repetitions across modules are assessed independently and named within each module. This repeated-string classification applies independently of whether the literal is otherwise magic or syntax-intrinsic. Magic strings, repeated string literals, and magic numbers MUST be assigned a named variable or constant whose name expresses their meaning. The declaration MUST be at the narrowest scope that contains all its uses. A module-level constant required by this Section for repeated uses across functions is a deliberate module-level purpose under Section 2.5; when all uses are within one function, the declaration MUST remain in that function.

### Section 4.4: Static class members

Classes MUST NOT declare static fields, static methods, or static initialisation blocks. Shared behaviour MUST use a module-level function or value unless an independently necessary collaborator is required.

### Section 4.5: Vertical module ownership

1. Each cohesive feature or capability that owns application rules or authoritative state MUST have one vertical module as its owner.
2. A vertical module MUST keep the feature-specific behaviour, data handling, and domain-specific adapters for its capability within its private space. Technical layers MAY organise files inside the private space but MUST NOT split one capability across system-wide horizontal modules.
3. A helper MUST NOT be promoted to a vertical module solely to satisfy a structural convention. A single-use helper MAY remain a private function, value, or object within its owning module.
4. A shared infrastructure module MUST provide generic technical behaviour currently used by multiple vertical modules. It MUST NOT own feature-specific policy, authoritative feature state, or domain-specific adapters.
5. A vertical module MAY depend on shared infrastructure. Shared infrastructure MUST NOT depend on a vertical module.

### Section 4.6: Module public and private spaces

1. Each vertical module MUST have a public entry point that exposes its public Contract interface or interfaces and only the minimum named data types required by their signatures. A shared infrastructure module that meets Section 4.5(4) and is consumed by another module MUST have a public entry point with the same export restrictions. Any DTO used at the boundary MUST comply with Section 5.4. A module's composition entry point MUST be a distinct export surface from its public entry point; distinct surfaces are separate importable module paths or package export subpaths and MAY share private implementation files. The public entry point MUST NOT re-export the module factory or composition-only interface.
2. Production code in another module MUST access a boundary module only through its public entry point. The composition root is exempt only for importing that module's composition entry point under Section 4.7(3); it MUST NOT import other private files or symbols through deep paths.
3. Inter-module behaviour MUST be expressed through public Contract interfaces. The composition root MAY invoke composition-only lifecycle or setup operations required for composition under Sections 3.5 and 4.7(4), but only through the composition-only interface under Section 4.7(1). The exceptions are owner-facing lifecycle operations under Section 5.6(7) and resource-owner cleanup operations under Section 5.6(8); they are exceptions only to the public-Contract dependency rule. The composition root MAY invoke an owner-facing operation only when it is the designated owner; otherwise it passes that handle to the designated owner. For resource-owner cleanup, the composition root MUST pass the cleanup handle as a dependency to the Stable Proxy module's factory, typed by the receiving module's private local resource-cleanup Contract under Section 4.7(2). This exception permits handle injection only; the composition root MUST NOT invoke cleanup itself, and the Stable Proxy invokes the operation under its authorization. These operations MUST NOT be exposed through the public entry point or to ordinary consumers. Consumers MUST NOT depend on a Concrete implementation.
4. A module's public behavioural API MUST NOT expose its operations as collections of free functions. Public operations MUST be methods of its Contract interface or interfaces.

### Section 4.7: Module composition and dependency direction

1. Each vertical module and each shared infrastructure module consumed by another module MUST provide one composition entry point containing one module factory. The factory MUST construct the module's private implementation. When the module exposes one public consumer Contract and provides no composition-only lifecycle/setup or owner-facing operation invoked by the composition root or passed by it to an external lifecycle owner, the factory MUST return an object typed by that public Contract. When the module exposes multiple public consumer Contracts, or provides one or more composition-only lifecycle/setup or owner-facing operations invoked by the composition root or passed by it to an external lifecycle owner, the factory MUST return an object typed by a named composition-only interface that extends the public consumer Contracts and directly declares every such operation. Composition-only lifecycle/setup operations have the meaning in Section 2.7; owner-facing operations under Section 5.6 are a separate category. Every lifecycle/setup or owner-facing operation the composition root is permitted to invoke or pass to an external lifecycle owner MUST be included in this interface. This includes any composition-only shutdown trigger for an in-module lifecycle owner that the composition root invokes under Section 5.6(7). Optional feature behavior is not a composition-only lifecycle/setup operation and MUST be exposed through an appropriate consumer Contract. An internal lifecycle operation invoked only within the module's private space does not affect the factory's return type. An operation's mere existence does not require declaration on the composition-only interface when it remains private to the module. The composition-only interface is required whenever the module exposes multiple public consumer Contracts, or for operations invoked by the composition root or passed to a designated lifecycle owner outside the module. Operations used only by an in-module lifecycle owner MUST remain private and MUST NOT be declared on that interface. The composition-only interface type MUST be imported only through the composition entry point. The composition root MAY pass the same runtime object to consumers as references narrowed to the specific public Contracts they require; those consumers MUST NOT receive or import the composition-only handle or owner-facing operations. The full composition-only runtime handle MAY be passed only to the designated lifecycle owner under Section 5.6(7); that owner is not an ordinary consumer for this purpose and MUST access the handle only through its local owner-facing Contract, not by importing or using the composition-only interface type. Consumers MUST depend on the specific public Contract or Contracts they require. Composition return shape is based on the number of all public consumer Contracts; the primary Contract designation does not change that count or return shape. For classification, the composition-only interface is a Contract and MUST comply with Section 5.2, but it is not a public consumer Contract under Sections 4.6 and 5.7. The module factory is a composition-only function, not part of the module's public behavioural API under Section 4.6.
2. A module factory MUST receive each dependency on another module through that module's public Contract interface, except that the composition root MAY pass (a) a Proxy owner-control handle under Section 5.6(7) only to the designated lifecycle owner, (b) a provider shutdown handle under Section 5.6(7) only to an external designated lifecycle owner, or (c) a resource-owner cleanup handle under Section 5.6(8) only to the Stable Proxy's module when it must coordinate cleanup of that resource. The receiving module MUST declare a local owner-facing Contract for (a) or (b), or a local resource-owner cleanup Contract for (c). The composition root MUST pass each runtime handle as a dependency typed at the receiving factory boundary by that local Contract. Each local Contract MUST be private to the receiving module, expose only the required lifecycle operations, and MUST NOT import the other module's composition-only interface. These are the sole non-public Contracts permitted for those composition-time lifecycle dependencies under Section 4.6(3), and are distinct from provider public consumer Contracts and composition-only interfaces.
3. Production code outside the composition root MUST NOT import a module's composition entry point. The composition root MUST use module factories to construct modules and connect their Contracts.
4. The composition root MUST NOT own feature rules or workflow behaviour. It MAY construct modules, supply dependencies, and invoke composition-only lifecycle/setup operations, such as module initialization and release of resources assigned to composition-only lifecycle ownership, excluding delegate cleanup and other owner-facing operations under Section 5.6. It MAY invoke owner-facing operations, such as replacement, cleanup retry, and final shutdown, only when it is the designated lifecycle owner. Contract wiring means only passing Contract references to module factories; it does not invoke a module operation and does not require a composition-only method. Every root-invoked composition-only or owner-facing operation MUST be declared on the composition-only interface under Section 4.7(1). These operations MUST NOT perform domain actions or sequence capability operations. The composition root MUST NOT make workflow decisions, branch on capability outcomes, or handle workflow results. Any command that coordinates capability operations MUST be owned by a workflow module.
5. The module dependency graph MUST be acyclic. A workflow module MUST depend on the capability Contracts it coordinates, and capability modules MUST NOT depend on a workflow module.
6. Cross-capability workflows MUST be owned by workflow modules, not by the composition root.

## Article 5: Contracts and DTOs

### Section 5.1: Classification

This classification applies after an interface, DTO, or class is independently necessary under Article 1 or explicitly required by a module-boundary rule. Every interface in project-authored application code that describes behavior MUST be classified as a `Contract`. Non-behavioral data shapes MUST NOT be declared as interfaces. Internal non-behavioral data shapes MUST use named type aliases, except positional domain data for which Section 4.2 requires a DTO class. Contract signatures MAY use primitive types, literal unions, and named aliases of primitive or union types; these are not object-shaped data. Object-shaped Contract data MUST use DTO classes under Sections 4.6 and 5.4, except named union result types permitted by Section 6.1 whose object-shaped variants are DTO classes. Interfaces declared solely to describe or augment platform, third-party, or generated APIs are boundary declarations, not application Contracts; they MUST remain within their adapters and be translated before entering application Contracts. Every DTO MUST be a class. Every class MUST be classified as either a `DTO` or a `Concrete` implementation; there is no third class classification. A class that carries data without active behaviour MUST be a DTO. Every non-DTO class MUST provide active behaviour and be classified as a `Concrete` implementation; a passive data-holding class MUST NOT remain outside the DTO classification. A `Concrete` implementation need not implement a Contract unless it is used as a Contract implementation. A class that provides active behaviour for a Contract MUST be classified as a `Concrete` implementation, not as a `Contract`.

A `Contract` is a first-class description of behaviour represented by an interface. A DTO carries data in private instance state.

### Section 5.2: Contract interfaces

Contract interfaces MAY declare method signatures. Their methods are public by definition. They MUST contain method signatures only. Documentation comments attached to a method signature MAY describe its Contract behavior and are not interface members. A required default behavior under Section 6.1 MUST be documented in a comment attached to the corresponding method signature. Contract interfaces MUST NOT declare properties, index signatures, call signatures, or construct signatures.

Property and parameter type annotations MUST NOT use intersection types. A combined Contract requirement MUST be represented by a named Contract interface that extends its required Contracts. This restriction does not apply to return or local-variable type annotations, but that exception MUST NOT be used to expose object-shaped Contract data that Section 5.1 requires to be DTO classes.

### Section 5.3: Concrete implementation classes

Concrete implementation classes MUST provide the methods required by each implemented Contract and MAY declare other public methods when required by their role; those methods MAY be queries or commands. Their instance properties MUST be private. They MUST expose state through ordinary public methods when access is required, not public properties or JavaScript getter/setter syntax. Concrete implementation classes MAY mutate their private state when the mutation is part of the implemented Contract, but they MUST NOT take ownership of rules that belong to another boundary.

**Invalid example:** Constructor parameter properties are prohibited, and class instance properties must be private.

```ts
export class ConcreteProduct implements Product {
    public constructor(
        public readonly id: EntityId,
        public readonly name: string,
        public readonly retailPrice: number,
        public readonly createdAt: string,
        public readonly updatedAt: string
    ) {}

    public isPresent(): boolean {
        return true;
    }
}
```

**Good**

```ts
export class ConcreteProduct implements Product {
    private readonly productId: EntityId;
    private readonly productName: string;
    private readonly productRetailPrice: number;
    private readonly productCreatedAt: string;
    private readonly productUpdatedAt: string;

    public constructor(
        productId: EntityId,
        productName: string,
        productRetailPrice: number,
        productCreatedAt: string,
        productUpdatedAt: string
    ) {
        this.productId = productId;
        this.productName = productName;
        this.productRetailPrice = productRetailPrice;
        this.productCreatedAt = productCreatedAt;
        this.productUpdatedAt = productUpdatedAt;
    }

    public id(): EntityId {
        return this.productId;
    }

    public name(): string {
        return this.productName;
    }

    public retailPrice(): number {
        return this.productRetailPrice;
    }

    public isPresent(): boolean {
        return true;
    }
}
```

### Section 5.4: DTO classes

DTOs MUST be classes with private instance properties and public constructors. They MUST expose data through ordinary public query methods. DTO methods MUST NOT enforce application rules, mutate authoritative application state, or perform external effects. DTO constructors MAY validate intrinsic values and initialise or freeze state owned by the new instance, but MUST NOT perform external effects.

DTO query methods MUST use nouns, noun phrases, question-shaped predicates, or `<value>From<source>` constructions. A DTO query method returning `boolean` MUST use a question-shaped predicate name as required by Section 2.2; the other listed naming forms apply only to non-Boolean queries. DTOs MUST NOT use public properties or JavaScript getter/setter syntax. All DTO-owned state MUST remain immutable after construction. This means that code using the DTO's public TypeScript API MUST NOT be able to change DTO-owned state; protection against deliberate casts, reflection, or other bypasses is not required. DTO constructors MUST NOT retain caller-owned mutable references. When an input contains mutable objects or collections, constructors MUST create independent copies of the containers and recursively copy mutable contained values. These copies become DTO-owned state and MUST satisfy the public-API immutability guarantee below; runtime freezing is not required. Primitive `Map` keys and `Set` elements, and retained immutable DTO keys and elements, preserve identity only as permitted by the rules below; this does not permit retaining other mutable object references. If an input cannot be copied safely, the constructor MUST reject it rather than retain a mutable reference. Safe copying means creating an independent value that preserves the input's declared value semantics. Across all constructor arguments in one DTO construction, recursive copying MUST preserve non-cyclic aliasing: repeated references to the same supported mutable object MUST map to the same copied object using one copy context. Cycles and identity-sensitive relationships that these rules cannot preserve MUST be translated at the boundary or rejected. A plain data object MUST have `Object.prototype` or `null` as its prototype and only own enumerable string-keyed data properties. Values passed to DTO constructors MUST NOT be Proxy objects. Because JavaScript provides no general reliable Proxy-detection mechanism, boundary adapters MUST establish this through trusted provenance, such as parsed JSON or locally constructed data, or use source-specific normalization; they MUST reject untrusted values that cannot be normalized. DTO constructors MAY rely on this boundary precondition and are not required to detect Proxy objects at runtime. Objects with accessors, symbol-keyed or non-enumerable properties, or prototypes other than `Object.prototype` or `null` MUST be translated at the boundary or rejected. Inherited properties from `Object.prototype` are ignored and are not copied. Arrays MUST be dense and have no non-index own properties other than the intrinsic `length` property; sparse arrays and arrays with additional properties MUST be translated or rejected. Every array index MUST be an own data property; accessor elements MUST be rejected without invoking their getters. An array index is a canonical decimal property string representing an integer `n` where `0 ≤ n < 2^32−1`; strings such as `'01'`, `'-1'`, and `'4294967295'` are non-index properties. Mutable arrays, plain data objects, `Map` instances, and `Set` instances MUST be copied as independent containers; mutable array/object contents and `Map` values MUST be copied recursively. Primitive `Map` keys and `Set` elements MAY be retained. Object keys and elements MUST NOT be cloned because `Map` and `Set` use identity for them; they MAY be retained only when they are DTO instances satisfying Section 5.4's public-API immutability guarantee. Other object keys and elements MUST be normalized at the boundary to immutable value-based primitives or rejected. Cycles, functions, host objects, and identity-sensitive class instances MUST be translated at the boundary into supported values or rejected. DTO query methods MUST NOT expose mutable references to DTO-owned values, including mutable nested objects and collections; they MAY return immutable values or defensive copies. A DTO instance complying with this Section is an immutable value: constructors MAY retain references to such DTO instances without copying, and query methods MAY return nested DTO references. This permission does not apply to mutable collection or object references. Runtime freezing is not required when encapsulation and copying provide these guarantees.

**Good**

```ts
export class LoginDto {
    private readonly loginEmail: string;
    private readonly loginPassword: string;

    public constructor(
        email: string,
        password: string
    ) {
        this.loginEmail = email;
        this.loginPassword = password;
    }

    public email(): string {
        return this.loginEmail;
    }

    public password(): string {
        return this.loginPassword;
    }
}
```

### Section 5.5: Visibility

Every class method and property MUST declare explicit visibility. Constructors MUST declare explicit visibility. Class instance properties MUST be private; public and protected properties are prohibited. Constructor parameter properties MUST NOT be used; fields MUST be declared explicitly as private members. Private members MUST use standard camelCase without a leading underscore; the `private` modifier communicates visibility. Interface members are public by definition and MUST NOT use class visibility modifiers.

### Section 5.6: Replaceable Collaborator Roles

This role arrangement applies only when the collaborator Contract is independently necessary under Article 1 or required at a module boundary. In this Section, “the module” means the Stable Proxy's provider module unless the owner module is expressly named. Within that scope, replacement, expected collaborator absence or inactivity, and stable retained identity are addressed only when required by the Contract or demonstrated current use. Expected absence alone MUST NOT require a new collaborator Contract or this role arrangement. Expected collaborator absence means that no active collaborator is available to perform its role. Expected inactivity means that a collaborator exists but is deliberately unavailable to perform one or more capabilities; the Contract MUST define whether its required behavior is the same as for absence. Domain-value absence means that an active collaborator reports that no value exists and is governed by Section 6.1.

A replaceable collaborator is a Contract-backed object whose implementation may change while its consumers retain references.

A Concrete implementation is a non-DTO class that provides active behaviour. When it implements a Contract, it provides active behaviour for that Contract.

A Stable Proxy is a Contract implementation whose identity remains stable while it delegates operations to a current implementation.

The current implementation held by a Stable Proxy is its delegate.

Candidate custody is the Stable Proxy's responsibility to retain and manage a candidate delegate through preparation, rollback, promotion, or discard. Discard means relinquishing the candidate only after all required cleanup succeeds; while any cleanup remains pending, the candidate stays in Proxy custody. Transferring candidate custody does not transfer ownership of resources held by that delegate; each resource retains its separately designated lifecycle owner.

A **Proxy owner-control Contract** names the owner-only capability for replacement and pending-cleanup retry; it is not a consumer Contract and does not require a standalone provider-side TypeScript interface. Final shutdown is a separate owner-facing lifecycle operation. A **provider shutdown operation** performs the Stable Proxy's final cleanup and terminal transition. An **owner-module shutdown orchestration command** requests that operation through the injected provider handle; it does not itself release provider resources. When the lifecycle owner is outside the module, all owner-control operations required by that owner MUST be declared directly on the composition-only interface under Section 4.7(1); these methods satisfy the provider-side owner-control Contract, and no separate provider-side interface is required. The receiving module MUST still declare its local owner-facing Contract under Section 4.7(2).

A **delegate-lifecycle Contract** defines candidate preparation, rollback, and cleanup operations between the Stable Proxy and its Concrete delegates; it is private to their owning boundary and is not exposed to the lifecycle owner or ordinary consumers.

1. A replaceable collaborator MUST expose a Contract separate from its Concrete implementations.
2. A replaceable collaborator MAY have multiple Concrete implementations.
3. This rule applies only to an already independently necessary collaborator Contract that must support expected absence or inactivity; it does not require creating a Contract solely because either state is possible. Such a Contract MUST use either a Null Object implementing that Contract when consumers need not distinguish those states, or a non-null result type in the relevant method signatures that explicitly distinguishes the states consumers must handle, as permitted by Section 6.1. When consumers must react differently to absence and inactivity, the relevant Contract methods MUST expose that distinction through non-null result types or query results whether or not a Null Object is also used; a Null Object alone is insufficient. An availability query used for this distinction MUST return a non-null type with separate absence and inactivity states; a Boolean query is sufficient only when consumers need not distinguish those states. When the result-type alternative is used, each operation whose outcome depends on collaborator availability MUST return a result type that represents both availability and the operation's normal result. Availability and domain-value presence are separate dimensions. For a query, the result type MUST distinguish an available collaborator's normal domain result from collaborator-absent or inactive cases; the normal domain result MAY itself represent domain-value absence under Section 6.1. For a command, it MUST distinguish a completed operation from collaborator-absent or inactive cases. Callers invoke the operation and handle its result rather than relying on a separate preflight check. Availability queries MAY be the sole means of reporting presence or inactivity when no operation's outcome depends on availability. When an operation's outcome does depend on availability, a query MAY supplement but MUST NOT replace that operation's required availability result. This result type represents collaborator availability; it does not implement or replace the collaborator Contract. A Null Object may handle both states internally only when the same safe behavior satisfies the Contract and consumers need not distinguish them. Expected absence alone MUST NOT require a new collaborator Contract. When a substitute collaborator object represents expected absence or inactivity, it MUST be a Null Object. Domain-value absence reported by an active collaborator is governed by Section 6.1 and does not require a Null Object.
4. When the collaborator Contract requires, or demonstrated current consumer behavior shows, that consumers retain a reference across delegate replacement, composition MUST distribute a Stable Proxy rather than a Concrete implementation. If demonstrated current use establishes this requirement but the Contract does not yet state it, the Contract MUST be updated and all affected consumers MUST be updated in the same coherent change.
5. A Stable Proxy MUST preserve its identity and delegate each Contract operation to its current delegate, except when Section 5.6(8) requires it to fail fast while cleanup of the current delegate is pending or after successful shutdown.
6. A Concrete delegate MUST NOT escape its owning composition or lifecycle boundary through consumers, callbacks, cleanup owners, getters, or public mutable state.
7. A Stable Proxy that supports replacement MUST make replacement and required cleanup-retry operations available to the designated lifecycle owner through the owner-control API. When the owner is outside the module, this API MUST be a Proxy owner-control Contract declared on the composition-only interface; when the owner is inside the module, the API MUST consist of private commands and no separate Contract is required. The composition root MUST designate exactly one lifecycle owner for each Stable Proxy in composition wiring; this role is separate from the lifecycle owner of any resource held by a delegate. Designation records responsibility and does not always require runtime injection: for an in-module owner, composition identifies the owning module and no owner handle is passed; for an external owner, the root passes the handle as specified below. When replacement or rollback cleanup can fail and leave cleanup pending, the API MUST include an explicit `retryPendingCleanup` command; it MUST be a Contract method for an external owner and a private command for an in-module owner. It MUST return a Boolean completion result: `true` only when no replacement or rollback cleanup remains pending, and `false` when cleanup remains pending without an attempted operation failure. An attempted cleanup failure MUST be thrown or rejected under Section 5.6(8)'s aggregation rules. This command MUST NOT retry final-shutdown cleanup, which is retried only by the shutdown command. Every Stable Proxy under this Section MUST support final shutdown, regardless of whether it supports replacement and even when its cleanup plan is empty; an empty plan completes shutdown and places the Proxy in its terminal state. When the lifecycle owner is outside the provider module, the provider's composition-only interface MUST declare the provider shutdown operation. If the designated lifecycle owner is a separate module, that owner module's composition-only interface MUST declare an owner-module shutdown orchestration command that invokes the provider shutdown operation through the injected handle when the composition root is the shutdown coordinator. If the owner module initiates shutdown independently, its orchestration command MUST remain private. When the owner is inside the module, the Stable Proxy's shutdown command MUST remain private. If the composition root coordinates shutdown for that module, the module MUST expose a separate composition-only shutdown trigger, accessible only to the composition root. The trigger's sole behavior MUST be to request the private owner command and forward its completion or failure; it MUST NOT expose the Stable Proxy command or handle. An ordinary consumer Contract MUST NOT expose replacement or cleanup-retry commands. When the lifecycle owner is outside the module, the owner-facing operations MUST be declared on the module's composition-only interface under Section 4.7(1). On that interface, replacement and cleanup-retry methods comprise the Proxy owner-control Contract; a shutdown command is a separate owner-facing lifecycle operation and is not part of that Contract. Its replacement command MAY accept primitive configuration values, DTO request classes, or named unions of request variants whose object-shaped variants are DTO classes under Section 5.1, or no arguments. Named result types for domain absence under Section 6.1 MUST NOT be used as request types. The command MUST NOT accept object-shaped aliases, a Concrete delegate, or a resource reference. The module MUST construct Concrete candidates within its private space. The owner-facing handle is the runtime object typed by the composition-only interface returned by the module factory. The composition root MUST obtain it through the composition entry point. If the composition root is the designated lifecycle owner, it MAY invoke the operations directly; otherwise it MAY pass that object as a composition-time dependency only to the designated lifecycle owner, whose local owner-facing Contract MUST expose only the operations it needs and which MUST NOT import the composition entry point. When the lifecycle owner is inside the module, replacement, cleanup-retry, and the Stable Proxy's shutdown command MUST remain in the module's private space. If the composition root coordinates shutdown for that module, the module MUST expose a separate shutdown trigger on its composition-only interface; the trigger invokes the private command without exposing it or its handle. If the in-module owner initiates shutdown itself, no trigger is required and that owner is the shutdown coordinator for the Stable Proxy. The public entry point MUST NOT expose owner-facing operations.
8. Delegate replacement MUST define ownership and cleanup semantics for the current and replacement delegates on success and every failure path. These transaction-specific rules apply to cleanup performed during replacement and `retryPendingCleanup`. Final Stable Proxy shutdown cleanup is governed by Section 3.4 and by each applicable lifecycle Contract for the operations within that Contract's scope. Final shutdown of a Stable Proxy MUST be initiated by its designated lifecycle owner. The system shutdown coordinator MUST request and await shutdown through the designated lifecycle owner's permitted path; it MUST NOT execute the provider operation unless it is the designated lifecycle owner. When the owner is inside the module and the root is shutdown coordinator, the root invokes the composition-only trigger, which invokes the private owner command. If the composition root is the designated lifecycle owner, it MUST invoke and await the provider's shutdown operation directly through the provider's composition-only interface.  If the designated owner is a separate module, the composition root MUST pass the provider's composition-only runtime handle to that owner module during composition under Section 5.6(7). If the root is shutdown coordinator, it MUST invoke and await the owner module's shutdown orchestration command through that module's composition-only interface; if the owner module is coordinator, it invokes its own command. In either case, the owner module's command invokes the provider's owner-facing shutdown operation through the injected handle. Only the designated lifecycle owner executes the provider shutdown operation. The root MUST NOT bypass the designated owner or release delegate resources itself. The coordinator MUST NOT bypass the designated owner or release delegate resources itself. For shutdown cleanup of delegate-owned resources, the delegate-lifecycle Contract is the applicable lifecycle Contract under Section 3.4 and MAY specify whether cleanup stops after the first failure or continues with independent eligible operations; unless it explicitly specifies continuation, Section 3.4 requires stopping after the first failure. For this Section, an unqualified “shutdown plan” means the final-shutdown cleanup plan. For any such plan combining operations governed by multiple lifecycle Contracts, including delegate-lifecycle and resource-owner Contracts, each Contract governs its own operations. An operation with no applicable lifecycle Contract follows Section 3.4's stop-after-first-failure default. This plan-wide rule governs Stable Proxy shutdown and supersedes Section 3.4's general default for such plans. A Contract governs every operation it declares in the plan, including operations currently blocked by prerequisites. Continuation after a failure is authorized only when each authoritative lifecycle Contract governing the failed operation and every remaining eligible or blocked operation explicitly permits continuation after that failure type; a general continuation statement that does not cover those operations is insufficient, and silence is not permission. For resource-owner cleanup, the resource-owner lifecycle Contract is authoritative; the receiving module's local resource-owner cleanup Contract is only a signature mirror and is not a separate continuation authorization. This authorization permits only independent cleanup operations whose prerequisites have succeeded; it never permits attempting a blocked operation, which remains unattempted until its prerequisites succeed. Otherwise, the combined plan MUST stop after the first failure. Composition wiring MUST NOT override an explicit stop-on-failure policy. Cleanup of resources outside that Contract's scope is governed by their owning lifecycle Contract and Section 3.4. The resource-owner lifecycle Contract defines which resource lifecycle events require release, the operation semantics and prerequisites, and the conditions under which its owner authorizes cleanup. The Stable Proxy module's local resource-owner cleanup Contract MUST faithfully mirror those requirements and type the supplied runtime operation; the resource-owner lifecycle Contract is authoritative if they differ. For continuation-policy purposes, the local Contract is a type mirror and is not a separate governing lifecycle Contract. The delegate-lifecycle Contract MUST map replacement, candidate-discard, and shutdown events to those resource lifecycle events; it MUST NOT waive an owner-required cleanup event or create a new resource-level cleanup obligation. The module factory reconciles the mapping and owner requirements into the cleanup plan, and MUST fail composition if they conflict or the local Contract does not match. The final-shutdown plan MUST include every delegate-owned cleanup operation and authorized resource-owner cleanup operation required at shutdown; composition wiring MUST NOT omit a required operation. Resources not assigned to this Proxy remain the responsibility of their owners. Final shutdown completes only after every operation in that plan succeeds. Final shutdown is retryable: if cleanup fails, shutdown MUST fail without discarding the Stable Proxy or its resource handles. From the moment final-shutdown cleanup begins, consumer operations MUST fail fast without invoking the delegate. While the first shutdown cleanup attempt is in progress before any failure is stored, consumer operations MUST fail with a shutdown-in-progress failure. During a shutdown retry, consumer operations MUST propagate the previously stored shutdown cleanup failure unchanged until the retry settles; a failed retry then replaces that stored failure. A shutdown retry is permitted only after the preceding shutdown attempt has settled unsuccessfully. While a shutdown attempt is in progress, any overlapping shutdown invocation and all other lifecycle commands MUST fail fast under the lifecycle-command serialization rule; consumer operations follow the separate in-progress and stored-failure rules above. While final-shutdown cleanup remains pending after a failed attempt, replacement, `retryPendingCleanup`, and all lifecycle commands other than the shutdown command MUST be rejected. Each failed final-shutdown cleanup attempt MUST store the exact single failure or aggregate surfaced by that attempt, and consumer operations MUST propagate that stored value unchanged until another shutdown cleanup attempt updates it. A subsequent invocation of the shutdown command MUST retry only incomplete cleanup steps under the applicable lifecycle Contract; successfully completed steps MUST NOT be repeated. Shutdown completes and releases the Stable Proxy's handles only after all required cleanup succeeds. The Stable Proxy MUST enter its terminal shutdown state only after cleanup succeeds; while cleanup is pending, it remains in the distinct pending-shutdown state. After successful shutdown, subsequent shutdown calls MUST complete successfully without repeating cleanup. In the terminal shutdown state, consumer operations MUST fail fast without invoking the delegate, throwing a failure that identifies the shutdown state or rejecting with that failure for Promise-returning methods. Before final shutdown begins, the designated lifecycle owner MUST invoke `retryPendingCleanup` only when replacement or rollback cleanup is pending and MUST proceed only when it returns `true`. This is a preflight operation; `retryPendingCleanup` MUST NOT be invoked after final-shutdown cleanup begins. If it returns `false`, final shutdown MUST NOT begin and no final-shutdown failure state is stored. If it throws or rejects, the shutdown request MUST fail before final cleanup begins; the lifecycle owner MUST retain the Stable Proxy and its pending cleanup state, propagate the retry failure, and retry shutdown only after cleanup succeeds. No final-shutdown pending state is entered by a failed preflight; consumer-operation availability remains governed by whether cleanup of the current delegate has begun under the replacement rules above. Each resource requiring explicit release MUST have exactly one lifecycle owner identified by the resource's lifecycle Contract or composition wiring; direct or indirect acquisition does not change that ownership. The delegate-lifecycle Contract defines cleanup operations but does not change resource ownership. For delegate-owned resources, it MUST authorize the Stable Proxy to invoke the declared cleanup operations. For a resource owned by another component, that owner MUST explicitly authorize the Proxy through composition wiring; the wiring supplies runtime authorization under the conditions defined by the resource-owner lifecycle Contract. Without that authorization, the Proxy MUST NOT invoke cleanup. The Stable Proxy coordinates delegate cleanup but is not automatically the resource owner. It invokes those operations on behalf of the designated resource owner. The resource owner remains accountable for ensuring release, while the Stable Proxy executes cleanup as that owner's authorized coordinator without taking resource ownership; this authorization does not permit cleanup of resources owned by another component. For a borrowed or shared resource, its designated owner MUST provide any required cleanup operation through an existing resource-owner lifecycle Contract or composition wiring, and the Stable Proxy MUST invoke that owner operation directly. When such cleanup is required before delegate promotion or candidate discard during replacement or rollback, it MUST be included in the applicable cleanup plan. The resource-owner cleanup Contract is authoritative for the operation and its prerequisites; the delegate-lifecycle Contract MAY specify required relative-order constraints between that operation and delegate-owned cleanup but MUST NOT redefine it. The Stable Proxy module's factory MUST reconcile these constraints into one deterministic plan and record the combined prerequisites, relative ordering, and tie-breaker in private construction-time configuration. Composition wiring supplies the lifecycle Contract dependencies and cleanup handles but MUST NOT calculate or override the plan. If the factory cannot reconcile the constraints, it MUST fail before returning the Stable Proxy's consumer Contract, composition-only interface, or any other handle through which replacement can be invoked. A cleanup-operation failure during replacement or rollback blocks promotion or discard, remains pending, and is retried by `retryPendingCleanup`. Failure to reconcile the cleanup plan is a factory-time failure, not pending cleanup. Final-shutdown cleanup is retried only by the shutdown command. Successful release is recorded and MUST NOT be repeated. The delegate-lifecycle Contract MUST NOT direct a delegate to release a resource it does not own; the resource owner performs the release while the Proxy coordinates retries and failure reporting. A candidate-owned resource is one assigned to the candidate delegate as lifecycle owner; merely holding or borrowing a resource does not qualify. Transferring candidate-object ownership to the Stable Proxy does not transfer ownership of borrowed or shared resources. A delegate owns a resource for cleanup purposes only when assigned that ownership; borrowed or shared resources MUST be released only by their designated owner, and a delegate MUST NOT release them unless it is that owner. Cleanup is required for every resource owned by a delegate whose lifecycle contract requires explicit release when the delegate's lifetime ends; ordinary in-memory state requires no cleanup. Candidate preparation, rollback, and cleanup operations for delegate-owned resources MUST be declared on the delegate-lifecycle Contract, with their prerequisites and relative ordering documented there. Every preparation step that acquires a resource or leaves state requiring release MUST have a corresponding rollback operation and a Proxy-maintained per-step completion record. A step is complete only after a reliable success signal; uncertain preparation outcomes MUST remain pending until rollback or a reliable completion check resolves them. Cleanup operations for borrowed or shared resources MUST be declared only on the resource-owner cleanup Contract, which documents their prerequisites. The delegate-lifecycle Contract MAY specify where those operations participate in the combined cleanup plan without redefining them; composition wiring records the reconciled total order and tie-breaker. The Stable Proxy MUST invoke each operation through its owning Contract. Any cleanup or shutdown operation that performs asynchronous work MUST return a Promise that settles only when that work completes or fails; synchronous operations MUST complete before returning. The Proxy owner-control Contract exposes only replacement and cleanup-retry operations. This restriction applies to that capability, not to the containing composition-only interface, which MAY also declare separately required lifecycle/setup operations under Section 4.7(1). The replacement command MUST check for pending cleanup before accepting a replacement request. If cleanup is pending, the command MUST fail fast and MUST NOT retain the request data; request types are value data and do not transfer resource ownership. On acceptance, the module MAY use the request to construct the candidate, and any value needed later MUST become candidate-owned state rather than remain a separately retained request. After acceptance, the module's private implementation MUST construct the Concrete candidate within its owning boundary; candidate custody and responsibility for its replacement lifecycle MUST transfer to the Stable Proxy before preparation begins, without changing any resource's designated lifecycle owner. Before custody transfers, the candidate MUST NOT acquire or own resources requiring explicit release; all such acquisition MUST occur during lifecycle preparation after transfer. The Stable Proxy MUST perform candidate preparation and rollback within its owning boundary and retain the candidate privately until it becomes current or is fully cleaned up. Preparation succeeds only when every required preparation operation completes; a failure at any preparation step MUST be treated as preparation failure and follow the rollback path. Candidate preparation by the Stable Proxy is lifecycle setup only; it MUST NOT apply feature rules, perform domain actions, or sequence capability operations. If readiness requires domain behavior or cross-capability coordination, the owning vertical or workflow module MUST perform that work before invoking the replacement command and supply any required readiness result as declared request data; the composition root MUST NOT perform it. If preparation fails, the Stable Proxy MUST retain the existing delegate reference and attempt every eligible cleanup operation in the candidate-discard plan, including authorized resource-owner operations assigned to run when the candidate is discarded. The preparation failure is the original caught failure for Section 3.1's aggregation rule. Resources whose cleanup is blocked by prerequisites or fails MUST remain pending. Rollback succeeds only when every required candidate cleanup operation has succeeded. If rollback succeeds, the candidate MUST be discarded and the Stable Proxy MUST clear its private preparation-status and cleanup-progress records for that candidate; preparation state means these Proxy-owned records and does not require resetting the discarded candidate. The preparation failure MUST propagate even when rollback succeeds. If rollback fails, the Stable Proxy MUST retain the candidate privately with pending status for each unreleased resource, and propagate the preparation failure and all rollback failures. While rollback of a failed candidate is pending and cleanup of the current delegate has not begun, the Stable Proxy MAY continue delegating consumer operations to the unchanged current delegate. Rollback cleanup failures in this state are surfaced by replacement or cleanup-retry operations and MUST NOT be propagated from consumer operations on the unchanged delegate. After successful preparation, the Stable Proxy MUST clean up all resources of the current delegate that require release before assigning the candidate as current. If cleanup of the current delegate fails, the Stable Proxy MUST retain the existing delegate reference and the prepared candidate privately as a pending replacement; the existing delegate remains the recorded current delegate solely for cleanup and retry, but is unavailable for consumer operations. The Proxy MUST NOT clean up the candidate or accept another replacement, and it MUST propagate the cleanup failure. From the moment cleanup of the current delegate begins until retry succeeds and the candidate becomes current, the Stable Proxy MUST NOT invoke that delegate for consumer operations. While the first cleanup attempt is in progress before any failure is stored, consumer operations MUST fail fast with a cleanup-in-progress failure. During a retry, consumer operations MUST propagate the previously stored cleanup failure unchanged until the retry settles; a failed retry then replaces that stored failure. The stored cleanup failure MUST be the single failure or aggregate from the most recent cleanup attempt; consumer operations MUST propagate it unchanged until another retry, and a successful retry MUST clear it. The error surfaced by the initial replacement invocation for current-delegate cleanup MUST be the exact error instance stored for subsequent consumer calls. Each failed retry MUST replace it with the exact error instance surfaced by that retry. For synchronous Contract methods, propagation means throwing that instance; for Promise-returning methods, it means rejecting with that same instance as the rejection reason without wrapping it. The Stable Proxy MUST serialize replacement, `retryPendingCleanup`, and shutdown lifecycle commands. A lifecycle command invoked while another is in progress MUST fail fast without accepting a candidate or changing ownership state. “Cleanup pending” includes cleanup operations that are in progress as well as failed operations awaiting retry. The owner-facing `retryPendingCleanup` command MUST retry all eligible pending cleanup operations from replacement or rollback in their defined dependency order, without repeating any cleanup step already completed. It MUST NOT retry final-shutdown cleanup; shutdown cleanup is retried only by the shutdown command. Each applicable lifecycle Contract MUST state prerequisites and mandatory relative-order constraints for the cleanup operations it declares. The Stable Proxy module's factory MUST reconcile those constraints, choose a deterministic tie-breaker for otherwise independent eligible operations, and record the resulting total order in private construction-time configuration. Composition wiring supplies the dependencies but does not select operation ordering. Implementation-dependent ordering is prohibited. Failure aggregation MUST follow execution order. This ordering requirement applies to delegate cleanup during replacement, rollback, retry, and final shutdown; the requirement to continue with independent eligible operations and maintain pending retry state applies only to replacement and retry, while shutdown continuation follows Section 3.4. During initial replacement cleanup and each retry, the Stable Proxy MUST attempt every pending cleanup operation whose prerequisites have succeeded, in the defined dependency order. A failed operation MUST NOT prevent attempts of independent eligible operations; operations whose prerequisite cleanup remains pending MUST remain unattempted. Only failures from attempted operations MUST be surfaced and aggregated; unattempted operations remain pending but are not failures in that invocation. Failed operations remain pending. Successful cleanup steps MUST be recorded and MUST NOT be repeated. A cleanup operation with multiple steps MUST track completion of each step. Any cleanup step that may fail during replacement, rollback, retry, or final shutdown MUST be idempotent or provide a reliable completion check. An uncertain step remains pending and MAY be retried only when one of those conditions makes retry safe; a step known to have succeeded MUST NOT be repeated. If retrying cleanup of the current delegate succeeds while a candidate is pending, the Stable Proxy MUST assign that candidate as current and clear the pending replacement. If retrying rollback after failed preparation succeeds, the candidate MUST be discarded, the current delegate MUST remain unchanged, and the pending cleanup state MUST be cleared. No new replacement MAY begin while cleanup remains pending. Throughout this Section, “cleanup failure” means the single error or aggregate produced by cleanup operations attempted in one cleanup attempt. Failures from operations not attempted in that invocation are not included; previously stored failures are included only when an applicable rule explicitly requires them to be propagated. Whenever multiple failures occur during one invocation of replacement or `retryPendingCleanup`, that invocation MUST surface all failures arising during it in one error. If preparation fails, the preparation failure MUST be identified as primary, followed by rollback failures in cleanup execution order. Otherwise, the first failure encountered MUST be primary, followed by subsequent cleanup failures in cleanup execution order. An `AggregateError` or equivalent MAY be used. A cleanup failure does not end or transfer the Stable Proxy's cleanup obligation; the Proxy MUST retain private handles to unreleased resources until cleanup succeeds. After candidate custody transfers to the Stable Proxy, it MUST NOT be transferred to another component during the replacement operation. If cleanup of the current delegate fails, the Stable Proxy retains that reference but does not guarantee that the delegate remains operational.
9. A Stable Proxy MUST be treated as a stable behavioural handle, not as a garbage-collection or memory-management mechanism.
10. The replaceable-collaborator arrangement described in this Section—separate Contract, Concrete implementations, and a Null Object or Stable Proxy when required—MUST NOT be introduced solely by default when there is no requirement in the collaborator Contract or demonstrated current consumer use for replacement, expected absence, or stable consumer identity. This does not restrict classifying or using an otherwise necessary Concrete implementation under Section 5.1. Any such requirement established by current use MUST be added to the Contract, with all affected consumers updated in the same coherent change.

This role arrangement protects retained Stable Proxy references from stale delegate behaviour. It cannot repair a reference to a Concrete implementation that escaped its ownership boundary.

### Section 5.7: Vertical module Contracts

1. Every vertical module MUST expose and designate exactly one primary behavioural Contract as a TypeScript interface. The primary designation identifies the module's principal capability for documentation and organization only; it creates no preferential import, export, or composition behavior. A shared infrastructure module consumed by another module MUST expose a Contract interface.
2. A vertical module MAY expose additional Contract interfaces only when distinct consumer capabilities independently require them.
3. A module's public entry point MUST NOT export Concrete implementations or helpers. It MAY export DTO classes or other named data types only when they are required by public Contract signatures.
4. Contract methods MUST describe the module's capability in domain terms. They MUST NOT mirror transport or persistence details or expose generic CRUD solely as a technical convenience. CRUD operations MAY appear when they are genuine domain operations.
5. A change to a module Contract MUST update all affected consumers in the same coherent change. A module MUST NOT retain compatibility behaviour solely for hypothetical future consumers.

## Article 6: Nullability and Strict Typing

### Section 6.1: Domain nullability

Application-domain contracts MUST NOT use `null` or `undefined` to represent absence. They MUST use a Null Object or a non-null domain result type that makes the absent case explicit in the Contract's declared type, such as a named union of DTO-class variants or a dedicated result DTO. Object-shaped variants in a Contract result type MUST be DTO classes under Section 5.1; non-DTO object-literal variants MUST NOT be used. An implementation-private sentinel does not qualify as an explicit domain representation. A Contract MAY declare an optional parameter only when omission means a specified default behavior, not domain absence; the Contract MUST state that behavior. An explicit `undefined` supplied for that parameter MUST have the same defaulting behavior as omission and MUST NOT represent domain absence. The documentation comment attached to the method signature MUST state the default behavior separately for each optional parameter.

The `void` return type is permitted for commands and does not represent a nullable domain value.

### Section 6.2: Boundary values

Boundary adapters MAY receive `null` or `undefined` when required by a platform, third-party, or external API. They MUST translate or reject every such value before it enters an application-domain Contract, except `undefined` supplied to an optional parameter whose default behavior is documented under Section 6.1.

External input MUST be validated or translated at its boundary before strict DTO classes are constructed. DTO constructors MAY repeat intrinsic validation needed to protect the instance. DTO classes MAY carry input or output data in Contract signatures; a DTO is not itself a behavioural Contract and MUST NOT replace boundary or application-rule validation.

### Section 6.3: Null Object pattern

A Null Object MUST implement the same contract as the object it represents. It MUST provide safe, explicit behaviour for the absent case and MUST NOT require callers to add repeated null checks.

A Null Object MUST NOT conceal an unexpected failure or replace fail-fast handling of an invalid state.

### Section 6.4: Strict typing

Types MUST be explicit and narrow. Invalid states MUST be represented by a failure, a dedicated object, or a valid contract rather than hidden by a defensive fallback.

## Article 7: DOM and CSS Selectors

### Section 7.1: Selector separation

JavaScript behaviour hooks and CSS styling classes MUST remain separate concerns.

**Invalid example:** TypeScript MUST NOT query a styling class; behaviour selectors must use the `js-` prefix.

```ts
const customerInputSelector = '.customer-input';
const customerInput = document.querySelector(customerInputSelector);
```

**Good**

```ts
const customerInputBehaviourSelector = '.js-customer-input';
const customerInput = document.querySelector(customerInputBehaviourSelector);
```

### Section 7.2: Behaviour selectors

Every query selector used by TypeScript MUST select elements through a class whose name starts with `js-`. A selector MAY also include an ID, attribute, element name, or other selector component, but it MUST include a `js-` behaviour class as its hook. The `js-` behaviour class MUST NOT have CSS style rules. Styling classes MUST NOT be used as JavaScript dependencies.

## Article 8: Constitutional Maintenance

### Section 8.1: Enforcement

Code reviews MUST treat every MUST and MUST NOT rule as binding. A reviewer MAY request a refactor when names, structure, types, or method bodies technically compile but violate the constitutional intent.

Where project tooling can enforce production module-import boundaries, the project MUST configure it to reject production imports from another module's private space and composition entry point outside the composition root. If no available tooling can enforce a boundary, code review MUST enforce it. The absence of an automated check MUST NOT make a module-boundary violation permissible.

A composition or integration test that exercises module assembly MAY import composition entry points to test the composition root; it MUST NOT import another module's private implementation. A test is owned by the single module whose private implementation it is designated to exercise. A test owned by a module MAY exercise that module's private implementation, but MUST NOT import another module's private implementation. Whenever a test exercises any other module as a consumer, it MUST use that module's public Contract and MUST NOT import its private implementation. Private symbols MUST NOT be exported solely for testing.

