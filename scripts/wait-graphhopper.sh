#!/usr/bin/env bash
set -euo pipefail

pid="$1"
log="$2"
for _ in $(seq 1 7200); do
  status="$(timeout 3 bash -c 'exec 3<>/dev/tcp/127.0.0.1/8989; printf "GET /info HTTP/1.0\r\nHost: localhost\r\n\r\n" >&3; head -n 1 <&3' 2>/dev/null || true)"
  if [[ "$status" == *" 200 "* ]]; then
    kill "$pid"
    wait "$pid" || true
    exit 0
  fi
  if ! kill -0 "$pid" 2>/dev/null; then
    cat "$log"
    exit 1
  fi
  sleep 1
done
kill "$pid"
exit 124

