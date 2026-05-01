#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="${OPENMAC_PROJECT:-$ROOT/OpenMac.xcodeproj}"
SCHEME="${OPENMAC_SCHEME:-OpenMac}"
CONFIGURATION="${OPENMAC_CONFIGURATION:-Debug}"
DESTINATION="${OPENMAC_DESTINATION:-platform=macOS}"
DERIVED_DATA_PATH="${OPENMAC_DERIVED_DATA_PATH:-$ROOT/.build/DerivedData}"
APP_NAME="${OPENMAC_APP_NAME:-OpenMac.app}"
CLEAN=0
BUILD_ONLY=0
STOP_ONLY=0
VERBOSE=0
EXECUTABLE_NAME="${OPENMAC_EXECUTABLE_NAME:-${APP_NAME%.app}}"

usage() {
  cat <<'EOF'
Usage: Scripts/vscode-run.sh [options]

Build and launch the OpenMac macOS app from VS Code or a terminal.

Options:
  --clean             Clean before building.
  --build-only        Build without launching the app.
  --stop              Stop all running OpenMac app instances, then exit.
  --configuration N   Xcode configuration to build. Default: Debug.
  --destination D     Xcode destination. Default: platform=macOS.
  --verbose           Show full xcodebuild output. Default output is quiet.
  -h, --help          Show this help.

Environment overrides:
  OPENMAC_PROJECT
  OPENMAC_SCHEME
  OPENMAC_CONFIGURATION
  OPENMAC_DESTINATION
  OPENMAC_DERIVED_DATA_PATH
  OPENMAC_APP_NAME
  OPENMAC_EXECUTABLE_NAME
EOF
}

stop_running_app() {
  local pids=""

  pids="$(pgrep -x "$EXECUTABLE_NAME" 2>/dev/null || true)"
  if [[ -z "$pids" ]]; then
    return 0
  fi

  echo "==> Stopping running $EXECUTABLE_NAME instance(s): ${pids//$'\n'/ }"
  kill $pids 2>/dev/null || true

  for _ in {1..50}; do
    pids="$(pgrep -x "$EXECUTABLE_NAME" 2>/dev/null || true)"
    if [[ -z "$pids" ]]; then
      return 0
    fi
    sleep 0.1
  done

  echo "==> Force stopping $EXECUTABLE_NAME instance(s)"
  kill -9 $pids 2>/dev/null || true
}

on_exit_signal() {
  echo "==> VS Code requested stop/disconnect; closing $EXECUTABLE_NAME"
  stop_running_app
  exit 130
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --clean)
      CLEAN=1
      shift
      ;;
    --build-only)
      BUILD_ONLY=1
      shift
      ;;
    --stop)
      STOP_ONLY=1
      shift
      ;;
    --configuration)
      CONFIGURATION="${2:?Missing value for --configuration}"
      shift 2
      ;;
    --destination)
      DESTINATION="${2:?Missing value for --destination}"
      shift 2
      ;;
    --verbose)
      VERBOSE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "$STOP_ONLY" -eq 1 ]]; then
  stop_running_app
  exit 0
fi

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "error: xcodebuild is required but was not found." >&2
  exit 1
fi

if [[ ! -d "$PROJECT" ]]; then
  echo "error: Xcode project not found at: $PROJECT" >&2
  exit 1
fi

BUILD_ARGS=(
  -project "$PROJECT"
  -scheme "$SCHEME"
  -configuration "$CONFIGURATION"
  -destination "$DESTINATION"
  -derivedDataPath "$DERIVED_DATA_PATH"
)

if [[ "$VERBOSE" -eq 0 ]]; then
  BUILD_ARGS=(-quiet "${BUILD_ARGS[@]}")
fi

if [[ "$CLEAN" -eq 1 ]]; then
  echo "==> Cleaning $SCHEME ($CONFIGURATION)"
  xcodebuild "${BUILD_ARGS[@]}" clean
fi

echo "==> Building $SCHEME ($CONFIGURATION)"
xcodebuild "${BUILD_ARGS[@]}" build

APP_PATH="$DERIVED_DATA_PATH/Build/Products/$CONFIGURATION/$APP_NAME"

if [[ ! -d "$APP_PATH" ]]; then
  echo "error: Built app was not found at: $APP_PATH" >&2
  exit 1
fi

if [[ "$BUILD_ONLY" -eq 1 ]]; then
  echo "==> Build complete: $APP_PATH"
  exit 0
fi

stop_running_app

echo "==> Launching $APP_PATH"
trap on_exit_signal INT TERM HUP
open -n -W "$APP_PATH" &
OPEN_PID=$!
wait "$OPEN_PID"
