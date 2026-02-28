---
name: status
description: "Pipeline progress: check which Shipyard phases are complete, see the last QA score, and get the next command to run."
user_invocable: true
---

No arguments required.

━━━ CHECK PIPELINE OUTPUTS ━━━

Check for existence of each pipeline artifact:

  /start         → docs/PRD.md
  /research      → docs/research/VERDICT.md
  /wireframe     → wireframes/INDEX.html
  /architect     → CLAUDE.md AND docs/STACK.md
  /build         → src/ contains implementation files (beyond scaffold)
  /review        → qa/reviews/ contains at least one review file
  /test-ui       → qa/browser-tests/ contains at least one feature folder
  /qa-run        → qa/QUALITY_LOG.md
  /coverage-review → qa/COVERAGE_GAPS.md
  /ship          → check git log for PR-related commits or CHANGELOG.md exists
  /figma-sync    → qa/visual-baselines/ contains figma-synced files (optional)

For each artifact found, note the file's last modified date.

━━━ READ QUALITY SCORE ━━━

If qa/QUALITY_LOG.md exists:
  Read the most recent entry
  Extract: feature name, score, date, pass/fail status

━━━ DISPLAY STATUS ━━━

Output a checklist like this:

  Shipyard Pipeline Status
  ────────────────────────
    [done] /start            → docs/PRD.md (Feb 25)
    [done] /research         → docs/research/VERDICT.md (Feb 25)
    [done] /wireframe        → wireframes/INDEX.html (Feb 26)
    [done] /architect        → CLAUDE.md + docs/STACK.md (Feb 26)
    [done] /build            → src/ has implementation (Feb 27)
    [done] /review           → qa/reviews/auth-review.md (Feb 27)
    [done] /test-ui          → qa/browser-tests/auth/ (Feb 27)
    [done] /qa-run           → Score: 92/100 — PASS (Feb 28)
    [next] /coverage-review  → qa/COVERAGE_GAPS.md not found
    [ ]    /ship
    [skip] /figma-sync       → (optional, no Figma configured)

  Last QA score: auth — 92/100 (PASS)
  Next step: run /coverage-review

Rules:
  - Mark [done] if the artifact exists
  - Mark [next] for the first incomplete required step
  - Mark [ ] for steps after [next]
  - Mark [skip] for /figma-sync if no .mcp.json with figma config exists
  - Show the date from the file's modification time
  - Show the QA score inline if qa/QUALITY_LOG.md exists
  - Suggest the next command at the bottom
