#!/usr/bin/env bash
# Kills tmux sessions that have been idle for longer than N minutes.
# Safe defaults + a few knobs you can tweak with env vars.

set -euo pipefail

# --- knobs -------------------------------------------------------------------
# Idle threshold (minutes) before a session is considered stale
: "${TOO_OLD_THRESHOLD_MIN:=180}"

# Don't kill sessions that are currently attached (safer default)
: "${KILL_ATTACHED:=0}"

# Log file (for visibility)
: "${TMUX_CLEANUP_LOG:=/tmp/tmuxKillSessions.log}"
# -----------------------------------------------------------------------------

# Exit early if no tmux sessions exist
if ! tmux list-sessions >/dev/null 2>&1; then
    exit 0
fi

now_epoch="$(date +%s)"
killed_any=0

# tmux format:
#   #{session_name} #{session_activity} #{?session_attached,1,0}
# session_activity is epoch seconds of last activity
tmux list-sessions -F '#{session_name} #{session_activity} #{?session_attached,1,0}' 2>/dev/null \
| while read -r name last attached; do
    # skip empty lines
    [[ -z "${name:-}" || -z "${last:-}" || -z "${attached:-}" ]] && continue

    # attached check
    if [[ "$attached" == "1" && "$KILL_ATTACHED" != "1" ]]; then
        continue
    fi

    # compute idle minutes
    idle_min=$(( (now_epoch - last) / 60 ))
    if (( idle_min > TOO_OLD_THRESHOLD_MIN )); then
        ts="$(date '+%Y-%m-%d %H:%M:%S')"
        echo "$ts - Killed session: $name (idle ${idle_min}m)" | tee -a "$TMUX_CLEANUP_LOG" || true
        tmux kill-session -t "$name" 2>/dev/null || true
        killed_any=1
    fi
done

exit 0