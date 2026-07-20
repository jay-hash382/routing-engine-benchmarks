#!/usr/bin/env bash
set -euo pipefail

name="$1"
report="$2"
shift 2

mkdir -p "$(dirname "$report")"
cid="$(docker create --memory=14g --cpus=4 "$@")"
cleanup() { docker rm -f "$cid" >/dev/null 2>&1 || true; }
trap cleanup EXIT

started="$(date +%s)"
docker start "$cid" >/dev/null
peak=0
while [ "$(docker inspect -f '{{.State.Running}}' "$cid")" = "true" ]; do
  bytes="$(docker exec "$cid" sh -c 'cat /sys/fs/cgroup/memory.peak 2>/dev/null || cat /sys/fs/cgroup/memory.current 2>/dev/null || echo 0' 2>/dev/null || echo 0)"
  [[ "$bytes" =~ ^[0-9]+$ ]] || bytes=0
  [ "$bytes" -gt "$peak" ] && peak="$bytes"
  sleep 1
done
status="$(docker inspect -f '{{.State.ExitCode}}' "$cid")"
finished="$(date +%s)"
docker logs "$cid" > "${report%.json}.log" 2>&1 || true

jq -n \
  --arg engine "$name" \
  --argjson exit_code "$status" \
  --argjson wall_seconds "$((finished-started))" \
  --argjson peak_memory_bytes "$peak" \
  '{engine:$engine,exit_code:$exit_code,wall_seconds:$wall_seconds,peak_memory_bytes:$peak_memory_bytes}' > "$report"

if [ "$status" -ne 0 ]; then
  tail -n 100 "${report%.json}.log"
  exit "$status"
fi
