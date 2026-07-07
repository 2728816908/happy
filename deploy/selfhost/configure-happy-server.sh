#!/usr/bin/env bash
set -euo pipefail

SERVER_URL="${1:-}"
HAPPY_HOME_DIR="${HAPPY_HOME_DIR:-$HOME/.happy}"

if [ -z "$SERVER_URL" ]; then
  echo "Usage: ./configure-happy-server.sh https://happy.example.com"
  exit 1
fi

case "$SERVER_URL" in
  http://*|https://*) ;;
  *)
    echo "Server URL must start with http:// or https://"
    exit 1
    ;;
esac

SERVER_URL="${SERVER_URL%/}"
mkdir -p "$HAPPY_HOME_DIR"

cat > "$HAPPY_HOME_DIR/settings.json" <<JSON
{
  "schemaVersion": 2,
  "onboardingCompleted": false,
  "serverUrl": "$SERVER_URL",
  "webappUrl": "$SERVER_URL"
}
JSON

echo "Happy CLI configured:"
echo "  $HAPPY_HOME_DIR/settings.json"
echo "  serverUrl = $SERVER_URL"
echo
echo "Next:"
echo "  happy auth login"
echo "  happy daemon start"
echo "  happy codex"
