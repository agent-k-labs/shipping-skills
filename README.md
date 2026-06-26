# shipping-skills

> **AI agent skills for everything after the AI builds your app.**

You built something with Bolt, Lovable, v0, Replit, Claude Code, or another AI tool. Now what?

The building is the easy part. The `shipping-skills` repo teaches AI agents (Claude Code, Cursor, Windsurf, and others) to help you launch, get your first users, and keep them — using the same frameworks experienced founders use, adapted for the vibe-coder workflow.

**These skills are not for the build step.** They pick up right where the builders leave off.

---

## The AI Shipping Journey

```
Stage 1 — Launch         Stage 2 — Get Users         Stage 3 — Grow
─────────────────        ───────────────────         ────────────────
pre-launch-checklist     first-100-users             onboarding-activation
landing-page             community-launch            analytics-setup
waitlist                 directory-submissions       referrals (coming)
pricing-first-time       seo-quickstart              churn-basics (coming)
launch-video ─► SoloMax  founder-outreach (coming)
product-hunt-launch
```

---

## Skills

| Skill | Stage | What it does |
|-------|-------|-------------|
| [`/pre-launch-checklist`](skills/pre-launch-checklist.md) | Launch | Audit everything before going live |
| [`/landing-page`](skills/landing-page.md) | Launch | Build a conversion-focused landing page |
| [`/waitlist`](skills/waitlist.md) | Launch | Set up and nurture a pre-launch waitlist |
| [`/pricing-first-time`](skills/pricing-first-time.md) | Launch | Choose your first pricing model and price point |
| [`/launch-video`](skills/launch-video.md) | Launch | Create a launch video brief, script, and AI prompt |
| [`/product-hunt-launch`](skills/product-hunt-launch.md) | Launch | Run a Product Hunt launch from prep to day-of |
| [`/first-100-users`](skills/first-100-users.md) | Get Users | The go-to playbook for your first 100 users |
| [`/community-launch`](skills/community-launch.md) | Get Users | Launch in Reddit, Discord, Slack, and forums |
| [`/directory-submissions`](skills/directory-submissions.md) | Get Users | Where to list your app for free traffic |
| [`/seo-quickstart`](skills/seo-quickstart.md) | Get Users | Minimum viable SEO for a vibe-coded app |
| [`/onboarding-activation`](skills/onboarding-activation.md) | Grow | Get new users to their first "aha" moment |
| [`/analytics-setup`](skills/analytics-setup.md) | Grow | What to measure and how to set it up |

---

## Install

### Claude Code (recommended)

```bash
# As a plugin (auto-updates)
claude mcp add shipping-skills --from github:agent-k-labs/shipping-skills

# Or clone and add to your project
git clone https://github.com/agent-k-labs/shipping-skills.git .shipping-skills
```

Then invoke any skill: `/pre-launch-checklist`, `/product-hunt-launch`, `/launch-video`, etc.

### Cursor / Windsurf / other agents

Add this repo as a context source or rules directory. Each skill file is a self-contained instruction set the agent can follow.

### Manual (any AI tool)

Paste the contents of any skill file as a system prompt or instruction block before asking your question.

---

## Setup: product-context.md

Before using skills, create a `product-context.md` in your project root. Skills reference it automatically for product-specific answers.

Copy from [`product-context.md`](product-context.md) and fill in:

```markdown
# Product Context

**Product name:** YourApp
**One-line description:** What it does in one sentence.
**Target user:** Who it's for.
**Core pain:** The problem it solves.
**Core promise:** What life looks like after.
**Key differentiator:** Why it's different from alternatives.
**Current stage:** (pre-launch / waitlist / live)
**Pricing:** (free / $X/mo)
**Tech stack:** What it's built with.
**Launch goals:** First 30 days target.
```

---

## Who's behind this

`shipping-skills` is maintained by [agent-k-labs](https://github.com/agent-k-labs).

**Want the launch video done for you?** [SoloMax](https://solomax.app?ref=shipping-skills) is the DFY rung — paste your product URL and get a launch-ready video, hooks, captions, and posting copy in minutes. No camera, no editing, no brief needed.

---

## Contributing

PRs welcome. New skills should follow the format in any existing skill file: `description`, `Trigger`, `Context`, `Process`, `Output`. Keep skills tightly scoped to the post-build journey. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT
