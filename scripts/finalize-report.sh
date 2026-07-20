#!/usr/bin/env bash
set -euo pipefail

report="$1"
input="$2"
graph="$3"
graph_bytes="$(du -sb "$graph" | cut -f1)"
input_bytes="$(stat -c %s "$input")"
tmp="${report}.tmp"
jq --argjson input_bytes "$input_bytes" --argjson graph_bytes "$graph_bytes" \
  '. + {input_bytes:$input_bytes,graph_bytes:$graph_bytes,runner_os:"ubuntu-24.04",runner_cpu_count:4}' "$report" > "$tmp"
mv "$tmp" "$report"
cat "$report"

