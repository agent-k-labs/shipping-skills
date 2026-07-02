#!/usr/bin/env bash
# Validate every skill against the Agent Skills spec (agentskills.io/specification).
# Checks: SKILL.md exists, frontmatter present, name matches directory, name format,
# description present and <= 1024 chars, body <= 500 lines, no legacy fields.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
errors=0
checked=0

fail() {
  echo "  ✗ $1"
  errors=$((errors + 1))
}

for dir in "$SKILLS_DIR"/*/; do
  skill="$(basename "$dir")"
  file="$dir/SKILL.md"
  checked=$((checked + 1))
  echo "• $skill"

  if [[ ! -f "$file" ]]; then
    fail "missing SKILL.md"
    continue
  fi

  # Extract frontmatter (between the first pair of --- lines)
  frontmatter="$(awk '/^---$/{n++; next} n==1{print} n>=2{exit}' "$file")"
  if [[ -z "$frontmatter" ]]; then
    fail "no YAML frontmatter found"
    continue
  fi

  # name: required, must match directory, kebab-case rules
  name="$(echo "$frontmatter" | sed -n 's/^name:[[:space:]]*//p' | head -1)"
  if [[ -z "$name" ]]; then
    fail "missing required field: name"
  else
    [[ "$name" == "$skill" ]] || fail "name '$name' does not match directory '$skill'"
    [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "name '$name' violates naming rules (lowercase alphanumeric + single hyphens)"
    [[ ${#name} -le 64 ]] || fail "name exceeds 64 characters"
  fi

  # description: required, 1-1024 chars
  description="$(echo "$frontmatter" | sed -n 's/^description:[[:space:]]*//p' | head -1)"
  if [[ -z "$description" ]]; then
    fail "missing required field: description"
  else
    [[ ${#description} -le 1024 ]] || fail "description exceeds 1024 characters (${#description})"
    [[ ${#description} -ge 40 ]] || fail "description is too short to be useful (${#description} chars) — say what it does AND when to use it"
  fi

  # Legacy slash-command fields that are not part of the spec
  echo "$frontmatter" | grep -q '^argument-hint:' && fail "legacy field 'argument-hint' is not part of the Agent Skills spec"

  # Body size (spec recommends < 500 lines)
  lines="$(wc -l < "$file" | tr -d ' ')"
  [[ "$lines" -le 500 ]] || fail "SKILL.md is $lines lines (keep under 500; move detail to references/)"

  # Referenced local files must exist
  for ref in $(grep -oE '\((assets|references|scripts)/[^)]+\)' "$file" | tr -d '()'); do
    [[ -e "$dir/$ref" ]] || fail "referenced file does not exist: $ref"
  done

  # evals.json, if present, must be valid JSON
  if [[ -f "$dir/evals/evals.json" ]]; then
    python3 -c "import json,sys; json.load(open('$dir/evals/evals.json'))" 2>/dev/null \
      || fail "evals/evals.json is not valid JSON"
  fi
done

echo ""
if [[ $errors -gt 0 ]]; then
  echo "FAIL: $errors error(s) across $checked skill(s)"
  exit 1
fi
echo "OK: $checked skill(s) valid"
