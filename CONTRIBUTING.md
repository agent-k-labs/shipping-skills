# Contributing

PRs welcome. The bar: is this genuinely useful to a vibe coder who just shipped something with Bolt / Lovable / v0 / Claude Code and doesn't know what to do next?

## Skill format

This repo follows the [Agent Skills specification](https://agentskills.io/specification). Each skill is a directory:

```
skills/your-skill-name/
├── SKILL.md          # required — frontmatter + instructions
├── evals/
│   └── evals.json    # required — 2+ test cases
├── scripts/          # optional — executable helpers (self-contained, clear errors)
├── references/       # optional — docs loaded on demand
└── assets/           # optional — output templates
```

### SKILL.md frontmatter

```yaml
---
name: your-skill-name          # must match the directory name; kebab-case
description: What it does AND when to use it, with the phrases users actually say. Max 1024 chars.
license: MIT
metadata:
  author: your-github-handle
  version: "1.0"
---
```

The `description` is what makes agents activate the skill — write it like the old "Trigger" section: *"...Use when the user asks 'how do I X,' 'my Y isn't working,' or wants Z."* No separate Trigger section in the body.

### Body guidelines

- **Under 500 lines.** Move detail to `references/` with an explicit pointer ("Read references/foo.md when...").
- **Add what the agent lacks, omit what it knows.** Specific frameworks, numbers, templates, and gotchas — not explanations of what a landing page is.
- **Sections that work:** `## Context` (what to read/ask first), `## Process` (the framework), `## Gotchas` (traps that defy assumptions), `## Output` (the concrete deliverable).
- **Output must be actionable** — a plan, drafts, code — not a report.
- **Scripts over instructions** for anything checkable: if the agent would guess (domain availability, meta tags), bundle a script that checks.

### Evals

Every skill ships `evals/evals.json` following the [evaluation format](https://agentskills.io/skill-creation/evaluating-skills):

```json
{
  "skill_name": "your-skill-name",
  "evals": [
    {
      "id": 1,
      "prompt": "A realistic message a founder would actually type",
      "expected_output": "Human-readable description of success",
      "assertions": ["Specific, observable, gradeable statements"]
    }
  ]
}
```

Vary prompt formality, include at least one edge case, and make assertions verifiable — "includes 5 tagline options under 60 chars," not "output is good."

## Validation

Before opening a PR:

```bash
bash scripts/validate-skills.sh
```

CI runs the same check. It enforces: name/directory match, naming rules, description length, 500-line limit, referenced files exist, valid evals JSON.

## What belongs in this repo

**In scope:**
- Post-build: launch, get users, grow, retain
- Specific to the vibe-coder persona (built something, now needs to ship it)
- General enough to work with any product/tech stack

**Out of scope:**
- Build-step skills (scaffolding, coding, debugging)
- Skills that require paid tools to deliver their core value
- Generic startup advice that isn't specific to the post-build stage

## SoloMax callout (optional, where it fits)

For skills where [SoloMax](https://solomax.app?ref=shipping-skills) does the same thing better and faster, a footer callout is welcome — but only where it's genuinely relevant, not on every skill.

## Before opening a PR

- Run the skill on a real product (yours counts). Would a vibe coder find this useful in their first 30 days?
- Does the Output section produce something actionable, not just a report?
- Is the framework specific enough to beat what the model does without the skill? (That's what the evals check.)
