---
name: wireframe
description: Generate clickable HTML wireframes for every screen in the PRD. No design tool needed — open in browser.
user_invocable: true
---

Read docs/PRD.md and docs/research/VERDICT.md.

You are a UI/UX designer who works in HTML and CSS.
Generate wireframe-quality HTML pages for every screen in the PRD.

DESIGN RULES (follow strictly):
  - Single HTML file per screen, saved to wireframes/[screen-name].html
  - 4-colour palette only: white (#FFFFFF), light grey (#F3F4F6),
    mid grey (#9CA3AF), dark (#1F2937), and one accent (#6366F1)
  - No stock photos. Use labelled grey boxes: <div class="placeholder">Profile Photo</div>
  - No icon libraries. Use bracketed text: [icon: search], [icon: bell]
  - Every interactive element must be present and visually distinct:
    buttons, inputs, dropdowns, modals, navigation, empty states
  - Clicking buttons/links should navigate to the correct next screen
    (use href="[screen-name].html" for inter-screen navigation)

ANNOTATION PANEL:
  Add a sticky panel at the bottom of every wireframe (styled differently
  from the wireframe itself — use a yellow background) containing:
  - What this screen does (one sentence)
  - What user story from the PRD this satisfies
  - What triggers navigation away from this screen
  - What data is displayed and what data is entered
  - Any edge cases or empty states to handle

SCREENS TO GENERATE:
  Read the PRD happy path and P1 features. Generate a wireframe for:
  - Every distinct screen mentioned
  - The empty state of every screen that displays a list
  - Every error state (form validation, network failure, auth error)
  - Every modal or overlay
  - Mobile viewport version of the 3 most important screens
    (add a note: "mobile view — 375px viewport" in the annotation panel)

INDEX PAGE:
  Generate wireframes/INDEX.html with:
  - Links to all screens organised by user flow
  - A simple flow diagram using HTML/CSS (boxes and arrows, no libraries)
  - A legend explaining the annotation panel colour coding

SCREENS DOCUMENT:
  Generate docs/SCREENS.md listing:
  | Screen Name | File | Purpose | PRD User Story | Data Shown | Data Entered |

After generating all wireframes, say:
"Wireframes saved to wireframes/. Open wireframes/INDEX.html in your browser
 to review. Describe any changes in plain English and I'll update them.
When you're happy, run /architect."
