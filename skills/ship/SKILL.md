---
name: ship
description: "Ship the feature: run final tests, generate changelog, create PR with structured summary, pre-push checks, and optional release tag."
user_invocable: true
---

Arguments: $VERSION (optional — e.g. "1.2.0". If omitted, auto-increment patch version from latest git tag)

Read CLAUDE.md before doing anything else.

━━━ STEP 1: PRE-FLIGHT CHECKS ━━━

Before shipping anything, confirm readiness:

  1. Check git status — working tree must be clean (all changes committed)
     If dirty: stop and list uncommitted changes. Do NOT auto-commit.

  2. Check current branch — must NOT be main/master
     If on main: stop. "Create a feature branch first."

  3. Check qa/QUALITY_LOG.md — most recent QA score must be >= 85
     If no QA log: warn "No QA score found. Run /qa-run first."
     If score < 85: stop. "QA score is [X]. Run /qa-run to fix failures."

━━━ STEP 2: FINAL TEST SUITE ━━━

Run the full test suite as a safety net:

  npm run test 2>&1
  npx playwright test 2>&1 (if e2e tests exist)

If ANY test fails:
  → Stop immediately
  → Report which tests failed
  → "Fix failures before shipping. Run /fix-bug or /build to address."

If all tests pass: proceed.

━━━ STEP 3: LINT & TYPE CHECK ━━━

Run whatever lint/type tools the project uses:

  If package.json has "lint" script:    npm run lint
  If package.json has "typecheck" script: npm run typecheck
  If tsconfig.json exists:              npx tsc --noEmit

Treat lint errors as blocking. Treat warnings as non-blocking (log them).

━━━ STEP 4: CHANGELOG ━━━

Generate a changelog from git commits since the last tag (or since initial commit if no tags):

  git log [last-tag]..HEAD --oneline --no-merges

Group commits into:
  ### Added      — new features (commits with "add", "feat", "new")
  ### Changed    — modifications (commits with "update", "change", "refactor")
  ### Fixed      — bug fixes (commits with "fix", "bug", "patch")
  ### Other      — everything else

Write to CHANGELOG.md (prepend to existing file, or create if missing).
Format: standard Keep a Changelog format with the version and date as header.

━━━ STEP 5: CREATE PULL REQUEST ━━━

Build a structured PR using the gh CLI:

  Title: short, descriptive (under 70 chars)

  Body:
    ## Summary
    [2-3 sentences: what this PR does and why]

    ## Changes
    [Bulleted list of key changes, grouped by type]

    ## Testing
    - Unit tests: [pass count] passing
    - E2E tests: [pass count] passing
    - QA score: [score]/100 (from qa/QUALITY_LOG.md)
    - Browser tested: [viewports tested]

    ## Changelog
    [Paste the changelog section generated above]

  Command:
    gh pr create --title "[title]" --body "[body]" --base main

If gh is not available or fails: output the PR body as markdown so the user
can copy-paste it manually.

━━━ STEP 6: TAG RELEASE (only if $VERSION provided or on release branch) ━━━

If a version was provided or the branch name contains "release":
  1. Determine version:
     - If $VERSION provided: use it
     - Else: read latest git tag, increment patch (1.0.0 → 1.0.1)
  2. git tag -a v$VERSION -m "Release $VERSION"
  3. Do NOT push the tag — just create it locally
  4. Report: "Tagged v$VERSION locally. Push with: git push origin v$VERSION"

If no version and not a release branch: skip tagging entirely.

━━━ FINAL OUTPUT ━━━

Report to the user:

  "Ship complete for [branch-name].
   Tests: [N] unit + [N] e2e — all passing
   QA score: [X]/100
   PR: [PR-URL]
   Changelog: updated CHANGELOG.md
   [Tag: v$VERSION created locally (if applicable)]

   To merge: review the PR at [PR-URL]"
