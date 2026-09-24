#!/bin/bash
# Post-restart verifier: waits for ddagent to come back, then runs the UI matrix.
# Launched via systemd-run --uid=opencode (outside ddagent.service cgroup).
export HOME=/home/opencode
export PATH=/home/opencode/.nvm/versions/node/v24.20.0/bin:/usr/local/bin:/usr/bin:/bin
cd /workspace/ddagent-src || exit 1

echo "verifier started $(date -Is) — waiting for ddagent restart to finish"
sleep 20
for i in $(seq 1 80); do
  if curl -sf -o /dev/null http://127.0.0.1:10087/; then
    echo "ddagent up after ${i} polls"
    break
  fi
  sleep 3
done
# give WS auth + registry a moment, then run the matrix
sleep 12
echo "running matrix $(date -Is)"
node ddagent-e2e-matrix.mjs --tag=after > /tmp/e2e-after-run.log 2>&1
echo "matrix done rc=$? $(date -Is)"
