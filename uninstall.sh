#!/usr/bin/env bash
# Удаление конфига vim-olympiad. macOS / Linux.
#   bash uninstall.sh
set -eu

VIMRC="$HOME/.vimrc"

if [ -f "$VIMRC" ]; then
  cp "$VIMRC" "$VIMRC.bak.$(date +%Y%m%d-%H%M%S)"
  TMP=$(mktemp)
  grep -v -e '^" ===== vim-olympiad' -e '^source ~/.vim/olympiad/vimrc\.\(min\|full\)$' "$VIMRC" > "$TMP" || true
  mv "$TMP" "$VIMRC"
  echo "Убрал строки vim-olympiad из ~/.vimrc (бэкап рядом: ~/.vimrc.bak.*)"
else
  echo "~/.vimrc не найден — нечего чистить."
fi

rm -rf "$HOME/.vim/olympiad"
echo "Удалено: ~/.vim/olympiad"
