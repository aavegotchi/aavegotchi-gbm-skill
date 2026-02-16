#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "README.md"
  "AGENTS.md"
  "aavegotchi-gbm-skill/SKILL.md"
  "aavegotchi-gbm-skill/references/addresses.md"
  "aavegotchi-gbm-skill/references/subgraph.md"
  "aavegotchi-gbm-skill/references/recipes.md"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file" >&2
    exit 1
  fi
done

if ! grep -q '^# ' README.md; then
  echo "README.md must contain a top-level heading." >&2
  exit 1
fi

if ! grep -q '^## ' aavegotchi-gbm-skill/SKILL.md; then
  echo "SKILL.md must contain at least one section heading." >&2
  exit 1
fi

echo "fast-check passed"
