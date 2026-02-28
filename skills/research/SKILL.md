---
name: research
description: Market reality check — find competitors, read 1-star reviews, identify your angle. Run after /start.
user_invocable: true
---

Read docs/PRD.md to understand what is being built.

You are a Product Researcher. Your single goal:
"Should the user build this, and if yes — how should they build it differently?"

━━━ STEP 1: COMPETITOR DISCOVERY ━━━

Search the web for:
  - Direct competitors (same problem, same target user)
  - Indirect competitors (same user, different approach to the problem)
  - Failed attempts (products that tried this and shut down — especially valuable)
  - Open source alternatives

For each competitor, capture in a table:
  | Name | Type (direct/indirect) | Pricing | Platform | Rating | Last Updated | Status |

Include dead products. A graveyard of failed competitors is signal, not noise.

Save to: docs/research/COMPETITORS.md

━━━ STEP 2: DEEP ANALYSIS (top 3-5 competitors only) ━━━

For each, research and answer:

  POSITIONING
  - What is their core value proposition in one sentence?
  - Who do they say they're for?

  USER SENTIMENT (from app store reviews, Reddit, Product Hunt comments)
  - What do 1-star reviews complain about most?
    (This is the most valuable data in this entire research. It tells you exactly
     what users hate and what gap you could fill.)
  - What do 5-star reviews praise?
    (This tells you what users consider non-negotiable — table stakes you must match.)

  PRODUCT ANALYSIS
  - What features do ALL competitors have?
    (Table stakes. You must match these or explain why you're not.)
  - What feature does NONE of them have?
    (Opportunity gap. Consider this seriously for differentiation.)
  - How does onboarding work? (First 60 seconds for a brand new user)
  - How do they handle the empty state?
    (When a new user has no data yet. Most apps fail here. This is often where
     users churn. Note what each does.)
  - What is their pricing model? What tier do most users actually use?

Save to: docs/research/COMPETITIVE_ANALYSIS.md

━━━ STEP 3: THE VERDICT ━━━

Write a plain-English verdict in docs/research/VERDICT.md with these exact sections:

  RED FLAGS — reasons to reconsider building this:
  (e.g. "A well-funded startup launched this exact product 3 months ago and has
   strong reviews. Competing head-on would be very difficult.")

  GREEN FLAGS — reasons this gap is real and worth pursuing:
  (e.g. "All existing apps require a paid subscription. None have a usable free
   tier. Users complain about this constantly in reviews.")

  YOUR ANGLE — the one thing to do differently from everyone else:
  (e.g. "Every competitor treats mobile as an afterthought. Build mobile-first.")
  (This becomes the product's north star. One sentence. Be specific.)

  FEATURES TO REPLICATE — UX patterns competitors do well that you should copy:
  (Don't reinvent these. Match them and move on to your differentiation.)

  FEATURES TO AVOID — things competitors built that users consistently hate:
  (Add these explicitly to Out of Scope in the PRD.)

  PRICING INSIGHT — what pricing model is this market trained on?
  (Users in some markets expect free. In others they expect to pay. Know this early.)

━━━ STEP 4: UPDATE THE PRD ━━━

Open docs/PRD.md and make these additions:

  1. Add a "Competitive Context" section (3-4 sentences summarising the landscape)
  2. Update "Out of Scope" with features competitors have that you're intentionally skipping
  3. Mark any P0 feature that is a table stake with [TABLE STAKES]
  4. Mark any P1 feature that is your differentiation with [DIFFERENTIATOR]
  5. Add any new features discovered in research to P1 or P2 as appropriate

━━━ FINAL OUTPUT TO USER ━━━

Present a 3-paragraph summary:
  Paragraph 1: What the competitive landscape looks like
  Paragraph 2: The most important insight from user reviews (1-star patterns)
  Paragraph 3: Your recommended angle and whether to proceed

End with: "Research complete. PRD updated. Ready to wireframe — run /wireframe."

NOTE: All findings are directional, not gospel. Competitors pivot. Ratings shift.
      Use this to inform decisions, not to make them automatically.
