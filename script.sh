#!/usr/bin/env bash
set -eo pipefail
#
## kdeactivate (bash)
#
# Usage:
#   kdeactivate <class/executable> [args...]
#
# <class/executable> is used as the KWin window class to search, and as
# the command to run if no window is found.

# Require a class/executable name
if [ $# -lt 1 ]; then
  echo "Usage: $(basename "$0") <class/executable> [args...]" >&2
  exit 1
fi

CLASS="$1"
shift

# Focus app if already running (pick the first match)
WINDOW="$(kdotool search --class "$CLASS" 2>/dev/null | head -n1 || true)"
if [ -n "$WINDOW" ]; then
  kdotool windowactivate "$WINDOW"
  exit 0
fi

cd "$HOME"

# Launch the app if it's on PATH; otherwise try desktop entry via gtk-launch
if exe="$(command -v "$CLASS" 2>/dev/null)" && [ -x "$exe" ]; then
  exec "$exe" "$@"
else
  # gtk-launch expects the desktop entry name (no args)
  exec gtk-launch "$CLASS"
fi
