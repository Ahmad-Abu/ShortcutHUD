#!/bin/bash
# Builds a distributable ShortcutHUD.dmg with a universal (Intel + Apple Silicon)
# release binary, the app icon embedded, and ad-hoc code signing.
#
# Usage:   VERSION=1.0.0 ./package_release.sh
# Outputs: dist/ShortcutHUD-<version>.dmg
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION="${VERSION:-1.0.0}"
APP_NAME="ShortcutHUD"
BUNDLE_ID="com.shortcuthud.app"

DIST_DIR="$SCRIPT_DIR/dist"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
DMG_PATH="$DIST_DIR/$APP_NAME-$VERSION.dmg"
STAGING="$DIST_DIR/dmg-staging"

echo "=== Cleaning previous build ==="
rm -rf "$DIST_DIR" "$STAGING"
mkdir -p "$DIST_DIR"

echo ""
echo "=== Building universal release binary ==="
if swift build -c release --arch arm64 --arch x86_64 2>&1; then
    BINARY="$SCRIPT_DIR/.build/apple/Products/Release/$APP_NAME"
    BUILD_KIND="universal (arm64 + x86_64)"
else
    echo "Universal build failed — falling back to native arch only."
    swift build -c release
    BINARY="$SCRIPT_DIR/.build/release/$APP_NAME"
    BUILD_KIND="native arch only"
fi

if [ ! -f "$BINARY" ]; then
    echo "ERROR: expected binary not found at $BINARY"
    exit 1
fi
echo "Built: $BINARY ($BUILD_KIND)"
echo "Arches: $(lipo -archs "$BINARY" 2>/dev/null || file -b "$BINARY")"

echo ""
echo "=== Packaging .app bundle ==="
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"
cp "$BINARY" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
strip -x "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

# Ensure the icon exists, generate if missing
if [ ! -f "$SCRIPT_DIR/tools/AppIcon.icns" ]; then
    echo "Generating app icon..."
    swift "$SCRIPT_DIR/tools/make_icon.swift" "$SCRIPT_DIR/tools/icon_master.png"
    "$SCRIPT_DIR/tools/make_icns.sh" "$SCRIPT_DIR/tools/icon_master.png" "$SCRIPT_DIR/tools/AppIcon.icns"
fi
cp "$SCRIPT_DIR/tools/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"

cat > "$APP_BUNDLE/Contents/Info.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleDisplayName</key>
    <string>$APP_NAME</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
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

echo ""
echo "=== Signing (ad-hoc, stable identifier) ==="
codesign --force --sign - --identifier "$BUNDLE_ID" --options runtime --timestamp=none "$APP_BUNDLE"
codesign --verify --strict --verbose=2 "$APP_BUNDLE"

echo ""
echo "=== Staging DMG contents ==="
mkdir -p "$STAGING"
cp -R "$APP_BUNDLE" "$STAGING/"
ln -s /Applications "$STAGING/Applications"
# Include install instructions inside the DMG
if [ -f "$SCRIPT_DIR/INSTALL.md" ]; then
    cp "$SCRIPT_DIR/INSTALL.md" "$STAGING/INSTALL.md"
fi

echo ""
echo "=== Creating DMG ==="
hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$STAGING" \
    -ov \
    -format UDZO \
    -fs HFS+ \
    "$DMG_PATH" > /dev/null

rm -rf "$STAGING"

DMG_SIZE=$(du -h "$DMG_PATH" | awk '{print $1}')
echo ""
echo "==============================================="
echo "Release packaged"
echo "==============================================="
echo "  App:     $APP_BUNDLE"
echo "  DMG:     $DMG_PATH"
echo "  Size:    $DMG_SIZE"
echo "  Version: $VERSION"
echo "  Build:   $BUILD_KIND"
echo ""
echo "Next: upload $DMG_PATH to your hosting (S3, website)."
echo "Users: see INSTALL.md for first-launch instructions."
