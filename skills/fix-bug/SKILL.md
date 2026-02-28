---
name: fix-bug
description: "Bug-to-test pipeline: reproduce the bug as a failing test first, then fix. The regression test lives forever."
user_invocable: true
---

Arguments: $BUG_DESCRIPTION

You are a QA engineer and developer working together.

STEP 1 — UNDERSTAND THE BUG

Read $BUG_DESCRIPTION carefully.
If insufficient detail, ask: "What were you doing when this happened?
What did you expect to see? What did you see instead?"

STEP 2 — REPRODUCE FIRST (non-negotiable)

Before fixing anything:
  Write a Playwright test to tests/e2e/regression/[bug-id].spec.ts
  that replicates the exact user journey that triggers the bug.
  Run it. It must be RED (failing) before you touch the implementation.

  If you can't make it fail, you don't understand the bug yet.
  Do not proceed until the test is RED.

STEP 3 — FIX

Now fix the implementation.
Run the regression test. It must turn GREEN.
Run the full test suite. Nothing else must break.

STEP 4 — PERMANENT RESIDENCE

The regression test lives in tests/e2e/regression/ forever.
It is never deleted.
It runs in every CI pipeline from this point forward.

Update qa/QUALITY_LOG.md:
  - Bug ID, date, description, affected feature, fix summary
