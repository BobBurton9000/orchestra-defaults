---
name: writing-typescript
description: The TypeScript Constitution for this project. Use when writing, modifying, or reviewing TypeScript code.
---
# TypeScript Constitution

## Preamble

This Constitution establishes the TypeScript standards. It exists to
make code understandable at the point of use, keep application contracts strict,
and make invalid states visible rather than hidden.

The rules apply when writing, modifying, or reviewing TypeScript code. The
examples are illustrative. The normative statements are authoritative.

## Article 1: Constitutional Language

### Section 1.1: Normative terms

- **MUST** and **MUST NOT** are binding requirements.
- **SHOULD** and **SHOULD NOT** are the default position and may be departed from only for a stated technical reason.
- **MAY** identifies a permitted choice.

### Section 1.2: Constitutional interpretation

These rules MUST be applied according to their stated intent, not bypassed by
changing a name while retaining the same unclear design. Convenience alone is
not a sufficient reason to depart from a MUST or MUST NOT rule.

## Article 2: Names

### Section 2.1: Specific names

Identifiers MUST be specific enough to communicate their value or intent at the
point of use. Unnecessary abbreviations MUST NOT be used.

**Bad**

```ts
const col = 3;
```

**Good**

```ts
const columnIndex = 3;
```

### Section 2.2: Boolean names

A question-shaped predicate is a Boolean name that states a yes-or-no
proposition in the name itself. It MUST remain understandable without an
enclosing condition or other call-site context.

Boolean variables, parameters, properties, and query methods MUST be named as
question-shaped predicates.

Boolean names MUST NOT be bare action verbs or third-person action phrases that
require an auxiliary verb to become a yes-or-no question.

**Bad**

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

Predicate prefixes such as `is`, `has`, `can`, and `should` are question forms
when they accurately describe the proposition.

### Section 2.3: Queries

A query produces a value or predicate. A query MAY update private instance state
or lazily initialise a collaborator within the instance's owning composition or
lifecycle boundary when that work is required to produce the returned value.
A query MUST NOT mutate authoritative Simulation state, enforce application
rules, or allow a Concrete delegate to escape its owning boundary.

Query methods MUST use nouns, noun phrases, question-shaped predicates, or
`<value>From<source>` constructions. Query methods MUST NOT use command verbs or
the accessor prefix `get`.

Private lazy accessor methods MUST use ordinary method syntax and MUST NOT use
JavaScript getter or setter syntax.

**Bad**

```ts
private parseMultipartSection(section: string): MultipartSection
private getCurrentUser(): User
```

**Good**

```ts
private multipartSectionFromString(section: string): MultipartSection
private currentUser(): User
```

A permitted private lazy accessor method MAY initialise an owned collaborator
before returning it:

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

A command changes state, performs input/output, or triggers an effect. A command
MUST use an imperative verb that describes its effect.

`set` is a valid command verb, but it is not the only permitted command verb.
Commands MAY return `void`, `this`, or an operation result. The return type does
not determine whether a function is a query or a command.

Persistent state-transition methods that return a new instance without mutating
the receiver MUST use the `with<Property>` naming form, where `<Property>`
identifies the changed state property. They MUST declare an explicit return type
that accurately describes the new instance. The return type MAY be `this` when
the method preserves the receiver's subtype. These methods MUST leave the
receiver unchanged and are commands despite the `with` prefix.

**Good**

```ts
private setAttributes(): void {
    if (isInvalid) {
        input.setAttribute('aria-describedby', 'signup-error');
        return;
    }
    input.removeAttribute('aria-describedby');
}
```

### Section 2.5: Variable scope and mutability

Variables MUST be declared at the narrowest scope that contains every use.
A variable used by only one function MUST be declared within that function.
A value used across methods MUST be placed at the boundary that owns the value.
Class-owned values MUST remain private instance properties. Module-level values
MUST have a deliberate module-level purpose and MUST NOT be introduced solely to
name a value used by one function.

Local bindings MUST use `const` when the binding is not reassigned and MUST use
`let` when the binding is reassigned. A private instance property MUST use
`readonly` when it is not reassigned after construction and MAY remain mutable
when the owning class changes its value.

### Section 2.6: Contract names

`Contract` is a type classification, not a naming suffix. Contract interfaces
are the first-class descriptions of the behaviour they represent. Interface
names MUST describe the capability, role, or domain concept they represent.
Interface names MUST NOT end in `Contract` solely to identify their
classification. The suffix MAY be used when `Contract` is part of the actual
domain concept.

**Bad**

```ts
interface PuffballRepositoryContract {
    snapshots(): ReadonlyArray<PuffballSnapshot>;
}
```

**Good**

```ts
interface PuffballRepository {
    snapshots(): ReadonlyArray<PuffballSnapshot>;
}
```

## Article 3: Function Bodies

### Section 3.1: Guard clauses

Function bodies MUST NOT use `else`. Guard clauses and early returns MUST be
used so that the happy path falls through.

**Bad**

```ts
private setAttributes(): void {
    if (isInvalid) {
        input.setAttribute('aria-describedby', 'signup-error');
    } else {
        input.removeAttribute('aria-describedby');
    }
}
```

**Good**

```ts
private setAttributes(): void {
    if (isInvalid) {
        input.setAttribute('aria-describedby', 'signup-error');
        return;
    }
    input.removeAttribute('aria-describedby');
}
```

### Section 3.2: Function continuity

Function bodies MUST NOT contain empty lines. This is a constitutional
structural principle, not a formatter preference. Adjacent function and method
definitions MUST be separated by exactly one empty line. Related steps belong in
named functions when the body would otherwise become difficult to follow.

### Section 3.3: Self-documenting bodies

Function bodies MUST communicate their intent through names and structure.
Inline comments MUST NOT appear in function bodies. Extract a named function or
variable when it makes the intent clearer.

**Bad**

```ts
function assetPath(originalPath: string): string {
    // Fallback for development or missing manifest
    return originalPath.startsWith('/') ? originalPath : `/static/${originalPath}`;
}
```

**Good**

```ts
function assetPath(originalPath: string): string {
    const fallbackAssetPathForDevelopment = originalPath.startsWith('/') ? originalPath : `/static/${originalPath}`;
    return fallbackAssetPathForDevelopment;
}
```

### Section 3.4: Fail-fast behaviour

Code MUST fail fast when a required invariant is violated. It MUST NOT swallow
errors, log and continue, or invent fallback values merely to avoid failure.

Deliberate Null Objects and explicit normalisation of platform values at a
boundary are not defensive fallbacks when they are part of the declared
contract.

### Section 3.5: Constructor effects

Constructors MUST only validate their arguments and initialise state owned exclusively by the instance under construction. DTO constructors MAY validate intrinsic values, but MUST NOT replace validation of external input, application rules, or relationships between objects.

Constructors MUST NOT cause externally observable effects, including interaction with the DOM, a framework, global state, or a supplied collaborator; input/output; resource acquisition; resource release; or event registration.

External setup MUST be performed after construction by an explicitly named instance command, composition code, or a compliant private lazy accessor method. Constructors MUST NOT invoke a lazy accessor or trigger its setup indirectly.

### Section 3.6: Function parameter layout

Function-like declarations and signatures with two or more parameters MUST
place each parameter on its own line. The first parameter MUST start on a line
after the opening parenthesis, and the closing parenthesis MUST start on a line
after the final parameter.

**Bad**

```ts
function move(horizontalOffset: number, verticalOffset: number): void {
    return;
}
```

**Good**

```ts
function move(
    horizontalOffset: number,
    verticalOffset: number
): void {
    return;
}
```

## Article 4: Composition and Data Structures

### Section 4.1: Composition over inheritance

Inheritance MUST NOT be used. Behaviour MUST be composed from collaborators and
contracts.

**Bad**

```ts
class LoginValidation extends BaseValidator {
}
```

**Good**

```ts
class LoginValidation implements Validator {
}
```

Inheritance creates coupling between implementation details. Composition keeps
contracts explicit and collaborators replaceable.

### Section 4.2: Structured data

Arrays MAY represent homogeneous collections. Arrays MUST NOT be used as
implicit records or positional DTOs.

Multi-dimensional arrays SHOULD NOT model named domain data. A class, interface,
or other named structure MUST be used when the positions have distinct meaning.

### Section 4.3: Literal values

Magic strings, repeated string literals, and magic numbers MUST NOT be used.
They MUST be given a named variable or constant whose name expresses their
meaning.

### Section 4.4: Static class members

Classes MUST NOT declare static fields, static methods, or static initialisation blocks. Shared behaviour MUST use module-level composition or instance collaborators.

## Article 5: Contracts and DTOs

### Section 5.1: Classification

Every interface MUST be classified as a `Contract`. Every DTO MUST be a class. Every class
MUST be classified as either a `Contract` or a `DTO`; there is no third
classification.

A `Contract` is a first-class description of behaviour. A DTO carries data in
private instance state.

### Section 5.2: Contract interfaces

Contract interfaces MAY declare method signatures. Their methods are public by
definition. They MUST contain method signatures only. They MUST NOT declare
properties, index signatures, call signatures, or construct signatures.

Property and parameter type annotations MUST NOT use intersection types. A
combined Contract requirement MUST be represented by a named Contract interface
that extends its required Contracts. This restriction does not apply to return
or local-variable type annotations.

### Section 5.3: Contract classes

Contract classes MAY declare public methods and commands. Their instance
properties MUST be private. They MUST expose state through ordinary public
methods when access is required, not public properties or JavaScript
getter/setter syntax. Contract classes MAY mutate their private state when the
mutation is part of their Contract, but they MUST NOT take ownership of rules
that belong to another boundary.

**Bad**

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

DTOs MUST be classes with private instance properties and public constructors.
They MUST expose data through ordinary public query methods. DTO methods MUST
NOT enforce application rules, mutate Simulation state, or perform external
effects. DTO constructors MAY validate intrinsic values and initialise or freeze
state owned by the new instance, but MUST NOT perform external effects.

DTO query methods MUST use nouns, noun phrases, question-shaped predicates, or
`<value>From<source>` constructions. DTOs MUST NOT use public properties or
JavaScript getter/setter syntax. Nested DTO values and collections MUST remain
immutable when a DTO is published as a read model.

**Good**

```ts
export class LoginDto {
    private readonly loginEmail: string;
    private readonly loginPassword: string;

    public constructor(email: string, password: string) {
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

Every class method and property MUST declare explicit visibility. Class instance
properties MUST be private; public and protected properties are prohibited.
Constructor parameter properties MUST NOT be used; fields MUST be declared
explicitly as private members. Private members MUST use standard camelCase
without a leading underscore; the `private` modifier communicates visibility.
Interface members are public by definition and MUST NOT use class visibility
modifiers.

### Section 5.6: Replaceable Collaborator Roles

A replaceable collaborator is a Contract-backed object whose implementation may
change while its consumers retain references.

A Concrete implementation provides active behaviour for a Contract.

A Stable Proxy is a Contract implementation whose identity remains stable while
it delegates operations to a current implementation.

The current implementation held by a Stable Proxy is its delegate.

1. A replaceable collaborator MUST expose a Contract separate from its Concrete implementations.
2. A replaceable collaborator MAY have multiple Concrete implementations.
3. A Null Object MUST be provided when absence or inactivity is an expected state.
4. When consumers MAY retain references while the implementation changes, composition MUST distribute a Stable Proxy rather than a Concrete implementation.
5. A Stable Proxy MUST preserve its identity and delegate each Contract operation to its current delegate.
6. A Concrete delegate MUST NOT escape its owning composition or lifecycle boundary through consumers, callbacks, cleanup owners, getters, or public mutable state.
7. A Stable Proxy that supports replacement MUST expose replacement through an explicit owner-facing Contract or command. An ordinary consumer Contract MUST NOT expose that command.
8. Delegate replacement MUST define ownership and cleanup semantics. If replacement or required cleanup fails, the Stable Proxy MUST retain its current delegate and propagate the failure.
9. A Stable Proxy MUST be treated as a stable behavioural handle, not as a garbage-collection or memory-management mechanism.
10. The Concrete, Null Object, and Stable Proxy arrangement MUST NOT be introduced solely by default when replacement, expected absence, or stable consumer identity is not part of the collaborator Contract.

This role arrangement protects retained Stable Proxy references from stale
delegate behaviour. It cannot repair a reference to a Concrete implementation
that escaped its ownership boundary.

## Article 6: Nullability and Strict Typing

### Section 6.1: Domain nullability

Application-domain contracts MUST NOT use `null` or `undefined` to represent
absence. They MUST use a Null Object or another explicit domain representation.

The `void` return type is permitted for commands and does not represent a
nullable domain value.

### Section 6.2: Boundary values

Boundary adapters MAY receive `null` or `undefined` when required by a platform,
third-party, or external API. They MUST handle or translate that value before it
enters a strict application-domain contract.

External input MUST be validated or translated at its boundary before strict DTO
classes are constructed. DTO constructors MAY repeat intrinsic validation needed
to protect the instance, but DTOs MUST NOT be used as domain contracts or as a
replacement for boundary and application-rule validation.

### Section 6.3: Null Object pattern

A Null Object MUST implement the same contract as the object it represents. It
MUST provide safe, explicit behaviour for the absent case and MUST NOT require
callers to add repeated null checks.

A Null Object MUST NOT conceal an unexpected failure or replace fail-fast
handling of an invalid state.

### Section 6.4: Strict typing

Types MUST be explicit and narrow. Invalid states MUST be represented by a
failure, a dedicated object, or a valid contract rather than hidden by a
defensive fallback.

## Article 7: DOM and CSS Selectors

### Section 7.1: Selector separation

JavaScript selectors and CSS classes MUST remain separate concerns.

**Bad**

```ts
const customerInput = document.querySelector('.customer-input');
```

**Good**

```ts
const customerInput = document.querySelector('.js-customer-input');
```

### Section 7.2: Behaviour selectors

Selectors prefixed with `js-` MUST NOT have CSS style rules. They exist only for
behaviour selection.

Selectors without a `js-` prefix MUST NOT be used as query selectors in
TypeScript. Styling classes MUST NOT be used as JavaScript dependencies.

## Article 8: Constitutional Maintenance

### Section 8.1: Enforcement

Code reviews MUST treat every MUST and MUST NOT rule as binding. A reviewer MAY
request a refactor when names, structure, types, or method bodies technically
compile but violate the constitutional intent.

