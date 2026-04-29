#!/bin/sh
set -eu

ROOT="${SRCROOT:-}"
if [ -z "$ROOT" ]; then
    ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fi

CONFIG="$ROOT/.swiftformat"

if command -v swiftformat >/dev/null 2>&1; then
    SWIFTFORMAT="$(command -v swiftformat)"
elif [ -x /opt/homebrew/bin/swiftformat ]; then
    SWIFTFORMAT="/opt/homebrew/bin/swiftformat"
elif [ -x /usr/local/bin/swiftformat ]; then
    SWIFTFORMAT="/usr/local/bin/swiftformat"
else
    echo "error: SwiftFormat is not installed. Install it with: brew install swiftformat" >&2
    exit 1
fi

if [ ! -f "$CONFIG" ]; then
    echo "error: Missing SwiftFormat config at $CONFIG" >&2
    exit 1
fi

FOUND=0
for path in "$ROOT/OpenMac" "$ROOT/OpenMacTests" "$ROOT/OpenMacUITests"; do
    if [ -e "$path" ]; then
        FOUND=1
        "$SWIFTFORMAT" --config "$CONFIG" --quiet "$path"
    fi
done

if [ "$FOUND" -eq 0 ]; then
    echo "warning: No Swift source directories found for SwiftFormat" >&2
fi
