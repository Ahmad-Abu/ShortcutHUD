#!/bin/bash
# Builds AppIcon.icns from a 1024x1024 master PNG.
# Usage: tools/make_icns.sh <master.png> <output.icns>
set -e

MASTER="${1:-tools/icon_master.png}"
OUTPUT="${2:-tools/AppIcon.icns}"
ICONSET=$(mktemp -d)/AppIcon.iconset
mkdir -p "$ICONSET"

# Apple's required .icns sizes (point size @ scale -> pixel size)
# Filename convention: icon_<points>x<points>[@2x].png
sips -z 16 16     "$MASTER" --out "$ICONSET/icon_16x16.png"        > /dev/null
sips -z 32 32     "$MASTER" --out "$ICONSET/icon_16x16@2x.png"     > /dev/null
sips -z 32 32     "$MASTER" --out "$ICONSET/icon_32x32.png"        > /dev/null
sips -z 64 64     "$MASTER" --out "$ICONSET/icon_32x32@2x.png"     > /dev/null
sips -z 128 128   "$MASTER" --out "$ICONSET/icon_128x128.png"      > /dev/null
sips -z 256 256   "$MASTER" --out "$ICONSET/icon_128x128@2x.png"   > /dev/null
sips -z 256 256   "$MASTER" --out "$ICONSET/icon_256x256.png"      > /dev/null
sips -z 512 512   "$MASTER" --out "$ICONSET/icon_256x256@2x.png"   > /dev/null
sips -z 512 512   "$MASTER" --out "$ICONSET/icon_512x512.png"      > /dev/null
sips -z 1024 1024 "$MASTER" --out "$ICONSET/icon_512x512@2x.png"   > /dev/null

iconutil --convert icns "$ICONSET" --output "$OUTPUT"
rm -rf "$ICONSET"
echo "Wrote $OUTPUT ($(ls -lh "$OUTPUT" | awk '{print $5}'))"
