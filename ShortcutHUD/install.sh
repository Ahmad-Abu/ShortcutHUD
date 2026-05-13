#!/bin/bash
# ShortcutHUD one-line installer.
# Downloads the latest release, removes the Gatekeeper quarantine flag, and
# launches the app. Use:
#
#   curl -fsSL https://raw.githubusercontent.com/Ahmad-Abu/ShortcutHUD/main/ShortcutHUD/install.sh | bash
#
set -euo pipefail

REPO="Ahmad-Abu/ShortcutHUD"
APP_NAME="ShortcutHUD"
INSTALL_PATH="/Applications/${APP_NAME}.app"

echo "ShortcutHUD installer"
echo ""

# ---- Sanity checks --------------------------------------------------------

if [[ "$(uname)" != "Darwin" ]]; then
    echo "Error: this installer only runs on macOS." >&2
    exit 1
fi

if [[ "$(uname -m)" != "arm64" ]]; then
    echo "Error: ShortcutHUD currently requires an Apple Silicon Mac (M1/M2/M3/M4)." >&2
    echo "Intel support is planned for a future release." >&2
    exit 1
fi

MACOS_MAJOR=$(sw_vers -productVersion | cut -d. -f1)
if (( MACOS_MAJOR < 13 )); then
    echo "Error: ShortcutHUD requires macOS 13 (Ventura) or later." >&2
    echo "Detected: $(sw_vers -productVersion)" >&2
    exit 1
fi

# ---- Resolve latest release -----------------------------------------------

echo "Looking up latest release..."
LATEST_JSON=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest")
LATEST_TAG=$(echo "$LATEST_JSON" | awk -F'"' '/"tag_name"/ { print $4; exit }')
if [[ -z "${LATEST_TAG}" ]]; then
    echo "Error: could not determine latest release tag." >&2
    exit 1
fi
VERSION="${LATEST_TAG#v}"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
DMG_URL="https://github.com/${REPO}/releases/download/${LATEST_TAG}/${DMG_NAME}"
echo "Latest: ${LATEST_TAG}"
echo ""

# ---- Download -------------------------------------------------------------

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"; if [[ -n "${MOUNT:-}" ]] && [[ -d "$MOUNT" ]]; then hdiutil detach "$MOUNT" >/dev/null 2>&1 || true; fi' EXIT

DMG_PATH="${TMP}/${DMG_NAME}"
echo "Downloading ${DMG_NAME}..."
curl -fL --progress-bar -o "$DMG_PATH" "$DMG_URL"
echo ""

# ---- Mount + install ------------------------------------------------------

echo "Mounting DMG..."
MOUNT=$(hdiutil attach -nobrowse -readonly "$DMG_PATH" | grep -E '/Volumes/' | tail -1 | awk -F'\t' '{print $NF}')
if [[ -z "${MOUNT}" ]] || [[ ! -d "${MOUNT}/${APP_NAME}.app" ]]; then
    echo "Error: DMG mount or layout was not what we expected." >&2
    exit 1
fi

# Make sure no stale install or running instance gets in the way
if pgrep -x "$APP_NAME" > /dev/null; then
    echo "Quitting running ${APP_NAME}..."
    pkill -x "$APP_NAME" || true
    sleep 1
fi
if [[ -d "$INSTALL_PATH" ]]; then
    echo "Removing previous install..."
    rm -rf "$INSTALL_PATH"
fi

echo "Copying ${APP_NAME}.app to /Applications..."
cp -R "${MOUNT}/${APP_NAME}.app" /Applications/

echo "Removing Gatekeeper quarantine flag..."
xattr -dr com.apple.quarantine "$INSTALL_PATH" 2>/dev/null || true

# ---- Launch ---------------------------------------------------------------

echo "Launching ${APP_NAME}..."
open "$INSTALL_PATH"

echo ""
echo "=============================================="
echo "ShortcutHUD ${LATEST_TAG} installed and launched."
echo ""
echo "Next steps:"
echo "  1. Look for the keyboard icon in your menu bar (top-right of screen)."
echo "  2. When prompted, grant Accessibility permission in:"
echo "     System Settings -> Privacy & Security -> Accessibility"
echo "  3. Quit and relaunch ShortcutHUD after granting permission."
echo "=============================================="
