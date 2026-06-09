#!/bin/bash
set -e

if ! command -v apt &> /dev/null; then
  echo ">>> Этот скрипт работает только на Debian/Ubuntu (apt)."
  echo ">>> Для macOS смотри ручную установку в README.md"
  exit 1
fi

REPO="https://github.com/duppyyy66/nvim-config.git"

echo ">>> Устанавливаем Neovim конфиг..."

# Бэкап старого конфига если есть
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak.$(date +%s)

# Клонировать конфиг
mkdir -p ~/.config
git clone "$REPO" ~/.config/nvim

if ! command -v node &> /dev/null; then
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt install -y nodejs
fi

# bash-language-server
if ! command -v bash-language-server &> /dev/null; then
  npm install -g bash-language-server
fi

# tree-sitter-cli — нужен для компиляции парсеров Treesitter
if ! command -v tree-sitter &> /dev/null; then
  npm install -g tree-sitter-cli
fi

# ripgrep
sudo apt install -y ripgrep

# Установить плагины headless (без открытия UI)
nvim --headless "+Lazy sync" +qa 2>/dev/null

# Добавить алиас 
if ! grep -q "alias vi='nvim'" "$HOME/.bashrc"; then
  echo "alias vi='nvim'" >> "$HOME/.bashrc"
  echo ">>> Добавлен alias vi=nvim в .bashrc"
  source "$HOME/.bashrc"
fi

echo ">>> Готово! Запусти nvim"
