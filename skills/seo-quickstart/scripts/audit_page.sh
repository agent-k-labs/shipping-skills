#!/usr/bin/env bash
# audit_page.sh — on-page SEO audit for a single URL.
# Usage: bash audit_page.sh https://yourdomain.com[/path]
# Reports: title/meta lengths, H1s, OG tags, canonical, robots.txt (incl. AI
# crawlers), sitemap, llms.txt. Pair with SKILL.md's keyword and content steps.
set -uo pipefail

URL="${1:-}"
[[ -z "$URL" ]] && { echo "Usage: bash audit_page.sh https://yourdomain.com/page"; exit 1; }
[[ "$URL" != http* ]] && URL="https://$URL"
ORIGIN="$(echo "$URL" | grep -oE 'https?://[^/]+')"

fetch() { curl -sL --max-time 15 -A "shipping-skills-seo/1.0" "$1" 2>/dev/null; }
status() { curl -s -o /dev/null -w "%{http_code}" -L --max-time 15 -A "shipping-skills-seo/1.0" "$1" 2>/dev/null; }

html="$(fetch "$URL")"
[[ -z "$html" ]] && { echo "Could not fetch $URL"; exit 1; }

echo "SEO audit: $URL"
echo ""
echo "— Title & description —"
title="$(echo "$html" | grep -oiE '<title[^>]*>[^<]*' | head -1 | sed -E 's/<title[^>]*>//')"
if [[ -n "$title" ]]; then
  echo "  title (${#title} chars, aim 50–60): $title"
else
  echo "  🔴 no <title> tag"
fi
desc="$(echo "$html" | tr '\n' ' ' | grep -oiE '<meta[^>]+name=["'\'']description["'\''][^>]*>' | head -1 | grep -oiE 'content=["'\''][^"'\'']*' | sed -E 's/content=["'\'']//')"
if [[ -n "$desc" ]]; then
  echo "  description (${#desc} chars, aim 120–160): $desc"
else
  echo "  🔴 no meta description"
fi

echo ""
echo "— Headings —"
h1_count="$(echo "$html" | grep -oiE '<h1[ >]' | wc -l | tr -d ' ')"
h1_text="$(echo "$html" | tr '\n' ' ' | grep -oiE '<h1[^>]*>[^<]*' | head -1 | sed -E 's/<h1[^>]*>//' | sed -E 's/^ +| +$//g')"
case "$h1_count" in
  0) echo "  🔴 no H1 on the page" ;;
  1) echo "  ✅ one H1: $h1_text" ;;
  *) echo "  🟡 $h1_count H1s (should be exactly one). First: $h1_text" ;;
esac

echo ""
echo "— Social & canonical —"
for tag in "og:title" "og:description" "og:image" "og:url"; do
  echo "$html" | grep -qiE "property=[\"']$tag" && echo "  ✅ $tag" || echo "  🔴 missing $tag"
done
canon="$(echo "$html" | tr '\n' ' ' | grep -oiE '<link[^>]+rel=["'\'']canonical["'\''][^>]*>' | grep -oiE 'href=["'\''][^"'\'']*' | sed -E 's/href=["'\'']//')"
[[ -n "$canon" ]] && echo "  ✅ canonical: $canon" || echo "  🟡 no canonical link"

echo ""
echo "— Crawlability ($ORIGIN) —"
robots="$(fetch "$ORIGIN/robots.txt")"
if [[ -n "$robots" ]] && echo "$robots" | grep -qiE '^(user-agent|sitemap|allow|disallow)'; then
  echo "  ✅ robots.txt present"
  echo "$robots" | grep -qi 'sitemap:' && echo "  ✅ robots.txt declares sitemap" || echo "  🟡 robots.txt has no Sitemap: line"
  for bot in GPTBot ClaudeBot PerplexityBot; do
    if echo "$robots" | grep -qi "$bot"; then
      echo "  ℹ️  robots.txt mentions $bot (verify it's Allow, not Disallow)"
    fi
  done
else
  echo "  🟡 no robots.txt"
fi
[[ "$(status "$ORIGIN/sitemap.xml")" == "200" ]] && echo "  ✅ sitemap.xml" || echo "  🟡 no sitemap.xml"
[[ "$(status "$ORIGIN/llms.txt")" == "200" ]] && echo "  ✅ llms.txt (AI search)" || echo "  🟡 no llms.txt — see SKILL.md step 5"
echo "$html" | grep -qiE 'noindex' && echo "  🔴 page contains 'noindex'" || echo "  ✅ no noindex"

echo ""
echo "Next: run the keyword targeting step in SKILL.md against this page's topic."
