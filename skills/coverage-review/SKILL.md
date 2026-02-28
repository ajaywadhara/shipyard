---
name: coverage-review
description: Find untested areas across the codebase and fill coverage gaps. Run weekly or when the test suite feels stale.
user_invocable: true
---

Run every Monday (or manually when test suite feels stale).

STEP 1 — COVERAGE ANALYSIS

Run: npm run coverage
Run: npx playwright test --reporter=json

STEP 2 — FIND GAPS

Identify:
  - Any function in src/ with 0% test coverage
  - Any screen in docs/SCREENS.md with no corresponding E2E test
  - Any error state in the wireframes with no test
  - Any P1 or P2 feature from the PRD with no E2E test
  - Any route that has never appeared in a Playwright test

STEP 3 — FILL GAPS

For each gap found: write a test. No implementation changes.
Gaps that require new feature code are filed as backlog items, not fixed here.

STEP 4 — REPORT

Save to qa/COVERAGE_GAPS.md:
  - What was covered this week
  - How many new tests added
  - Current overall coverage %
  - Remaining known gaps
