#!/usr/bin/env bash
set -euo pipefail

# fetch-article.sh <url>
# Emits cleaned article text (markdown) to stdout. Used as a fallback when WebFetch
# returns paywalled / SPA / login-page content.

url="${1:?Usage: $0 <url>}"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "ERROR: pandoc not installed. Run: brew install pandoc" >&2
  exit 2
fi

curl -sL \
  --max-time 30 \
  -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15" \
  -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
  -H "Accept-Language: en-US,en;q=0.5" \
  "$url" \
  | pandoc -f html -t markdown --wrap=none 2>/dev/null \
  | awk 'NF || prev { print; prev = NF } !NF { prev = 0 }'
