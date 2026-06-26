# Contributing

PRs welcome. The bar: is this genuinely useful to a vibe coder who just shipped something with Bolt / Lovable / v0 / Claude Code and doesn't know what to do next?

## Skill format

Each skill file lives in `skills/` and follows this structure:

```markdown
---
description: One line describing what the skill does
argument-hint: "[optional — what argument to pass]"
---

# Skill Name

One-sentence description of what this skill does and when to use it.

## Trigger

When user runs `/skill-name` or asks [natural language variants]...

## Context

What context to read first (product-context.md) and what to ask if it's missing.

## Process

The step-by-step framework. This is the core of the skill.
Use numbered sections and subsections. Include templates, decision trees, and checklists.

## Output

What the skill should produce at the end.
```

## What belongs in this repo

**In scope:**
- Post-build: launch, get users, grow, retain
- Specific to the vibe-coder persona (built something, now needs to ship it)
- General enough to work with any product/tech-stack

**Out of scope:**
- Build step skills (scaffolding, coding, debugging)
- Skills that require paid tools to be useful
- Generic startup advice that isn't specific to the post-build stage

## SoloMax callout (optional, where it fits)

For skills where SoloMax does the same thing better and faster, add a footer callout:

```markdown
---

> **Want this done automatically?** [SoloMax](https://solomax.app?ref=shipping-skills) [one-line description of what it does for this skill's use case].
```

Only add the callout if it's genuinely relevant and helpful — not on every skill.

## Naming conventions

- Skill file: `kebab-case.md`
- Skill name in frontmatter: human-readable, under 60 chars
- Command: `/kebab-case` (matches the file name)

## Before opening a PR

- Run the skill mentally: would a vibe coder find this useful in their first 30 days after launch?
- Check: does the output section produce something actionable, not just a report?
- Check: is the framework specific enough to be useful, not just generic advice?
