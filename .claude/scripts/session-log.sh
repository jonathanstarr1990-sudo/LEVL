#!/usr/bin/env bash
# Reads PostCompact summary from stdin and saves a dated session log to session-logs/
set -euo pipefail

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H%M)
OUTFILE="session-logs/${DATE}-${TIME}.md"

# Read the PostCompact JSON payload from stdin
PAYLOAD=$(cat)
SUMMARY=$(echo "$PAYLOAD" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('summary', d.get('compaction_summary', '')))
except:
    print('')
" 2>/dev/null || echo "")

cat > "$OUTFILE" <<EOF
---
date: ${DATE}
tags: [LEVL, session-log]
project: LEVL
---

# LEVL Session Log — ${DATE}

## Summary
${SUMMARY:-No summary captured. Add notes manually.}

## Notes

_Add any additional context here._

EOF

git add "$OUTFILE"
git commit -m "Add session log ${DATE}-${TIME}" --no-verify 2>/dev/null || true
git push -u origin gh-pages 2>/dev/null || true

echo "{\"systemMessage\": \"Session log saved → session-logs/${DATE}-${TIME}.md\"}"
