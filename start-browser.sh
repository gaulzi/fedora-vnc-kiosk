#!/bin/bash
set -e

PROFILE_DIR="/tmp/firefox-profile"

rm -rf "${PROFILE_DIR}" || true
mkdir -p "${PROFILE_DIR}"

URL="${KIOSK_URL:-https://example.com}"

exec firefox \
  --kiosk \
  --no-remote \
  --disable-gpu \
  --private-window \
  --profile "${PROFILE_DIR}" \
  "$URL"