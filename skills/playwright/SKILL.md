---
name: playwright
description: Provides guidance on using browser automation for testing, bug replication, and UI verification in Tiffy. Use when automating browser interactions, testing web features, reproducing UI issues, or validating behaviour in the running app.
---

# Using Playwright

## Purpose
This skill provides project-specific guidance for browser automation in Tiffy. It focuses on how to approach UI testing, bug reproduction, and verification work in a reliable way without depending on one exact tooling surface.

## When to Use
- Automated browser testing of features
- Bug replication and verification
- UI behaviour validation
- Screenshot capture for documentation or evidence
- Form submission testing
- Navigation and interaction testing
- Responsive layout checks
- Console and network investigation during browser-driven flows

## Working Approach
Use the browser automation tools available in the current environment to:
- open the application and navigate between pages
- interact with controls and submit forms
- wait for the UI to reach a stable state before acting
- capture screenshots or other evidence
- inspect browser console output and network activity when debugging

Prefer intent-driven workflows over tool-specific scripts. The important part is the sequence: establish a known state, perform the action, verify the outcome, and capture evidence.

## Test Credentials

### Default Test Account
For testing authenticated features, use these credentials:

- **Email**: `bob@bob.com`
- **Password**: `bob`

**Security Note**: These are development credentials only. Never use production credentials or commit sensitive values.

## Application Access

### Local Development
- **URL**: `http://localhost:3000`
- **Start Command**: `npm run dev`

### Before You Start
Before starting browser automation:
1. Ensure the application is running locally.
2. Verify the app is reachable in the browser.
3. Confirm the seeded test account works if the scenario requires authentication.

## Core Workflow Patterns

### Authentication
When a flow requires an authenticated user:
1. Navigate to the login page.
2. Wait until the form is visible and ready.
3. Enter `bob@bob.com` and `bob`.
4. Submit the form.
5. Wait for the post-login page or a visible success indicator.
6. Confirm the logged-in state before continuing.

### Screenshots and Evidence
When collecting evidence:
1. Navigate to the relevant page or state.
2. Wait for the UI to finish updating.
3. Capture a full-page screenshot or an element-focused screenshot as appropriate.
4. If useful, capture before-and-after states around the action under test.

### Form Testing
For data entry flows:
1. Navigate to the form page.
2. Wait for form controls to be interactive.
3. Populate required fields.
4. Capture the pre-submit state if needed.
5. Submit the form.
6. Wait for either the success path or validation errors.
7. Verify the expected result in the UI.

### Error Investigation
When diagnosing browser-visible issues:
1. Reproduce the issue from a clean, known state.
2. Capture the visible UI state.
3. Inspect console output for client-side errors.
4. Inspect network activity for failed or unexpected requests.
5. Record the precise step where the behaviour diverges from expectation.

## Selector Strategy

### Preferred Selector Order
1. Stable data attributes
2. IDs
3. Name attributes
4. Semantic input or button attributes
5. Visible text
6. CSS classes only when no better option exists

### Selector Principles
- Prefer selectors tied to meaning rather than presentation.
- Choose selectors that remain stable if styling changes.
- Avoid brittle deep DOM paths.
- Use the most specific selector that is still readable and resilient.

## Reliability Rules
- Wait for the UI to be ready before interacting.
- Prefer explicit waits for visible, enabled, or settled states.
- Start each scenario from a predictable state.
- Re-authenticate or reset session state when necessary.
- Verify success with observable signals, not assumptions.
- Capture evidence whenever the task is testing or debugging.
- Clean up browser sessions when the work is complete.

## Common Failure Modes

### Element Not Found
Likely causes:
- selector is wrong or too brittle
- the page has not finished rendering
- the element is conditionally hidden

Useful responses:
- capture the current page state
- verify the selector against the rendered UI
- add a stronger readiness check before interaction

### Timeout Waiting for UI
Likely causes:
- navigation did not complete as expected
- asynchronous rendering is still in progress
- a client-side error blocked the page from updating

Useful responses:
- confirm the current route or page state
- inspect console output
- inspect failed requests
- wait for a more meaningful readiness condition

### Click or Submit Has No Effect
Likely causes:
- the control is disabled or obscured
- the page is still loading
- the expected event handler did not attach

Useful responses:
- confirm the control is visible and enabled
- inspect console output
- verify whether a request was triggered
- check for inline validation blocking submission

### Authentication Fails
Likely causes:
- credentials were entered incorrectly
- the login form changed
- the server returned an auth or validation error

Useful responses:
- confirm `bob@bob.com` and `bob`
- verify the correct form fields are being used
- inspect the UI, console, and network activity together

## Common Application Pages

### Public Pages
- `/` - Home page
- `/login` - Login page
- `/signup` - Signup page

### Authenticated Pages
- `/dashboard` - Dashboard overview
- `/materials` - Materials management
- `/products` - Products management
- `/recipes` - Recipe management
- `/production` - Production tracking
- `/purchases` - Purchase orders

## Success Criteria
Successful browser automation work should result in:
- the application being reached successfully
- the intended interactions completing reliably
- authenticated flows using the seeded account when required
- evidence captured when relevant
- the expected UI outcome being verified explicitly
- browser-visible errors investigated when behaviour is wrong

## Verification Checklist
- [ ] The application was running and reachable.
- [ ] The test started from a known state.
- [ ] Authentication was completed when needed.
- [ ] UI readiness was checked before interactions.
- [ ] The expected outcome was verified explicitly.
- [ ] Evidence was captured when relevant.
- [ ] Console or network data was inspected when debugging.
- [ ] Browser resources were cleaned up afterwards.