---
name: test-ui
description: "Interactive browser testing via Playwright MCP. Navigates the live app, tests every screen, flow, and viewport — then generates permanent .spec.ts test files."
user_invocable: true
---

Arguments: $FEATURE (or "all" to test entire app)

Read CLAUDE.md before doing anything else.
Read docs/PRD.md for acceptance criteria.
Read docs/SCREENS.md for the full screen inventory.
If wireframes/ exists, read wireframes/INDEX.html for expected layouts.

PREREQUISITE CHECK:
  1. Confirm the dev server is running (if not, start it)
  2. Confirm Playwright MCP is available (browser_navigate tool exists)
  3. If $FEATURE is specified, identify every screen and flow for that feature
  4. If "all", use docs/SCREENS.md as the full checklist

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 1 — SCREEN-BY-SCREEN VISUAL WALKTHROUGH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For EVERY screen listed in docs/SCREENS.md (or the feature subset):

  1. browser_navigate to the screen's URL
  2. browser_take_screenshot — save as qa/browser-tests/$FEATURE/[screen]-initial.png
  3. browser_snapshot — capture the accessibility tree
  4. VERIFY against the wireframe or PRD:
     - Are all expected elements present? (buttons, inputs, links, text)
     - Is the layout correct? (sidebar on left, header at top, etc.)
     - Are labels and text content correct?
     - Is the navigation functional? (links go where they should)
  5. Log findings to qa/browser-tests/$FEATURE/walkthrough.md:
     | Screen | URL | Status | Missing Elements | Layout Issues | Notes |

DO NOT SKIP SCREENS. Every screen in the inventory must be visited.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 2 — INTERACTION TESTING (every clickable element)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For EVERY screen, systematically test every interactive element:

  BUTTONS:
    - browser_click every button on the page
    - Verify: correct action happens (navigation, modal, form submit, state change)
    - Verify: button is visible, has accessible name, is not disabled unexpectedly

  FORMS:
    - browser_type into every input field
    - Test valid data → verify success state
    - Test empty submission → verify validation messages appear
    - Test invalid data (wrong format, too long, special characters) → verify error handling
    - Test form reset / cancel

  NAVIGATION:
    - browser_click every link
    - Verify: correct destination screen loads
    - browser_navigate_back → verify you return to the previous screen
    - browser_navigate_forward → verify forward works

  DROPDOWNS / SELECT:
    - browser_select_option for each dropdown
    - Verify: correct option selected, dependent UI updates

  MODALS / OVERLAYS:
    - Trigger every modal (click the button that opens it)
    - Verify: modal appears with correct content
    - browser_press_key Escape → verify modal closes
    - Click outside modal → verify it closes (if designed to)
    - Test modal form submission

  KEYBOARD NAVIGATION:
    - browser_press_key Tab through the entire page
    - Verify: focus order is logical (top to bottom, left to right)
    - Verify: all interactive elements receive focus
    - browser_press_key Enter on focused buttons → verify they activate
    - browser_press_key Space on checkboxes → verify they toggle

  Log every interaction result to qa/browser-tests/$FEATURE/interactions.md:
    | Element | Action | Expected Result | Actual Result | Pass/Fail |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 3 — HAPPY PATH END-TO-END FLOWS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Read the P0 Happy Path from docs/PRD.md. For EACH Given/When/Then:

  1. Navigate to the starting point
  2. Execute the exact user journey described:
     - browser_type to fill forms
     - browser_click to submit / navigate
     - browser_wait_for expected outcomes
  3. browser_take_screenshot at each step
  4. Verify the "Then" condition is met:
     - browser_verify_text_visible for expected messages
     - browser_verify_element_visible for expected UI changes
     - browser_snapshot to confirm state changes in the a11y tree
  5. Save screenshots as flow sequence:
     qa/browser-tests/$FEATURE/flow-[name]-step-[N].png

  ALSO TEST THESE VARIANTS OF EACH HAPPY PATH:
  - What happens if the user refreshes mid-flow?
  - What happens if the user navigates away and comes back?
  - What happens with the minimum valid input?
  - What happens with the maximum valid input?

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 4 — EMPTY STATES & ERROR STATES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EMPTY STATES (for every screen that displays a list or data):
  1. Navigate to the screen with no data (new user or cleared state)
  2. browser_take_screenshot
  3. Verify: helpful empty state message is shown (not a blank page or error)
  4. Verify: there is a clear call-to-action to add first item
  5. browser_click the CTA → verify it works

ERROR STATES:
  1. Network error: Use browser_evaluate to intercept fetch and simulate offline
     ```javascript
     window.__originalFetch = window.fetch;
     window.fetch = () => Promise.reject(new Error('Network error'));
     ```
  2. Trigger an action that requires network → verify graceful error message
  3. Restore network:
     ```javascript
     window.fetch = window.__originalFetch;
     ```
  4. Server error: Use browser_evaluate to mock 500 responses
  5. Auth error: Navigate to a protected route without auth → verify redirect to login

  browser_take_screenshot for every error state.
  Verify: no raw error messages, stack traces, or blank screens shown to user.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 5 — RESPONSIVE TESTING (3 viewports)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For the 3 most important screens (identified from PRD P0 features):

  DESKTOP (1440 × 900):
    browser_resize width=1440 height=900
    Navigate to each screen
    browser_take_screenshot → qa/browser-tests/$FEATURE/responsive/[screen]-desktop.png
    browser_snapshot → verify all elements visible
    Verify: layout uses full width appropriately

  TABLET (768 × 1024):
    browser_resize width=768 height=1024
    Navigate to each screen
    browser_take_screenshot → qa/browser-tests/$FEATURE/responsive/[screen]-tablet.png
    browser_snapshot → verify all elements still accessible
    Verify: navigation adapts (hamburger menu if applicable)
    Verify: no horizontal scrollbar
    Verify: text is readable, buttons are tappable size (≥44px)

  MOBILE (375 × 812):
    browser_resize width=375 height=812
    Navigate to each screen
    browser_take_screenshot → qa/browser-tests/$FEATURE/responsive/[screen]-mobile.png
    browser_snapshot → verify all elements still accessible
    Verify: no content cut off or overlapping
    Verify: forms are usable (inputs full-width, keyboard doesn't obscure)
    Verify: touch targets are ≥44px
    Test the happy path on mobile — complete the main flow at this viewport

  ALSO CHECK:
    - Landscape mobile (812 × 375): browser_resize and screenshot
    - Very narrow (320px): browser_resize width=320 and check nothing breaks

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 6 — ACCESSIBILITY AUDIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For EVERY screen:

  1. browser_snapshot — capture the full accessibility tree
  2. Analyze the tree for:
     - Every image must have alt text (or role="presentation" if decorative)
     - Every form input must have an associated label
     - Every button must have an accessible name
     - Heading hierarchy must be logical (h1 → h2 → h3, no skipping)
     - Color contrast: if design tokens exist, verify text/background ratios
     - ARIA roles are used correctly (not aria-label on divs that should be buttons)
     - Focus indicators are visible (Tab through and verify)

  3. Log accessibility findings to qa/browser-tests/$FEATURE/accessibility.md:
     | Screen | Issue | Severity | Element | Recommendation |

  Severity levels:
    CRITICAL — screen reader users cannot complete the task
    MAJOR    — significantly degraded experience for assistive tech users
    MINOR    — best practice violation, not blocking

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 7 — CONSOLE & NETWORK HEALTH CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

While on each screen during testing:

  browser_console_messages — check for:
    - Any JavaScript errors (red) → log as bugs
    - Any unhandled promise rejections → log as bugs
    - Deprecation warnings → log as technical debt
    - Any sensitive data logged to console → log as security issue

  browser_network_requests — check for:
    - Any failed requests (4xx, 5xx) → log as bugs
    - Any requests to unexpected domains → log as security concern
    - Any excessively large responses (>1MB for API calls) → log as performance issue
    - Any requests without proper auth headers when auth is required

  Save to: qa/browser-tests/$FEATURE/health.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 8 — AUTO-GENERATE PLAYWRIGHT TEST FILES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

THIS IS THE KEY STEP. Convert every interaction you just tested into
permanent, repeatable Playwright test files.

For each flow and interaction tested above:

  1. Use browser_generate_playwright_test to create a .spec.ts file
     from the browser session

  2. If the generated test needs refinement, manually write it using
     the selectors discovered via browser_snapshot and browser_generate_locator

  3. Save generated tests to:
     tests/e2e/$FEATURE-ui.spec.ts          — happy path + interaction tests
     tests/e2e/$FEATURE-responsive.spec.ts  — responsive viewport tests
     tests/e2e/$FEATURE-a11y.spec.ts        — accessibility assertions
     tests/e2e/$FEATURE-errors.spec.ts      — error state tests

  4. EVERY test must use semantic locators only:
     ALLOWED:   getByRole('button', { name: 'Submit' })
     ALLOWED:   getByLabel('Email')
     ALLOWED:   getByText('Welcome back')
     ALLOWED:   getByTestId('transaction-list')
     FORBIDDEN: page.$('.class-name')
     FORBIDDEN: page.$('#id')
     FORBIDDEN: page.$x('//xpath')

  5. Run every generated test:
     npx playwright test tests/e2e/$FEATURE-ui.spec.ts
     npx playwright test tests/e2e/$FEATURE-responsive.spec.ts
     npx playwright test tests/e2e/$FEATURE-a11y.spec.ts
     npx playwright test tests/e2e/$FEATURE-errors.spec.ts

  6. Fix any failing tests — the test should pass since you just
     verified the behavior interactively. If it fails:
     - Selector issue → use browser_generate_locator to find stable selector
     - Timing issue → add proper await and toBeVisible() waits
     - Real bug → log to qa/bugs/

  7. Run the FULL test suite to confirm nothing else broke:
     npx playwright test

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 9 — COVERAGE REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Generate qa/browser-tests/$FEATURE/REPORT.md:

  ## UI Test Report: $FEATURE
  Generated: [date]

  ### Summary
  | Metric                  | Count | Pass | Fail |
  |-------------------------|-------|------|------|
  | Screens tested          |       |      |      |
  | Interactive elements    |       |      |      |
  | Happy path flows        |       |      |      |
  | Empty states            |       |      |      |
  | Error states            |       |      |      |
  | Responsive viewports    |       |      |      |
  | Accessibility issues    |       |      |      |
  | Console errors found    |       |      |      |
  | Tests generated         |       |      |      |
  | Tests passing           |       |      |      |

  ### Generated Test Files
  - tests/e2e/$FEATURE-ui.spec.ts ([N] tests)
  - tests/e2e/$FEATURE-responsive.spec.ts ([N] tests)
  - tests/e2e/$FEATURE-a11y.spec.ts ([N] tests)
  - tests/e2e/$FEATURE-errors.spec.ts ([N] tests)

  ### Issues Found
  [List every bug, accessibility issue, or UI problem discovered]

  ### Screenshots
  [Reference all screenshots taken during testing]

  ### Coverage Assessment
  - Screens with 100% element coverage: [list]
  - Screens with gaps: [list with what's missing]
  - Flows fully tested: [list]
  - Flows partially tested: [list with what's missing]

━━━ FINAL OUTPUT ━━━

If all tests pass:
  "UI testing complete for $FEATURE.
   [N] screens tested, [N] interactions verified, [N] test files generated.
   All [N] generated Playwright tests passing.
   Report: qa/browser-tests/$FEATURE/REPORT.md
   Next: run /qa-run $FEATURE for the full QA loop."

If issues found:
  "UI testing complete for $FEATURE.
   Found [N] bugs, [N] accessibility issues, [N] console errors.
   [N] tests generated, [N] passing, [N] failing.
   Report: qa/browser-tests/$FEATURE/REPORT.md
   Fix issues first, then run /qa-run $FEATURE."
