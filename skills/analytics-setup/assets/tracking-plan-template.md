# Tracking Plan — [Product Name]

> The 5 events that matter before 100 users. Copy this file into the product repo
> (e.g. `docs/tracking-plan.md`) and keep it as the single source of truth for
> event names — inconsistent naming is the #1 way early analytics become garbage.

## Naming convention

`object_action` in snake_case, past tense: `user_signed_up`, `video_generated`.
Never rename an event after it ships — add a new one and deprecate the old.

## Events

| Event | Fires when | Properties | Implemented |
|-------|-----------|------------|-------------|
| `user_signed_up` | Successful auth completion | `method` (google/email), `source` (?ref param) | ☐ |
| `[core_action]_completed` | User does the activation action the first+every time | [domain-specific: e.g. `duration_ms`, `template_used`] | ☐ |
| `subscription_started` | Stripe webhook `checkout.session.completed` | `plan`, `amount`, `interval` | ☐ |
| `[core_action]_repeated` | Same as core action — query for 2nd+ occurrence per user | (same) | ☐ |
| `subscription_cancelled` | Stripe webhook `customer.subscription.deleted` | `plan`, `days_subscribed` | ☐ |

Replace `[core_action]` with the product's activation event (e.g. `invoice_sent`).

## Derived metrics

- **Activation rate** = users with `[core_action]_completed` ÷ `user_signed_up` — target >40%
- **Conversion rate** = `subscription_started` ÷ `user_signed_up`
- **Retention proxy** = users with `[core_action]_repeated` ÷ users with `[core_action]_completed` — target >30%
- **Churn** = `subscription_cancelled` in period ÷ active subscribers

## Identify calls

On sign-in: `identify(userId, { email, plan, created_at })`.
Server-side events (webhooks) use `distinctId: userId` — same ID as client-side, or funnels break.

## Weekly review (Monday, 15 min)

1. Activation rate vs. last week — if down, watch session replays of non-activated signups
2. Funnel: signup → core action — where's the drop-off step?
3. Any unexpected payer? Reply to them within 24h and ask what triggered it
