#!/usr/bin/env bash
set -euo pipefail

if [[ "$EUID" -eq 0 ]]; then
    echo "Não execute este script como root."
    echo "Execute como usuário normal."
    exit 1
fi

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
META_DIR="$BASE_DIR/packages"

echo

echo "Executando 00_bootstrap.sh"
chmod +x "$META_DIR/00_bootstrap.sh"
"$META_DIR/00_bootstrap.sh"
echo "00_bootstrap.sh concluído"
echo

echo "Instalando dependências do meta-package."

mapfile -t DEPS < <(cd "$META_DIR" && makepkg --printsrcinfo | awk '$1 == "depends" { print $3 }' | sort -u)
yay -S --needed --asdeps --noconfirm "${DEPS[@]}"

echo "Construindo e instalando o meta-package."
BUILD_TMP="$(mktemp -d)"
trap 'rm -rf "$BUILD_TMP"' EXIT
(cd "$META_DIR" && BUILDDIR="$BUILD_TMP" PKGDEST="$BUILD_TMP" makepkg -si --noconfirm)

echo "Pacotes instalados."

echo "Configurando serviços no Systemd."

echo "Configurando Stasis e Docker"
sudo usermod -aG input,video,docker,gamemode "$USER"

sudo systemctl enable sddm

echo "Configurando temas e fontes GTK."
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface font-name 'Inter Regular 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo "Copiando configurações."
cp "$BASE_DIR/../src/dot_bashrc" ~/.bashrc
cp -r "$BASE_DIR/../src/dot_config/." ~/.config/

echo "Removendo cache do Yay"
yay -Scc --noconfirm

echo "Removendo dependências não usadas"
yay -Ycc --noconfirm

echo "Aplicando Matugen"
matugen image --source-color-index 0 ~/.config/serene-shell/wallpapers/lyw2zl_1920x1080.png
awww img ~/.config/serene-shell/wallpapers/lyw2zl_1920x1080.png

echo "Aplicando configurações do Dolphin"
xdg-mime default org.kde.dolphin.desktop inode/directory
XDG_MENU_PREFIX=arch- kbuildsycoca6 --noincremental
balooctl6 disable

echo "Instalação finalizada. Reinicie o sistema."