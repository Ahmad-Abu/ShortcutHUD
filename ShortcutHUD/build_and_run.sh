#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Use ~/Applications so the path is stable across reboots (unlike /tmp)
APP_BUNDLE="$HOME/Applications/ShortcutHUD.app"

echo "Building..."
swift build --configuration debug

echo "Packaging .app bundle..."
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cp "$SCRIPT_DIR/.build/arm64-apple-macosx/debug/ShortcutHUD" "$APP_BUNDLE/Contents/MacOS/"

# Generate the icon on first run (or if missing) and copy into the bundle
if [ ! -f "$SCRIPT_DIR/tools/AppIcon.icns" ]; then
    echo "Generating app icon..."
    swift "$SCRIPT_DIR/tools/make_icon.swift" "$SCRIPT_DIR/tools/icon_master.png"
    "$SCRIPT_DIR/tools/make_icns.sh" "$SCRIPT_DIR/tools/icon_master.png" "$SCRIPT_DIR/tools/AppIcon.icns"
fi
cp "$SCRIPT_DIR/tools/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"

cat > "$APP_BUNDLE/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>ShortcutHUD</string>
    <key>CFBundleIdentifier</key>
    <string>com.shortcuthud.app</string>
    <key>CFBundleName</key>
    <string>ShortcutHUD</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSAccessibilityUsageDescription</key>
    <string>ShortcutHUD monitors keyboard shortcuts to track which ones you use, so it can retire learned shortcuts and show new ones.</string>
</dict>
</plist>
PLIST

# Ad-hoc sign so macOS treats it as a consistent identity
codesign --force --sign - --identifier com.shortcuthud.app "$APP_BUNDLE" 2>/dev/null || true

pkill -x ShortcutHUD 2>/dev/null || true
sleep 0.5

echo "Launching..."
open "$APP_BUNDLE"
echo "Done — ShortcutHUD launched. If prompted for Accessibility, grant it then QUIT and relaunch from menu bar."
