# Shipyard — Claude Code Plugin

**Your product's shipyard. From random thought to shipped, tested product in 13 commands.**

## Install

**From the marketplace:**

```bash
claude plugin marketplace add ajaywadhara/shipyard
```

**Or directly from GitHub:**

```bash
claude plugin add ajaywadhara/shipyard
```

That's it. All 13 commands are now available in every project.

**Per-project only** (if you prefer):

```bash
cp -r skills/ your-project/.claude/skills/
```

### Which scope should you use?

| Situation | Recommendation | How to install |
|-----------|---------------|----------------|
| Solo dev, want it everywhere | Global install | `claude plugin marketplace add ajaywadhara/shipyard` |
| Team project, everyone needs same commands | Per-project | `cp -r skills/ your-project/.claude/skills/` and commit to git |
| Trying it out on one project first | Per-project | `cp -r skills/ your-project/.claude/skills/` |
| Mixed — some global, some project-specific | Both | Global install + override specific skills in `.claude/skills/` |

> **Note:** Project-level skills override global ones if names collide. So you can install globally and selectively override per project.

---

## Why use this?

Most developers jump straight to code. Then they discover they built the wrong thing, have no tests, and no clue if it works on mobile.

Shipyard fixes that. It gives Claude Code a **complete software development lifecycle** — the same process that takes teams weeks, compressed into 13 slash commands:

- **You never write a PRD from scratch** — `/start` interviews you and writes it
- **You never skip competitive research** — `/research` finds competitors, reads their 1-star reviews, and finds your angle
- **You never design in your head** — `/wireframe` generates clickable HTML prototypes you can open in a browser
- **You never argue about tech stack** — `/architect` makes opinionated decisions with justifications
- **You never write code without tests first** — `/build` enforces TDD (RED → GREEN → REFACTOR)
- **You never ship security holes or dead code** — `/review` catches OWASP vulnerabilities, compliance issues, and performance anti-patterns before expensive testing
- **You never manually test in a browser** — `/test-ui` opens a real browser via Playwright MCP, clicks every button, fills every form, and generates permanent test files
- **You never ship without QA** — `/qa-run` runs an 8-agent loop that scores quality on a 100-point scale (must score ≥ 85 to pass)
- **You never let bugs escape twice** — `/fix-bug` creates a regression test before fixing anything
- **You never manually create PRs** — `/ship` runs final checks, generates a changelog, and creates a structured PR
- **You always know where you are** — `/status` shows pipeline progress at a glance
- **Your test suite grows automatically** — from ~20 tests on day 1 to 700+ by month 6

> **The key insight:** never guess what the UI looks like — always browse it first. Playwright MCP lets the agent see and interact with the real running app, so every test uses real selectors from the live DOM, not assumptions.

---

## The Workflow

```
Your idea (just thoughts)
  │
  ▼  /start            → Brain dump conversation → PRD.md
  ▼  /research         → Competitors, 1-star reviews, your angle
  ▼  /wireframe        → Clickable HTML prototypes (open in browser)
  ▼  /architect        → Stack decisions, CLAUDE.md, project scaffold + Playwright MCP
  ▼  /build [feat]     → TDD: spec (RED) → implement (GREEN) → refactor
  ▼  /review [feat]    → Security, compliance, performance check
  ▼  /test-ui [feat]   → Playwright MCP: browse live app, test every element, generate tests
  ▼  /qa-run [feat]    → 8-agent QA loop, quality gate (score ≥ 85)
  ▼  /fix-bug          → Bug → regression test → fix → permanent test
  ▼  /coverage-review  → Find and fill test gaps
  ▼  /ship             → PR, changelog, release, pre-push checks
  ▼  /figma-sync       → (Optional) Align code to Figma designs
  ▼  /status           → Where am I in the pipeline?
```

---

## Commands

### `/start` — Discovery

Turn a vague idea into a structured PRD through guided conversation.

- You talk naturally about what you want to build
- The agent asks questions (never more than two at a time)
- After 5-8 exchanges, it generates `docs/PRD.md`
- Output: PRD with problem statement, user persona, happy path, acceptance criteria

**Next:** `/research`

---

### `/research` — Market Reality Check

Competitive analysis before you design anything.

- Finds direct competitors, indirect competitors, and dead products
- Deep-dives the top 3-5: positioning, 1-star reviews, feature gaps
- Writes a verdict: red flags, green flags, your angle, pricing insight
- Updates the PRD with competitive context and feature priorities

**Output:** `docs/research/COMPETITORS.md`, `COMPETITIVE_ANALYSIS.md`, `VERDICT.md`
**Next:** `/wireframe`

---

### `/wireframe` — Clickable HTML Prototypes

Design every screen as a real, clickable HTML file.

- 4-colour wireframe palette (no polish, just structure)
- Every screen, empty state, error state, and modal
- Mobile viewport versions of the 3 most important screens
- Annotation panel on every page (what it does, what data flows)
- Index page with flow diagram

**Output:** `wireframes/INDEX.html` (open in browser)
**Next:** `/architect`

---

### `/architect` — Technical Foundation

All tech decisions made before a single feature is coded.

- Stack recommendation with one-sentence justifications
- Data model with entity relationships
- **CLAUDE.md** — the permanent instruction file for all future sessions
- Full project scaffold with configs, CI pipeline, smoke test
- **Playwright MCP** configured in `.mcp.json` for interactive browser testing

**Output:** `docs/STACK.md`, `docs/DATA_MODEL.md`, `CLAUDE.md`, `.mcp.json`, scaffolded project
**Next:** `/build [feature-name]`

---

### `/build [feature-name]` — TDD Feature Loop

Build one feature at a time using test-driven development.

1. **Spec Agent** writes failing tests (RED) — isolated context
2. **Confirm** tests fail for the right reasons
3. **Implement Agent** writes minimum code to pass (GREEN) — fresh context
4. **Fix Agent** retries up to 3x if still failing
5. **Refactor Agent** cleans up while keeping tests green

The spec and implementation agents run in separate contexts so tests reflect requirements, not implementation convenience.

**Next:** `/review [feature-name]`

---

### `/review [feature-name]` — Pre-QA Code Review

Catch security issues, dead code, and performance problems before expensive browser testing.

**4 checks:**

| Check | What it finds |
|-------|--------------|
| **Security** | OWASP top 10: SQL injection, XSS, command injection, path traversal, hardcoded secrets |
| **CLAUDE.md Compliance** | Naming conventions, file organization, import patterns, component patterns |
| **Dead Code** | Unused imports, unreachable code, commented-out blocks, empty catch blocks |
| **Performance** | N+1 queries, missing pagination, synchronous heavy ops, bundle bloat, React re-render traps |

**Severity levels:**
- **CRITICAL** — blocks. Must fix before `/test-ui`
- **WARNING** — flag. Should fix before `/ship`
- **INFO** — note. Consider fixing

**Output:** `qa/reviews/$FEATURE-review.md`
**Next:** `/test-ui [feature-name]` (for web apps) or `/qa-run [feature-name]`

---

### `/test-ui [feature-name]` — Interactive Browser Testing (Playwright MCP)

The agent opens a real browser via Playwright MCP and tests your running application — clicking every button, filling every form, navigating every screen. Then it auto-generates permanent Playwright test files.

**9 phases of interactive testing:**

| Phase | What it does |
|-------|-------------|
| **1. Visual Walkthrough** | Navigate every screen, screenshot, compare against wireframes |
| **2. Interaction Testing** | Click every button, fill every form, test every dropdown, keyboard nav |
| **3. Happy Path Flows** | Execute each P0 Given/When/Then in the real browser |
| **4. Empty & Error States** | Test with no data, simulated network failures, auth errors |
| **5. Responsive Testing** | Test at Desktop (1440px), Tablet (768px), Mobile (375px) |
| **6. Accessibility Audit** | Analyze a11y tree: labels, focus order, heading hierarchy, ARIA |
| **7. Console & Network** | Flag JS errors, failed requests, security concerns |
| **8. Generate Test Files** | Convert everything into permanent `.spec.ts` files |
| **9. Coverage Report** | Summary: screens tested, interactions verified, issues found |

**Key Playwright MCP tools used:**
- `browser_navigate` / `browser_click` / `browser_type` — interact with live app
- `browser_snapshot` — capture accessibility tree (real selectors, not guesses)
- `browser_take_screenshot` — visual evidence at every step
- `browser_resize` — responsive viewport testing
- `browser_verify_text_visible` / `browser_verify_element_visible` — assertions
- `browser_console_messages` / `browser_network_requests` — health checks
- `browser_generate_playwright_test` — auto-generate `.spec.ts` from session
- `browser_generate_locator` — stable selectors for flaky-free tests

**Output:**
- `qa/browser-tests/$FEATURE/` — screenshots, reports, accessibility findings
- `tests/e2e/$FEATURE-ui.spec.ts` — interaction tests
- `tests/e2e/$FEATURE-responsive.spec.ts` — viewport tests
- `tests/e2e/$FEATURE-a11y.spec.ts` — accessibility tests
- `tests/e2e/$FEATURE-errors.spec.ts` — error state tests

**Next:** `/qa-run [feature-name]`

---

### `/qa-run [feature-name]` — 8-Agent QA Loop

The most important phase. Runs after every feature. Now starts with live browser exploration via Playwright MCP.

| Agent | Role |
|-------|------|
| **Browser** | Explores the live app via Playwright MCP — clicks, types, screenshots, generates initial test files |
| **Analyst** | Maps every testable surface using browser findings + source code |
| **Planner** | Prioritizes scenarios: P0 critical / P1 core / P2 edge |
| **Engineer** | Refines Playwright tests using real selectors from browser_snapshot |
| **Sentinel** | Audits tests for anti-patterns, blocks bad tests |
| **Healer** | Auto-diagnoses failures: broken test vs. real bug |
| **Expander** | Finds untested scenarios, adds 3-5 new edge case tests |
| **Snapshot** | Visual baselines at 3 viewport sizes |

**Quality Gate:**

| Category | Points | Condition for 0 |
|----------|--------|-----------------|
| P0 tests | 40 | Any single P0 failure |
| P1 tests | 30 | Prorated by pass rate |
| P2 tests | 15 | Prorated by pass rate |
| Visual snapshots | 15 | Any visual regression |
| **Pass threshold** | **85** | Below = not done |

---

### `/fix-bug [description]` — Bug-to-Test Pipeline

Every bug gets a permanent regression test.

1. Understand the bug
2. Write a Playwright test that reproduces it (must be RED)
3. Fix the implementation (test turns GREEN)
4. Regression test lives in `tests/e2e/regression/` forever

---

### `/coverage-review` — Weekly Coverage Audit

Find and fill gaps in test coverage.

- Identifies functions with 0% coverage
- Finds screens with no E2E test
- Writes new tests (no implementation changes)
- Reports to `qa/COVERAGE_GAPS.md`

---

### `/ship` — Ship It

Close the pipeline. Final checks, changelog, PR, and optional release tag.

1. **Pre-flight** — clean git status, not on main, QA score >= 85
2. **Final test suite** — runs all unit + e2e tests one last time
3. **Lint & type check** — runs project lint/typecheck scripts
4. **Changelog** — auto-generates from git commits (Added/Changed/Fixed)
5. **Create PR** — structured summary with test results and QA score via `gh`
6. **Tag release** — optional, if version provided or on release branch

**Output:** PR on GitHub, updated `CHANGELOG.md`, optional git tag

---

### `/status` — Pipeline Progress

See where you are in the Shipyard pipeline at a glance.

```
Shipyard Pipeline Status
────────────────────────
  [done] /start            → docs/PRD.md (Feb 25)
  [done] /research         → docs/research/VERDICT.md (Feb 25)
  [next] /wireframe        → wireframes/ not found
  [ ]    /architect
  [ ]    /build
  [ ]    /review
  [ ]    /test-ui
  [ ]    /qa-run

Next step: run /wireframe
```

Checks for each pipeline artifact, shows the last QA score if available, and suggests the next command to run.

---

### `/figma-sync` — Design Alignment (Optional)

For when a designer joins the project.

- Extracts design tokens from Figma
- Generates a drift report (Figma vs. code)
- Updates visual baselines after fixes
- Requires Figma MCP configured in `.mcp.json`

---

## How the Test Suite Grows

You never manually think about test coverage. It's built into the loop.

```
Day 1, first feature:     ~20 tests
Week 1, all P0 features:  ~80 tests
Month 1, P1 features:     ~200 tests
First production bug:      +1 regression test (permanent)
Monthly coverage reviews:  +10-20 tests per review
Month 3:                   400+ tests
Month 6:                   700+ tests — a complete history of every
                           decision, edge case, and bug the product
                           has ever encountered
```

---

## Project Structure (created by `/architect`)

```
project-root/
├── CLAUDE.md                    ← Agent standing instructions
├── .mcp.json                    ← MCP server config (Playwright MCP)
├── docs/
│   ├── PRD.md                   ← Product requirements
│   ├── SCREENS.md               ← Screen inventory
│   ├── STACK.md                 ← Tech stack decisions
│   ├── DATA_MODEL.md            ← Entity relationships
│   └── research/
│       ├── COMPETITORS.md
│       ├── COMPETITIVE_ANALYSIS.md
│       └── VERDICT.md
├── wireframes/
│   ├── INDEX.html               ← Open this in your browser
│   └── [screen-name].html
├── qa/
│   ├── TEST_STRATEGY.md
│   ├── QUALITY_LOG.md
│   ├── COVERAGE_GAPS.md
│   ├── plans/
│   ├── audits/
│   ├── bugs/
│   └── visual-baselines/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
│       ├── [feature].spec.ts
│       ├── visual/
│       └── regression/
└── src/
    └── (application code)
```

---

## Playwright MCP Setup

The `/test-ui` and `/qa-run` commands use **Playwright MCP** to control a real browser. The `/architect` command sets this up automatically, but you can also configure it manually.

### Automatic (done by `/architect`)

The architect creates `.mcp.json` in your project root:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest", "--caps", "screenshot,pdf,testing"]
    }
  }
}
```

### Manual (if setting up yourself)

```bash
# Add Playwright MCP to your project
claude mcp add playwright npx '@playwright/mcp@latest'
```

### Available capabilities (--caps flag)

| Cap | What it unlocks |
|-----|----------------|
| `screenshot` | `browser_take_screenshot` — visual PNG capture |
| `testing` | `browser_generate_playwright_test`, `browser_verify_text_visible`, `browser_generate_locator` |
| `pdf` | `browser_pdf_save` — save pages as PDF |
| `vision` | Pixel-coordinate clicking (for visual models) |

### Key Playwright MCP tools used by Shipyard

| Tool | Used in | Purpose |
|------|---------|---------|
| `browser_navigate` | /test-ui, /qa-run | Load a page |
| `browser_click` | /test-ui, /qa-run | Click buttons, links |
| `browser_type` | /test-ui, /qa-run | Fill form inputs |
| `browser_snapshot` | /test-ui, /qa-run | Capture accessibility tree (real selectors) |
| `browser_take_screenshot` | /test-ui, /qa-run | Visual evidence |
| `browser_resize` | /test-ui, /qa-run | Test responsive viewports |
| `browser_verify_text_visible` | /test-ui | Assert text on page |
| `browser_verify_element_visible` | /test-ui | Assert element presence |
| `browser_console_messages` | /test-ui | Check for JS errors |
| `browser_network_requests` | /test-ui | Check for failed API calls |
| `browser_generate_playwright_test` | /test-ui | Auto-generate .spec.ts files |
| `browser_generate_locator` | /test-ui, /qa-run | Get stable selectors |
| `browser_press_key` | /test-ui | Keyboard navigation testing |
| `browser_select_option` | /test-ui | Dropdown testing |
| `browser_evaluate` | /test-ui | Inject JS for error simulation |

### How it works in the Shipyard workflow

```
/build [feature]
  │  Code is written and unit tests pass
  ▼
/review [feature]
  │  Security, compliance, performance check
  │  Fix CRITICAL issues before proceeding
  ▼
/test-ui [feature]                          ← Playwright MCP
  │  Agent opens real browser
  │  Navigates every screen
  │  Clicks every button, fills every form
  │  Tests 3 viewports (desktop/tablet/mobile)
  │  Checks accessibility tree
  │  Checks console for errors
  │  Auto-generates .spec.ts test files
  ▼
/qa-run [feature]
  │  Browser Agent skipped if /test-ui just ran
  │  Analyst maps testable surfaces
  │  Engineer uses REAL selectors from browser_snapshot
  │  (never guesses selectors — always from live app)
  │  Sentinel audits, Healer fixes, Expander adds edge cases
  │  Quality gate: score ≥ 85 to pass
  ▼
/ship
  │  Final tests, changelog, PR, release tag
  ▼
CI Pipeline
```

---

## Requirements

- [Claude Code](https://claude.ai/claude-code) CLI installed
- Node.js 20+ (for Playwright and test runners)
- Playwright MCP: `npx @playwright/mcp@latest` (auto-configured by `/architect`)
- Optional: GitHub Personal Access Token (for GitHub MCP)
- Optional: Figma token (for `/figma-sync`)

---

## Philosophy

> Writing code is the easy part. The hard part is building the **right** thing and knowing it **actually works**.

Shipyard front-loads clarity (discovery, research, wireframes) and back-loads testing (8-agent QA with live browser verification, self-expanding suite) so both problems are solved before you ship.

The key insight: **never guess what the UI looks like — always browse it first.** Playwright MCP lets the agent see and interact with the real application before writing a single test, so every test uses real selectors from the live DOM, not assumptions.

---

## License

MIT

---

## Credits

Based on "The Complete Agentic SDLC Blueprint v3.0" — adapted for Claude Code plugin distribution as Shipyard.
