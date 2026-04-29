#!/bin/sh
set -eu

ROOT="$(git rev-parse --show-toplevel)"
git -C "$ROOT" config core.hooksPath .githooks
chmod +x "$ROOT/.githooks/pre-commit"

echo "Git hooks installed: core.hooksPath=.githooks"
