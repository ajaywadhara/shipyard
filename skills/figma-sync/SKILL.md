---
name: figma-sync
description: "Optional: Sync design tokens from Figma, compare against code, flag drift, update visual baselines."
user_invocable: true
---

Prerequisites:
  - Figma MCP configured in .mcp.json
  - A Figma file URL provided by the user

STEP 1 — INGEST DESIGN TOKENS

Connect to the Figma file.
Extract all design tokens:
  - Colours (hex values + semantic names)
  - Typography (font family, sizes, weights, line heights)
  - Spacing scale
  - Border radii
  - Shadows and elevation

Save to: design-system/tokens.json

Compare against current CSS variables in src/.
Generate a drift report: qa/figma-drift.md

  Format:
  | Property       | Figma Value | Current Code | Delta  | Action |
  |----------------|-------------|--------------|--------|--------|
  | Primary colour | #6366F1     | #6467F2      | off    | Fix    |
  | Body font size | 16px        | 16px         | exact  | None   |
  | Card padding   | 24px        | 20px         | 4px    | Fix    |

STEP 2 — COMPONENT COMPARISON

For each component in the Figma file:
  - Find the matching component in src/
  - Compare rendered CSS against Figma spec
  - Tolerance: +/-4px for spacing, exact match for colours
  - Flag anything outside tolerance as a design debt item

STEP 3 — VISUAL BASELINE UPDATE

After fixing drift items:
  Run: npx playwright test --project=visual --update-snapshots
  New snapshots now represent Figma-aligned UI.
  Commit updated baselines.

STEP 4 — ONGOING SYNC

Add to CI: after every Figma file update (via webhook or manual trigger),
run /figma-sync to catch new drift before it accumulates.
