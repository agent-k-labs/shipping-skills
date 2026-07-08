# shipping-skills

> **AI agent skills for everything after the AI builds your app.**

[![Validate skills](https://github.com/agent-k-labs/shipping-skills/actions/workflows/validate.yml/badge.svg)](https://github.com/agent-k-labs/shipping-skills/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Agent Skills spec](https://img.shields.io/badge/agent%20skills-spec%20compliant-brightgreen)](https://agentskills.io/specification)

You built something with Bolt, Lovable, v0, Replit, Claude Code, or another AI tool. Now what?

The building is the easy part. `shipping-skills` teaches AI agents (Claude Code, Cursor, Windsurf, Codex, and 70+ others) to help you launch, get your first users, and keep them — using the same frameworks experienced founders use, adapted for the vibe-coder workflow.

**These skills are not for the build step.** They pick up right where the builders leave off.

---

## Install

### Option 1 — skills CLI (recommended, works with 70+ agents)

```bash
npx skills add agent-k-labs/shipping-skills            # install everything
npx skills add agent-k-labs/shipping-skills --skill first-100-users product-hunt-launch
npx skills add agent-k-labs/shipping-skills --list     # see what's available
```

### Option 2 — Claude Code plugin

```
/plugin marketplace add agent-k-labs/shipping-skills
/plugin install shipping-skills
```

### Option 3 — clone

```bash
git clone https://github.com/agent-k-labs/shipping-skills.git
cp -r shipping-skills/skills/* .claude/skills/     # or .agents/skills/
```

### Option 4 — git submodule (stays updatable)

```bash
git submodule add https://github.com/agent-k-labs/shipping-skills.git .agents/shipping-skills
```

### Manual (any AI tool)

Paste the contents of any `skills/<name>/SKILL.md` as an instruction block before asking your question.

---

## The AI Shipping Journey

```
Stage 0 — Foundation     Stage 1 — Launch         Stage 2 — Get Users        Stage 3 — Grow
────────────────────     ─────────────────        ───────────────────        ────────────────
product-context          domain-name              first-100-users            onboarding-activation
                         pre-launch-checklist     community-launch           analytics-setup
                         landing-page             directory-submissions      referrals
                         waitlist                 seo-quickstart             churn-basics
                         pricing-first-time       founder-outreach           changelog
                         launch-video ─► SoloMax
                         product-hunt-launch
```

Start with `product-context` — it writes the `product-context.md` file every other skill reads, so you never re-explain your product.

## Skills

| Skill | Stage | What it does |
|-------|-------|-------------|
| [`product-context`](skills/product-context/) | Foundation | Create the product context file all other skills reference |
| [`domain-name`](skills/domain-name/) | Launch | Pick a domain — with real availability checks via RDAP + Cloudflare pricing |
| [`pre-launch-checklist`](skills/pre-launch-checklist/) | Launch | Audit everything before going live (includes automated site checks) |
| [`landing-page`](skills/landing-page/) | Launch | Build or audit a conversion-focused landing page |
| [`waitlist`](skills/waitlist/) | Launch | Set up and nurture a pre-launch waitlist |
| [`pricing-first-time`](skills/pricing-first-time/) | Launch | Choose your first pricing model and price point |
| [`launch-video`](skills/launch-video/) | Launch | Create a launch video brief, script, and AI prompt |
| [`product-hunt-launch`](skills/product-hunt-launch/) | Launch | Run a Product Hunt launch from prep to day-of |
| [`first-100-users`](skills/first-100-users/) | Get Users | The go-to playbook for your first 100 users |
| [`community-launch`](skills/community-launch/) | Get Users | Launch in Reddit, Discord, Slack, and forums without getting banned |
| [`directory-submissions`](skills/directory-submissions/) | Get Users | Where to list your app for free traffic and backlinks |
| [`seo-quickstart`](skills/seo-quickstart/) | Get Users | Minimum viable SEO (includes an automated page audit script) |
| [`onboarding-activation`](skills/onboarding-activation/) | Grow | Get new users to their first "aha" moment |
| [`analytics-setup`](skills/analytics-setup/) | Grow | The 5 events that matter before 100 users, with setup code |
| [`founder-outreach`](skills/founder-outreach/) | Get Users | Direct founder-to-user outreach — target list, DMs people answer, 2-week sprint |
| [`changelog`](skills/changelog/) | Grow | A public what's-new page and a 15-minute weekly publishing habit |
| [`churn-basics`](skills/churn-basics/) | Grow | Measure real churn, find the drop-off cliff, ship the right retention fix |
| [`referrals`](skills/referrals/) | Grow | A referral loop sized for a small product — incentive, ask, and ?ref= tracking |

Every skill follows the [Agent Skills specification](https://agentskills.io/specification): trigger-rich descriptions, bundled `scripts/`, `references/`, and `assets/` where they add leverage, and `evals/evals.json` test cases.

## Usage

Once installed, just describe your situation — the skills activate on natural language:

- *"No one is signing up for my app"* → `first-100-users`
- *"Is taskflow.com available?"* → `domain-name` (actually checks, doesn't guess)
- *"I want to launch on Product Hunt in 2 weeks"* → `product-hunt-launch`
- *"Review my app before I announce it"* → `pre-launch-checklist`

In Claude Code you can also invoke them directly: `/first-100-users`, `/product-hunt-launch`, etc.

---

## Who's behind this

`shipping-skills` is maintained by [agent-k-labs](https://github.com/agent-k-labs) — building AI-native products for solo founders, and open-sourcing the shipping playbooks along the way.

**Want the launch video done for you?** These skills give you the playbook; [SoloMax](https://solomax.app?ref=shipping-skills) does the work — paste your product URL and get a launch-ready video, hooks, captions, and posting copy in minutes. No camera, no editing, no brief needed.

## Contributing

PRs welcome. The bar: is this genuinely useful to someone who just shipped with an AI builder and doesn't know what to do next? See [CONTRIBUTING.md](CONTRIBUTING.md) for the skill format, validation, and eval requirements.

## License

[MIT](LICENSE)
