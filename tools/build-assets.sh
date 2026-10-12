#!/usr/bin/env bash
#
# Render the Vishwa Linux SVG sources into the PNG files that live-build
# copies into the ISO. Requires: rsvg-convert (librsvg2-bin).
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASSETS="$ROOT/assets"

CHROOT="$ROOT/config/includes.chroot"
BINARY="$ROOT/config/includes.binary"

BG="$CHROOT/usr/share/backgrounds/vishwa"
PIXMAPS="$CHROOT/usr/share/pixmaps"
ICONS="$CHROOT/usr/share/icons/hicolor/scalable/apps"
PLYMOUTH="$CHROOT/usr/share/plymouth/themes/vishwa"
SKEL="$CHROOT/etc/skel"
BOOT="$BINARY/vishwa-boot"

command -v rsvg-convert >/dev/null 2>&1 || {
	echo "rsvg-convert not found (install librsvg2-bin)" >&2
	exit 1
}

mkdir -p "$BG" "$PIXMAPS" "$ICONS" "$PLYMOUTH" "$SKEL" "$BOOT"

render() { # render <src> <out> <width> <height>
	rsvg-convert -w "$3" -h "$4" -o "$2" "$1"
	echo "  rendered $(basename "$2") (${3}x${4})"
}

echo "Vishwa: generating desktop assets..."
render "$ASSETS/wallpaper.svg"       "$BG/vishwa-wallpaper.png"       1920 1080
render "$ASSETS/wallpaper.svg"       "$BG/vishwa-login.png"           1920 1080

echo "Vishwa: generating logo assets..."
render "$ASSETS/logo.svg"            "$PIXMAPS/vishwa-logo.png"        256  256
render "$ASSETS/logo.svg"            "$PLYMOUTH/logo.png"              256  256
render "$ASSETS/logo.svg"            "$SKEL/.face"                     256  256
cp -f "$ASSETS/logo.svg"             "$ICONS/vishwa-logo.svg"
echo "  copied vishwa-logo.svg"

echo "Vishwa: generating bootloader assets..."
render "$ASSETS/grub-splash.svg"     "$BOOT/grub-splash.png"           800  600
render "$ASSETS/syslinux-splash.svg" "$BOOT/syslinux-splash.png"       640  480

echo "Vishwa: assets done."
