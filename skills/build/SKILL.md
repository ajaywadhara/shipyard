---
name: build
description: "TDD feature build loop: spec (RED) → implement (GREEN) → refactor. Pass the feature name as argument."
user_invocable: true
---

Arguments: $FEATURE

Read CLAUDE.md before doing anything else.
Read the acceptance criteria for "$FEATURE" in docs/PRD.md.

━━━ STEP 1: SPEC AGENT (isolated subagent) ━━━

Spawn a subagent with ONLY this context:
  - The acceptance criteria for $FEATURE from PRD.md
  - CLAUDE.md (for naming conventions and patterns)
  - The relevant wireframe from wireframes/ if a UI feature

Subagent instruction:
  "Write failing tests for $FEATURE to:
    tests/unit/$FEATURE.test.ts
    tests/integration/$FEATURE.integration.test.ts

   Tests must be RED. Do not write any implementation code.
   Write tests that would pass if the feature worked exactly as described
   in the acceptance criteria — not tests that are easy to make pass."

━━━ STEP 2: CONFIRM RED ━━━

Run: npm run test -- $FEATURE

If tests pass (shouldn't happen yet): something is wrong. Inspect and fix.
If tests fail with import errors only: fix imports, this is not real RED.
If tests fail because the feature doesn't exist: this is correct RED. Proceed.

━━━ STEP 3: IMPLEMENT AGENT (fresh subagent, isolated context) ━━━

Spawn a new subagent with ONLY this context:
  - The failing test files
  - CLAUDE.md
  - Relevant wireframe

Subagent instruction:
  "The test files contain failing tests for $FEATURE.
   Implement the minimum code necessary to make ALL tests pass.
   Read CLAUDE.md for patterns and conventions.
   Do not add any functionality that is not tested."

━━━ STEP 4: CONFIRM GREEN ━━━

Run: npm run test -- $FEATURE

If GREEN: proceed to refactor.
If RED: spawn FIX AGENT:
  "Tests are still failing. Error output: [paste exact output].
   Fix the implementation only. Do not change test assertions.
   The tests are correct. The implementation is wrong."
  Re-run. If still RED after 3 attempts: stop and report the issue.

━━━ STEP 5: REFACTOR ━━━

Spawn REFACTOR AGENT:
  "All tests are GREEN for $FEATURE.
   Refactor the implementation for clarity, performance, and consistency
   with CLAUDE.md patterns.
   Tests must remain GREEN after every change.
   Run tests after each significant change."

━━━ STEP 6: HAND OFF ━━━

For web applications (UI features), run BOTH:
  /test-ui $FEATURE  — interactive browser testing via Playwright MCP
  /qa-run $FEATURE   — full 8-agent QA loop

/test-ui explores the live app and generates initial Playwright test files.
/qa-run then runs the complete QA pipeline including those generated tests.

For non-UI features (API, data layer, utilities):
  /qa-run $FEATURE   — skip /test-ui, go straight to QA loop
