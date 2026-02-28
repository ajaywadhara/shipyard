---
name: architect
description: Make all tech decisions, write CLAUDE.md, scaffold the project, and get a smoke test passing. Run after /wireframe.
user_invocable: true
---

Read: docs/PRD.md, docs/research/VERDICT.md, docs/SCREENS.md,
      and all files in wireframes/

You are a Senior Software Architect. This is a pre-implementation phase only.
Do not write any feature code.

━━━ OUTPUT 1: STACK DECISION (docs/STACK.md) ━━━

Recommend a tech stack. Justify every choice in exactly one sentence.
Default to boring, proven technology. Resist novelty.

Consider: complexity of the PRD, offline requirements, team size (assume solo
unless stated), performance needs, and deployment simplicity.

Structure:
  - Frontend framework + why
  - Styling approach + why
  - Backend approach (or "none needed" if client-only) + why
  - Database (or "none needed") + why
  - Auth approach + why
  - Hosting recommendation + why
  - Unit test runner + why
  - E2E test runner (Playwright — always Playwright) + why

━━━ OUTPUT 2: DATA MODEL (docs/DATA_MODEL.md) ━━━

List every entity the product manages.
For each entity:
  - Fields, types, constraints
  - Relationships to other entities
  - Which screen(s) display or modify this entity

Keep it simple. Normalise only what needs normalising.

━━━ OUTPUT 3: CLAUDE.md (project root) ━━━

This is the most important file you will write. It persists across every
future session. Write it carefully.

---
# CLAUDE.md

## What We Are Building
[One paragraph from PRD vision]

## Stack
[From STACK.md — 6-8 bullet points]

## Project Structure
[Folder tree with one-line description of each folder's purpose]

## Commands
  npm run dev       — start development server
  npm run build     — production build
  npm run test      — run unit + integration tests
  npm run test:e2e  — run Playwright E2E suite
  npm run test:visual — run visual regression tests
  npm run coverage  — coverage report
  npm run lint      — ESLint + TypeScript check

## Non-Negotiable Rules
  1. Every feature must have unit + integration + E2E tests before it is
     considered complete. No exceptions. No "I'll add tests later."
  2. Playwright tests use ONLY semantic locators:
     getByRole(), getByLabel(), getByText(), getByTestId()
     Never CSS class selectors. Never XPath.
  3. The test suite only grows. Tests are never deleted — only updated.
  4. Every bug fix ships with a regression test that first reproduces the bug.
  5. Visual snapshots are the design truth. Unintentional visual changes
     are treated as regressions.
  6. A feature with a quality score below 85 is not done.

## Coding Conventions
  [Language-specific: naming, file organisation, import order, etc.]

## Definition of Done Checklist
  [ ] Feature works per acceptance criteria in PRD
  [ ] Unit tests written and passing (≥80% line coverage)
  [ ] Integration tests written and passing
  [ ] Playwright E2E test covers happy path + at least 2 edge cases
  [ ] Visual regression snapshot created or updated
  [ ] No TypeScript errors (if applicable)
  [ ] No lint errors
  [ ] QA quality score ≥ 85

## Known Patterns
  [Document any architectural patterns chosen, e.g.:
   "Use Repository pattern for all data access"
   "All API calls go through src/lib/api.ts — never fetch() directly in components"]
---

━━━ OUTPUT 4: MCP CONFIG (.mcp.json) ━━━

Create .mcp.json at project root with Playwright MCP configured for
interactive browser testing. This is REQUIRED for /test-ui and /qa-run:

{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": [
        "@playwright/mcp@latest",
        "--caps", "screenshot,pdf,testing"
      ]
    }
  }
}

The "testing" cap enables: browser_generate_playwright_test,
browser_generate_locator, browser_verify_text_visible,
browser_verify_element_visible, browser_verify_value.

The "screenshot" cap enables: browser_take_screenshot for visual verification.

If the project needs GitHub integration, add:
{
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_TOKEN" }
  }
}

━━━ OUTPUT 5: PROJECT SCAFFOLD ━━━

Execute:
  1. Create all folders per the structure in CLAUDE.md
  2. Initialise package.json / equivalent
  3. Install all dependencies
  4. Configure: ESLint, Prettier, TypeScript (if applicable)
  5. Configure Vitest (or chosen unit runner) with coverage reporting
  6. Configure Playwright with:
     - Default project (Chromium, 1280x720)
     - Mobile project (375x667, mobile emulation)
     - Visual project (for snapshot tests)
  7. Create .mcp.json with Playwright MCP (see OUTPUT 4)
  8. Create .github/workflows/qa.yml (CI pipeline)
  9. Create qa/browser-tests/ directory for Playwright MCP test artifacts
  10. Write a single smoke test: "dev server starts and returns 200"
  11. Run the smoke test. Confirm it passes.

When complete, say:
"Architecture complete. CLAUDE.md written. Project scaffolded.
 Playwright MCP configured. Smoke test passing.
 Ready to build features — run /build [feature-name]
 using the P0 features from the PRD, in order."
