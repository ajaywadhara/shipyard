---
name: qa-run
description: "8-agent QA loop: browser exploration via Playwright MCP, then analyze, plan, test, audit, heal, expand, snapshot. Quality gate score >= 85 to pass."
user_invocable: true
---

Arguments: $FEATURE (or "all" for entire suite)

Read CLAUDE.md before doing anything else.
Ensure the dev server is running before proceeding.

━━━ BROWSER AGENT (Playwright MCP — runs first) ━━━

Before writing ANY test file, explore the live application using Playwright MCP.
This is non-negotiable for web applications. You MUST see the real app first.

STEP A — NAVIGATE EVERY SCREEN:
  For each screen related to $FEATURE:
    1. browser_navigate to the screen URL
    2. browser_snapshot — capture the accessibility tree
       (This gives you the REAL selectors, roles, and accessible names.
        Never guess selectors. Always get them from the live app.)
    3. browser_take_screenshot — save to qa/browser-tests/$FEATURE/
    4. Compare what you see against docs/SCREENS.md and wireframes/
    5. Log any discrepancies immediately

STEP B — TEST EVERY INTERACTION:
  On each screen:
    1. browser_click every button — verify correct result
    2. browser_type into every input — verify it accepts input
    3. browser_select_option on every dropdown
    4. browser_press_key Tab through the page — verify focus order
    5. browser_press_key Enter on focused buttons — verify activation
    6. For forms: submit with valid data, empty data, and invalid data

STEP C — TEST THE HAPPY PATH LIVE:
  Read P0 acceptance criteria from docs/PRD.md.
  Execute each Given/When/Then by actually doing it in the browser:
    - browser_navigate to start
    - browser_type / browser_click / browser_select_option to perform actions
    - browser_verify_text_visible / browser_verify_element_visible for assertions
    - browser_take_screenshot at each step

STEP D — RESPONSIVE CHECK:
  For the 3 most important screens:
    browser_resize width=1440 height=900 → browser_take_screenshot (desktop)
    browser_resize width=768 height=1024 → browser_take_screenshot (tablet)
    browser_resize width=375 height=812 → browser_take_screenshot (mobile)
  Verify: no overflow, no cut-off content, touch targets ≥ 44px on mobile

STEP E — HEALTH CHECK:
  browser_console_messages — flag any JavaScript errors or warnings
  browser_network_requests — flag any failed requests (4xx/5xx)

STEP F — GENERATE INITIAL TEST FILES:
  Use browser_generate_playwright_test to create .spec.ts files from your session.
  Save to: tests/e2e/$FEATURE-browser.spec.ts
  These become the foundation that the Engineer Agent refines below.

Output: qa/browser-tests/$FEATURE/exploration.md
  (Summary of what was found: working elements, broken elements, missing elements,
   selectors discovered, accessibility tree findings)

━━━ ANALYST AGENT ━━━

Read the source code for $FEATURE.
Read qa/plans/ for any existing test coverage on this feature.
Read qa/browser-tests/$FEATURE/exploration.md for live browser findings.

Map every testable surface:
  - Every user-facing interaction (clicks, inputs, form submissions, keyboard nav)
  - Every API call this feature makes and its possible response shapes
  - Every UI state: loading, empty, error, success, partial data
  - Every data-testid attribute or accessible role present in the DOM
  - Every validation rule (client-side and server-side)
  - Every route or navigation this feature triggers

Output: qa/plans/$FEATURE.md

━━━ PLANNER AGENT ━━━

Read qa/plans/$FEATURE.md.
Assign priority and write a Given/When/Then for each:

  P0 — "If this breaks, the product is unusable"
       (auth flows, data saving, core feature paths)
  P1 — "If this breaks, a significant feature is degraded"
       (secondary flows, important edge cases)
  P2 — "Edge case — good to have covered"
       (unusual inputs, rare states, nice-to-have validation)

Also include for each screen:
  - Empty state scenario (user has no data yet)
  - Error state scenario (network fails, server returns 500)
  - Mobile viewport scenario (at least for P0 items)

Output: qa/plans/$FEATURE-prioritized.md

━━━ ENGINEER AGENT ━━━

CRITICAL: The dev server must be running. Use Playwright MCP to
navigate the actual, running application before writing any test.

For each scenario in qa/plans/$FEATURE-prioritized.md:
  1. Navigate to the relevant route using Playwright MCP
  2. Confirm the element you intend to target is visible and accessible
  3. Note the exact accessible role, label, or testId
  4. Then write the Playwright test

Write all tests to: tests/e2e/$FEATURE.spec.ts

Playwright rules — these are absolute, no exceptions:
  ALLOWED:   getByRole('button', { name: 'Save' })
  ALLOWED:   getByLabel('Email address')
  ALLOWED:   getByText('No transactions yet')
  ALLOWED:   getByTestId('transaction-list')
  FORBIDDEN: page.$('.save-btn')
  FORBIDDEN: page.$('#submit')
  FORBIDDEN: page.$x('//button[@class="primary"]')
  FORBIDDEN: page.waitForTimeout(3000) <- use expect().toBeVisible() instead

Every test must:
  - Have a descriptive name explaining what it verifies
  - Assert a specific, meaningful outcome (not just "doesn't crash")
  - Use proper async/await throughout
  - Clean up any data it creates (use beforeEach/afterEach hooks)

━━━ SENTINEL AGENT ━━━

Read tests/e2e/$FEATURE.spec.ts line by line.

BLOCK (stop QA loop, return to Engineer) if any of these exist:
  - Any selector containing "." or "#" or "//"
  - Any action missing an await keyword
  - Any test block with zero assertions (expect() calls)
  - Any page.waitForTimeout() greater than 2000ms
  - Any test that only navigates and clicks with no assertion

WARN (flag but do not block) for:
  - Test names that don't clearly describe the scenario
  - Missing afterEach cleanup for data-creating tests
  - Tests that could affect each other's state

Output: qa/audits/$FEATURE-audit.md

If blockers found: list exact line numbers. Return to Engineer.
If no blockers: proceed.

━━━ EXECUTION ━━━

Run: npx playwright test tests/e2e/$FEATURE.spec.ts --reporter=json
Save full output to: qa/runs/$FEATURE-latest.json

━━━ HEALER AGENT (runs only if failures exist) ━━━

For each failed test:
  1. Read the full error message and attached screenshot
  2. Navigate to the failing page using Playwright MCP to inspect current state
  3. Make a determination:

  BROKEN TEST (the test is wrong):
    -> The page structure changed, selector no longer exists, or
      the expected text changed (not a regression, just drift)
    -> Fix: update the selector or assertion to match current reality
    -> Re-run the specific test
    -> If fixed: continue

  CONFIRMED BUG (the application is wrong):
    -> The feature is not behaving as the PRD acceptance criteria describe
    -> Do NOT fix the test to hide the bug
    -> Create: qa/bugs/$FEATURE-[timestamp].md with:
      - Which test failed
      - What the expected behaviour is (from PRD)
      - What the actual behaviour is
      - Screenshot path
      - Steps to reproduce
    -> STOP the QA loop
    -> Report: "Bug confirmed in $FEATURE. QA loop stopped.
         Run /build $FEATURE with this bug report to fix."

  Maximum 3 fix attempts per test before treating as confirmed bug.

━━━ EXPANDER AGENT (runs only if all tests pass) ━━━

Review qa/plans/$FEATURE-prioritized.md and tests/e2e/$FEATURE.spec.ts.

Find gaps — scenarios not yet covered. Look specifically for:
  - What happens when the user submits an empty form?
  - What happens at maximum input length (e.g. 10,000 character input)?
  - What happens if the user navigates away mid-flow and returns?
  - What happens if the user hits browser back/forward?
  - What happens on a very slow connection? (use Playwright network throttling)
  - What happens if the user is not authenticated and tries this feature?
  - What happens with special characters or emoji in text inputs?

Add 3-5 new tests to tests/e2e/$FEATURE.spec.ts.
Append the new scenarios to qa/plans/$FEATURE-prioritized.md.
Run the full suite again: npx playwright test tests/e2e/$FEATURE.spec.ts

━━━ SNAPSHOT AGENT ━━━

For every page involved in $FEATURE, capture screenshots at three viewports:
  - Desktop: 1440 x 900
  - Tablet:  768 x 1024
  - Mobile:  375 x 812

Save to: qa/visual-baselines/$FEATURE/[screen]-desktop.png
         qa/visual-baselines/$FEATURE/[screen]-tablet.png
         qa/visual-baselines/$FEATURE/[screen]-mobile.png

FIRST RUN BEHAVIOUR:
  These screenshots ARE the baseline. Save them.
  Document in qa/visual-baselines/$FEATURE/README.md:
  - Date baseline was created
  - What build/commit this represents
  - Any known intentional visual quirks

SUBSEQUENT RUN BEHAVIOUR:
  Run: npx playwright test --project=visual
  Compare each screenshot against baseline.
  If pixel difference > 2%: flag as visual regression.
  Save diff images to: qa/visual-reports/$FEATURE-[date]-diff.png
  A visual regression is treated the same as a test failure.

TO INTENTIONALLY UPDATE BASELINE:
  Run: npx playwright test --project=visual --update-snapshots
  Commit new baseline files.
  Document what changed and why in qa/visual-baselines/$FEATURE/README.md.

━━━ QUALITY GATE ━━━

Calculate score:

  P0 tests:    All must pass. Any P0 failure = score 0 = STOP HERE.
  P0 passing:  40 points
  P1 passing:  [passing / total] x 30 points
  P2 passing:  [passing / total] x 15 points
  Visual match: All snapshots match baseline = 15 points
                Any visual regression = 0 points for this category

  TOTAL POSSIBLE: 100 points

  Score < 85: FAIL
    -> Write full report to qa/QUALITY_LOG.md
    -> Output to user: which tests failed, which snapshots regressed,
      what the likely causes are
    -> "Run /build $FEATURE with this report to address failures."

  Score >= 85: PASS
    -> Append to qa/QUALITY_LOG.md: date, feature, score, test count
    -> "QA passed for $FEATURE. Score: [X]/100. Proceed to CI."
