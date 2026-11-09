---
name: when-to-mock
description: Guides decisions about mocks and test doubles, keeping them at system boundaries and designing external dependencies for straightforward testing. Use when writing or reviewing tests, choosing test doubles, or designing code for testability.
---

# When to Mock

Use mocks and other test doubles at **system boundaries**: places where the application interacts with something outside its control. Keep the application's own code real in tests wherever practical. The goal is to isolate external effects without making tests depend on, or reproduce, the implementation's internal structure.

## Mock at System Boundaries

Boundary dependencies that may be replaced by a test double include:

- External APIs and services, such as payment providers, email services, and third-party platforms.
- Databases when using a real isolated test database is impractical; prefer a test database when it is available and suitable.
- Time and randomness, so tests can control the current instant or generated values.
- The file system when direct file-system use is unsuitable for the test; prefer temporary directories for tests of real file behaviour when practical.

Choose a test double only when it helps verify the behaviour under test or control an external effect. A boundary can also be tested against a real implementation or an isolated service when that gives better evidence.

## Keep Internal Code Real

Do not mock your own classes or modules, internal collaborators, or other code the project controls merely to make a test easier to arrange. Avoid replacing internal behaviour with expectations about method calls: that couples tests to implementation details and can let collaborating code be broken while tests still pass.

Prefer testing observable behaviour through the feature's public boundary, using real internal collaborators. If a test is difficult to write without mocking internal code, reconsider the test boundary or the production dependency design instead of adding more mocks.

## Design Boundary Dependencies for Mockability

### Inject external dependencies

Pass external dependencies into the code that uses them instead of constructing them internally. This makes the system boundary explicit and lets a test substitute the dependency without patching globals or reaching into implementation details.

**Easy to substitute:**

```typescript
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}
```

**Hard to substitute:**

```typescript
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

Construct and configure the real external client at the composition boundary, then inject it into the code that needs it. Keep dependency injection focused on actual system boundaries; do not introduce interfaces or wrappers solely to make internal classes mockable.

### Prefer operation-specific interfaces to generic fetchers

Expose a specific operation for each external action instead of one generic function whose behaviour depends on endpoint strings and options. Operation-specific functions make each dependency call and its result shape explicit.

**Good: each operation is independently substitutable:**

```typescript
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};
```

**Avoid: a generic fetcher that makes the test double interpret requests:**

```typescript
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

An operation-specific client or SDK-style interface means:

- Each test double operation returns one specific result shape.
- Test setup does not need endpoint- or option-dependent conditional logic.
- Tests show which external operations they exercise.
- Each operation can have a precise type and contract.

Keep the implementation that translates these operations into HTTP, SDK, or database calls at the external adapter. Test that adapter separately at its boundary; do not make application tests duplicate its routing or transport logic in mock setup.

## Test Design Checklist

When choosing a mock or other test double:

1. Identify the system boundary and the external effect or nondeterminism the test must control.
2. Keep project-owned behaviour real, unless a separately defined boundary is itself under test.
3. Prefer an isolated real service, test database, or temporary file system when it provides suitable evidence without undue cost.
4. Give the dependency a specific operation and result shape rather than a generic conditional interface.
5. Assert the application's observable result; assert a boundary call only when that interaction is part of the behaviour being verified.
