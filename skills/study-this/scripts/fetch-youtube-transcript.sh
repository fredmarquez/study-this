#!/usr/bin/env bash
set -euo pipefail

# fetch-youtube-transcript.sh <youtube-url>
# Emits plain-text transcript to stdout. Non-zero exit on failure.

url="${1:?Usage: $0 <youtube-url>}"

if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "ERROR: yt-dlp not installed. Run: brew install yt-dlp" >&2
  exit 2
fi

tmp=$(mktemp -d)
trap "rm -rf '$tmp'" EXIT

cd "$tmp"
if ! yt-dlp \
  --write-auto-sub \
  --skip-download \
  --sub-format vtt \
  --sub-lang en \
  -o '%(id)s.%(ext)s' \
  "$url" >&2; then
  echo "ERROR: yt-dlp could not fetch captions (geo-block, no captions, or age-gated)" >&2
  exit 3
fi

vtt=$(ls *.vtt 2>/dev/null | head -1)
if [[ -z "$vtt" ]]; then
  echo "ERROR: no caption file produced" >&2
  exit 4
fi

# VTT -> plain text: drop WEBVTT header, cue identifiers, timecodes, blanks;
# then dedupe consecutive duplicate lines (auto-captions often repeat).
awk '
  /^WEBVTT/      { next }
  /^[0-9]+$/     { next }
  /-->/          { next }
  /^$/           { next }
  /^NOTE/        { next }
  /^STYLE/       { next }
                 { print }
' "$vtt" | awk 'prev != $0 { print } { prev = $0 }'
