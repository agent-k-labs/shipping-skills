#!/usr/bin/env bash
# check_site.sh — automated pre-launch site checks (the ones curl can verify).
# Usage: bash check_site.sh https://yourdomain.com
# Covers: HTTPS, redirect, OG tags, title/meta, favicon, robots.txt, sitemap,
# 404 handling, viewport meta. Human checks (flows, emails, copy) stay in SKILL.md.
set -uo pipefail

URL="${1:-}"
[[ -z "$URL" ]] && { echo "Usage: bash check_site.sh https://yourdomain.com"; exit 1; }
URL="${URL%/}"
[[ "$URL" != http* ]] && URL="https://$URL"
HOST="$(echo "$URL" | sed -E 's#https?://##; s#/.*##')"

pass=0; fail=0
ok()   { echo "  ✅ $1"; pass=$((pass+1)); }
bad()  { echo "  🔴 $1"; fail=$((fail+1)); }
warn() { echo "  🟡 $1"; }

fetch() { curl -sL --max-time 15 -A "shipping-skills-check/1.0" "$1" 2>/dev/null; }
status() { curl -s -o /dev/null -w "%{http_code}" -L --max-time 15 -A "shipping-skills-check/1.0" "$1" 2>/dev/null; }

echo "Checking $URL"
echo ""
echo "— HTTPS & availability —"
code="$(status "$URL")"
[[ "$code" == "200" ]] && ok "site responds 200" || bad "site returned HTTP $code"

http_redirect="$(curl -s -o /dev/null -w "%{redirect_url}" --max-time 15 "http://$HOST" 2>/dev/null)"
[[ "$http_redirect" == https://* ]] && ok "http:// redirects to https://" || bad "http:// does not redirect to https://"

echo ""
echo "— Homepage HTML —"
html="$(fetch "$URL")"

title="$(echo "$html" | grep -oiE '<title[^>]*>[^<]*' | head -1 | sed -E 's/<title[^>]*>//')"
if [[ -n "$title" ]]; then
  len=${#title}
  if (( len >= 15 && len <= 70 )); then ok "title tag ($len chars): $title"
  else warn "title tag is $len chars (aim 50–60): $title"; fi
else
  bad "no <title> tag"
fi

echo "$html" | grep -qiE '<meta[^>]+name=["'\'']description' && ok "meta description present" || bad "no meta description"
echo "$html" | grep -qiE '<meta[^>]+property=["'\'']og:title' && ok "og:title present" || bad "no og:title (link previews will be blank)"
echo "$html" | grep -qiE '<meta[^>]+property=["'\'']og:image' && ok "og:image present" || bad "no og:image (shares on X/Slack/LinkedIn show no card)"
echo "$html" | grep -qiE '<meta[^>]+name=["'\'']viewport' && ok "viewport meta present (mobile)" || bad "no viewport meta — mobile layout will break"
echo "$html" | grep -qiE '<link[^>]+rel=["'\''][^"'\'']*canonical' && ok "canonical link present" || warn "no canonical link"
echo "$html" | grep -qiE 'noindex' && bad "page contains 'noindex' — search engines will skip it" || ok "no noindex directive"

echo ""
echo "— Supporting files —"
fav_code="$(status "$URL/favicon.ico")"
if [[ "$fav_code" == "200" ]] || echo "$html" | grep -qiE '<link[^>]+rel=["'\''][^"'\'']*icon'; then
  ok "favicon present"
else
  bad "no favicon found"
fi

robots="$(fetch "$URL/robots.txt")"
if [[ -n "$robots" ]] && echo "$robots" | grep -qiE '^(user-agent|sitemap|allow|disallow)'; then
  ok "robots.txt present"
  echo "$robots" | grep -qiE '^disallow:\s*/$' && bad "robots.txt disallows the entire site!"
else
  warn "no robots.txt"
fi

sm_code="$(status "$URL/sitemap.xml")"
[[ "$sm_code" == "200" ]] && ok "sitemap.xml present" || warn "no sitemap.xml at /sitemap.xml"

nf_code="$(status "$URL/shipping-skills-404-probe-$RANDOM")"
if [[ "$nf_code" == "404" ]]; then ok "unknown paths return 404"
elif [[ "$nf_code" == "200" ]]; then warn "unknown path returned 200 — soft-404s confuse crawlers"
else warn "unknown path returned HTTP $nf_code"; fi

echo ""
echo "Result: $pass passed, $fail failed. 🔴 items are launch blockers; 🟡 fix this week."
[[ $fail -gt 0 ]] && exit 1 || exit 0
