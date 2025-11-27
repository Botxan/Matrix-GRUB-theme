#!/bin/bash

THEME_NAME="Matrix"
THEME_DIR="/boot/grub/themes/$THEME_NAME"
GRUB_DEFAULT_CONF="/etc/default/grub"
GRUB_CUSTOM_FILE="/etc/grub.d/40_custom"

echo "--- Matrix GRUB Theme Installer ---"

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo ./installer.sh"
    exit 1
fi

# 1. Create directory structure
echo "[1/7] Creating theme directory..."
mkdir -p "$THEME_DIR/assets"

# 2. Copy theme files
echo "[2/7] Copying theme files and assets..."
cp theme.txt "$THEME_DIR/"
cp assets/os_kali.png "$THEME_DIR/assets/"
cp assets/os_windows.png "$THEME_DIR/assets/"
cp assets/background.png /usr/share/images/desktop-base/desktop-grub.png

# 3. Generate font.pf2 (Crucial step to avoid blue/black text)
echo "[3/7] Generating font.pf2 (This might take a moment)..."
if command -v grub-mkfont &> /dev/null; then
    # Try a common Kali font
    grub-mkfont -s 24 -o "$THEME_DIR/font.pf2" /usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf 2>/dev/null || \
    { echo "Warning: Could not generate font.pf2. Check /usr/share/fonts/ for a valid .ttf file."; }
else
    echo "Error: grub-mkfont command not found. Please install GRUB tools (grub package)."
    exit 1
fi

# 4. Copy 40_custom (you MUST edit this file first)
echo "[4/7] Copying 40_custom. Action required: Edit this file to set your UUIDs."
cp 40_custom "$GRUB_CUSTOM_FILE"
chmod +x "$GRUB_CUSTOM_FILE"

# 5. Disable default GRUB menu items (optional but recommended for a clean look)
echo "[5/7] Disabling default GRUB menu items for a clean 'Red Pill/Blue Pill' menu..."

if [ -f "/etc/grub.d/10_linux" ]; then
    chmod -x /etc/grub.d/10_linux
    echo "    Disabled 10_linux."
fi

if [ -f "/etc/grub.d/30_uefi-firmware" ]; then
    chmod -x /etc/grub.d/30_uefi-firmware
    echo "    Disabled 30_uefi-firmware."
fi

# Disable os-prober in /etc/default/grub
if ! grep -q GRUB_DISABLE_OS_PROBER "$GRUB_DEFAULT_CONF"; then
    echo "GRUB_DISABLE_OS_PROBER=true" >> "$GRUB_DEFAULT_CONF"
else
    sed -i '/GRUB_DISABLE_OS_PROBER/c\GRUB_DISABLE_OS_PROBER=true' "$GRUB_DEFAULT_CONF"
fi

# 6. Update /etc/default/grub settings
echo "[6/7] Updating GRUB default configuration..."

# Set theme
if ! grep -q "GRUB_THEME=" "$GRUB_DEFAULT_CONF" 2>/dev/null; then
    echo "GRUB_THEME=\"$THEME_DIR/theme.txt\"" >> "$GRUB_DEFAULT_CONF"
else
    sed -i "/GRUB_THEME=/c\GRUB_THEME=\"$THEME_DIR/theme.txt\"" "$GRUB_DEFAULT_CONF"
fi

# Set resolution
if ! grep -q "GRUB_GFXMODE=" "$GRUB_DEFAULT_CONF" 2>/dev/null; then
    echo 'GRUB_GFXMODE="1920x1080"' >> "$GRUB_DEFAULT_CONF"
else
    sed -i '/GRUB_GFXMODE=/c\GRUB_GFXMODE="1920x1080"' "$GRUB_DEFAULT_CONF"
fi

# Keep GFXPAYLOAD for smooth transition
if ! grep -q "GRUB_GFXPAYLOAD_LINUX=" "$GRUB_DEFAULT_CONF" 2>/dev/null; then
    echo 'GRUB_GFXPAYLOAD_LINUX="keep"' >> "$GRUB_DEFAULT_CONF"
else
    sed -i '/GRUB_GFXPAYLOAD_LINUX=/c\GRUB_GFXPAYLOAD_LINUX="keep"' "$GRUB_DEFAULT_CONF"
fi

# Clean GRUB_CMDLINE_LINUX_DEFAULT
if ! grep -q "GRUB_CMDLINE_LINUX_DEFAULT=" "$GRUB_DEFAULT_CONF" 2>/dev/null; then
    echo 'GRUB_CMDLINE_LINUX_DEFAULT=""' >> "$GRUB_DEFAULT_CONF"
else
    sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=""' "$GRUB_DEFAULT_CONF"
fi

# 7. Update GRUB configuration
echo "[7/7] Generating new grub.cfg file."
grub-mkconfig -o /boot/grub/grub.cfg

echo " "
echo "======================="
echo "INSTALLATION COMPLETED!"
echo "======================="
