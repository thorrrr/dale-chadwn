#!/bin/bash

echo
tput setaf 3
echo "⚙️  Building ChadWM from source"
tput sgr0

CHADWM_DIR=~/chadwm-laptop/chadwm

if [[ ! -d $CHADWM_DIR ]]; then
    echo "❌ ChadWM source folder not found!"
    exit 1
fi

cd "$CHADWM_DIR"

# Copy config.h if needed
[[ ! -f config.h && -f config.def.h ]] && cp config.def.h config.h

make clean
make
sudo make install

echo
tput setaf 2
echo "✅ ChadWM compiled and installed!"
tput sgr0

# ─────────────────────────────────────────────────────────────
# WALLPAPER
# ─────────────────────────────────────────────────────────────

if [[ -d ~/chadwm-laptop/wallpaper ]]; then
    mkdir -p ~/Pictures/wallpaper
    cp -ru ~/chadwm-laptop/wallpaper/* ~/Pictures/wallpaper/
    echo "🖼️  Wallpapers copied to ~/Pictures/wallpaper"
fi

# ─────────────────────────────────────────────────────────────
# SCRIPTS
# ─────────────────────────────────────────────────────────────

if [[ -d ~/chadwm-laptop/scripts ]]; then
    mkdir -p ~/.local/bin
    find ~/chadwm-laptop/scripts -maxdepth 1 -type f -executable -exec cp {} ~/.local/bin/ \;
    echo "🛠️  Executable scripts copied to ~/.local/bin"
fi

# ─────────────────────────────────────────────────────────────
# CONFIG
# ─────────────────────────────────────────────────────────────

# Set .xinitrc if it doesn't already include chadwm
if ! grep -q "exec chadwm" ~/.xinitrc 2>/dev/null; then
    echo "exec chadwm" > ~/.xinitrc
    echo "✅ .xinitrc created to launch ChadWM"
else
    echo "ℹ️  .xinitrc already configured"
fi
