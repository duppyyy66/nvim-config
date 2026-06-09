#!/bin/bash
set -e

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
SHELL_RC="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q "alias vi='nvim'" "$SHELL_RC"; then
  echo "alias vi='nvim'" >> "$SHELL_RC"
  echo ">>> Добавлен alias vi=nvim в $SHELL_RC"
  source $SHELL_RC
fi

echo ">>> Готово! Запусти nvim"
