#!/bin/bash
# Watchdog: periodically verify Firefox has a visible window.
# If not, kill it so supervisord can restart it cleanly.

INTERVAL=30   # seconds between checks
STARTUP_GRACE=20  # wait before first check to allow initial startup

sleep "${STARTUP_GRACE}"

while true; do
    sleep "${INTERVAL}"

    # Nothing to do if Firefox isn't even running (supervisord handles that)
    if ! pgrep -x firefox > /dev/null 2>&1; then
        continue
    fi

    # Check for a visible Firefox window via its WM class
    if ! xdotool search --onlyvisible --class firefox > /dev/null 2>&1; then
        echo "$(date -Iseconds): Firefox has no visible window — killing to trigger restart"
        pkill -9 -x firefox || true
    fi
done
