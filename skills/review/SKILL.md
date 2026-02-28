---
name: review
description: "Pre-QA code review: security scan, CLAUDE.md compliance, dead code detection, performance anti-patterns. Catch issues before expensive testing."
user_invocable: true
---

Arguments: $FEATURE (or "all" to review the entire recent diff)

Read CLAUDE.md before doing anything else.

━━━ SCOPE ━━━

Identify the files to review:
  If $FEATURE specified: find all source files related to $FEATURE
    (check src/, components/, pages/, routes/, lib/, utils/ for matches)
  If "all": use git diff --name-only against the base branch (main/master)
  If no diff available: review all files under src/

Read every file in scope before producing findings.

━━━ CHECK 1: SECURITY (OWASP Top 10 patterns) ━━━

Scan for:
  - SQL injection: raw string concatenation in queries, missing parameterization
  - XSS: unescaped user input rendered in HTML, dangerouslySetInnerHTML with user data
  - Command injection: user input passed to exec(), spawn(), system()
  - Path traversal: user input in file paths without sanitization
  - Insecure auth: hardcoded secrets, tokens in client code, missing CSRF protection
  - Open redirects: user-controlled redirect URLs without allowlist
  - Sensitive data exposure: passwords logged, secrets in error messages, PII in URLs

Severity: CRITICAL for any exploitable pattern, WARNING for potential issues.

━━━ CHECK 2: CLAUDE.md COMPLIANCE ━━━

Read CLAUDE.md and verify the code follows its rules:
  - Naming conventions (file names, function names, variable names)
  - File organization (correct directories, no orphaned files)
  - Import patterns (absolute vs relative, barrel exports if specified)
  - Component patterns (if React/Vue/Svelte conventions are defined)
  - State management patterns (if specified)
  - Error handling patterns (if specified)
  - Any explicit "DO" or "DO NOT" rules in CLAUDE.md

Severity: WARNING for violations, INFO for style suggestions.

━━━ CHECK 3: DEAD CODE ━━━

Scan for:
  - Unused imports (imported but never referenced)
  - Unused variables (declared but never read)
  - Unused functions (defined but never called from any file in scope)
  - Unreachable code (after return/throw/break with no conditional)
  - Commented-out code blocks (more than 3 consecutive commented lines)
  - Empty catch blocks (catch that swallows errors silently)

Severity: WARNING for unused exports (might be used elsewhere), INFO for local dead code.

━━━ CHECK 4: PERFORMANCE ━━━

Scan for:
  - N+1 queries: database call inside a loop (forEach, map, for)
  - Missing pagination: fetching all records without limit/offset
  - Synchronous heavy operations: large file reads, crypto, or JSON.parse in request handlers without async
  - Bundle concerns: importing entire libraries when only one function is needed
  - Re-render traps (React): objects/arrays created in render, missing useMemo/useCallback for expensive computations passed as props
  - Missing error boundaries (React): async operations without try/catch
  - Unindexed queries: if DATA_MODEL.md exists, check queries against defined indexes

Severity: WARNING for likely performance issues, INFO for optimization suggestions.

━━━ OUTPUT ━━━

Write findings to qa/reviews/$FEATURE-review.md:

  ## Code Review: $FEATURE
  Date: [date]
  Files reviewed: [count]

  ### CRITICAL (blocks — must fix before /test-ui)
  [List each with file:line, description, and fix suggestion]

  ### WARNING (flag — should fix before /ship)
  [List each with file:line, description, and fix suggestion]

  ### INFO (note — consider fixing)
  [List each with file:line, description]

  ### Summary
  - Critical: [N]
  - Warnings: [N]
  - Info: [N]

Report to user:

  If CRITICAL findings exist:
    "Review found [N] critical issues that must be fixed before testing.
     See qa/reviews/$FEATURE-review.md for details.
     Fix these, then run /test-ui $FEATURE."

  If only WARNING or INFO:
    "Review passed — no critical issues.
     [N] warnings, [N] info items logged to qa/reviews/$FEATURE-review.md.
     Proceed to /test-ui $FEATURE."

  If clean:
    "Review passed — no issues found. Proceed to /test-ui $FEATURE."
