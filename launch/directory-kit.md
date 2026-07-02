# Directory Submission Kit — shipping-skills

> Output of the repo's own `directory-submissions` skill, run against the repo.
> Note it applies its own rule: generic AI-tool directories (Toolify, TAAFT) are
> skipped — the audience there wants apps, not a skills repo. Agent-ecosystem and
> builder directories are where this product's users actually look.

## 1. Submission asset kit (copy-paste everywhere)

- **Name:** shipping-skills
- **Tagline (58 chars):** AI agent skills for everything after the AI builds your app
- **Short description (99 chars):** 14 free agent skills that teach Claude Code & Cursor to launch your app and get your first users.
- **Medium description (247 chars):** The AI built your app — now what? shipping-skills gives your coding agent the post-build playbooks: pre-launch audit, domain check, pricing, Product Hunt plan, first 100 users, SEO. One install, 70+ agents supported. Free and open source (MIT).
- **Long description (~180 words):**

  > Building is the easy part now. Bolt, Lovable, v0, and Claude Code will ship your app in a weekend — then you're alone with 3 signups and no idea what to do next.
  >
  > shipping-skills is an open-source library of 14 agent skills for that exact moment. Install once (`npx skills add agent-k-labs/shipping-skills`) and your coding agent — Claude Code, Cursor, Windsurf, or 70+ others — picks up launch expertise: auditing your site before you announce it, checking real domain availability against registry data, choosing your first price, planning your Product Hunt day hour-by-hour, and building a personalized first-100-users playbook.
  >
  > These aren't prompt collections. Skills bundle verification scripts (RDAP domain checks, live site audits) so the agent checks instead of guesses, every skill ships eval test cases, and the repo follows the agentskills.io specification. In measured evals, skill-equipped runs hit a 1.0 assertion pass rate vs 0.61 without.
  >
  > Start with `/product-context`, then ask your agent "how do I get my first users?"

- **Logo:** 512×512 PNG — shipping-container or 🚢 mark + wordmark, works at 64px. *(to create)*
- **Screenshots (3–5, 1280×800):** ① terminal: `npx skills add agent-k-labs/shipping-skills` install flow; ② Claude Code running `/first-100-users` with a generated 30-day plan; ③ `check_domains.mjs` output table; ④ README journey diagram; ⑤ eval benchmark numbers. *(to capture)*
- **Tags:** agent-skills, claude-code, cursor, ai-agents, launch, marketing, indie-hackers, open-source, developer-tools, growth
- **Pricing tag:** Free / Open Source
- **Category:** Developer tools → AI agent tooling

## 2. Customized directory list

**Tier 1 — day 1 (agent ecosystem + builder core)**

| Target | How | Notes |
|---|---|---|
| skills.sh registry | Indexed from GitHub once installs happen; verify listing appears, claim if needed | The `npx skills` home — highest-intent audience |
| GitHub topics + social preview | Repo settings: `agent-skills claude-code ai-agents launch marketing indie-hackers` | Powers GitHub search/explore discovery |
| Product Hunt | Schedule a real launch day (Tue–Thu), don't just list | Use `/product-hunt-launch` output; pairs with community day 1 |
| Uneed | uneed.best submit | Launch-calendar model, dev-friendly, free tier |

**Tier 2 — week 1 (curated lists = durable backlinks)**

| Target | How |
|---|---|
| awesome-claude-code | PR adding shipping-skills under skills/plugins section |
| awesome-agent-skills / awesome-claude-skills lists | PR to each active list (search GitHub, pick lists with recent merges) |
| agentskills.io ecosystem page | Follow their listing/PR process |
| Indie Hackers product page | Create page + milestone intro post (see community kit) |
| Peerlist Launchpad | Builder audience, free |

**Tier 3 — weeks 2–4 (broader dev/OSS surface)**

| Target | How |
|---|---|
| dev.to / Hashnode article | "I made my coding agent launch my app" walkthrough that links the repo |
| daily.dev | Submit the article (their squads pick up dev.to posts) |
| AlternativeTo | List as alternative to marketingskills / prompt packs |
| SaaSHub | Free listing |
| Lovable / Bolt / v0 community showcases | Their Discords' showcase channels double as directories (see community kit) |

**Skipped deliberately:** Toolify, TAAFT, Futurepedia, G2, Capterra — audience mismatch (app-seekers and B2B buyers, not agent users). A worthless backlink costs a day of queue time.

## 3. Submission calendar

```
Day 1:   GitHub topics + social preview · verify skills.sh listing · Uneed
Day 2:   Indie Hackers product page + intro post
Day 3:   awesome-claude-code PR + one awesome-agent-skills PR
Day 4:   agentskills.io ecosystem submission · Peerlist
Day 5-7: Product Hunt launch day (scheduled via /product-hunt-launch)
Week 2:  dev.to article → daily.dev · remaining awesome-list PRs
Week 3:  AlternativeTo · SaaSHub · builder-Discord showcases (paced with community kit)
Week 4:  Check Search Console + GitHub traffic; resubmit/fix anything unlisted
```

## 4. Per-directory description variants

- **Agent directories (skills.sh, awesome lists):** lead with spec compliance + evals. "14 Agent Skills for the post-build journey (launch → first users → growth). agentskills.io-spec compliant, eval test cases per skill, bundled verification scripts. `npx skills add agent-k-labs/shipping-skills`."
- **Product Hunt / Uneed:** lead with the pain. Use the medium description; tagline as-is.
- **Dev surfaces (Show HN, dev.to, Peerlist):** lead with the technical angle. "Skills bundle real scripts — RDAP domain checks via IANA bootstrap, curl-based site audits — so the agent verifies instead of hallucinating. Evals measure a 1.0 vs 0.61 pass-rate delta over the bare model."
- **Indie Hackers:** lead with the founder story. "I kept watching vibe coders ship apps and stall at zero users, so I open-sourced the playbooks as agent skills."

## 5. Tracking

- GitHub Insights → Traffic: referrers per directory (built-in, free).
- Add `?ref=` params on links you control (IH page, dev.to article) — GitHub strips them for star tracking, so also note star count the day before each submission.
- Google Search Console for the org site if/when one exists; for now, GitHub referrer data is the source of truth.
- After 2 weeks: kill list — any directory that sent zero referrers gets dropped from future maintenance.
