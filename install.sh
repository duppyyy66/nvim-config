#!/bin/bash
set -e

REPO="https://github.com/duppyyy66/nvim-config.git"

echo ">>> Устанавливаем Neovim конфиг..."

# Бэкап старого конфига если есть
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak.$(date +%s)

# Клонировать конфиг
mkdir -p ~/.config
git clone "$REPO" ~/.config/nvim

# Установить плагины headless (без открытия UI)
nvim --headless "+Lazy sync" +qa 2>/dev/null

echo ">>> Готово! Запусти nvim"
