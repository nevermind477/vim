#!/usr/bin/env bash
# Установка конфига Vim для олимпиад (обычный vim, не neovim). macOS / Linux.
#
#   bash install.sh          # 10-строчный минимальный конфиг
#   bash install.sh full     # полный конфиг (синтаксис + автодополнение + F5)
#
# Если рядом лежит vimrc.min / vimrc.full (флешка, склонированный репозиторий),
# скрипт берёт файл оттуда и интернет не нужен.
# Удалить: bash uninstall.sh
set -eu

MODE="${1:-min}"
case "$MODE" in
  min|full) ;;
  -h|--help|help) sed -n '2,11p' "$0"; exit 0 ;;
  *) echo "Использование: bash install.sh [min|full]" >&2; exit 1 ;;
esac

RAW="https://raw.githubusercontent.com/nevermind477/vim-olympiad/main"
DEST="$HOME/.vim/olympiad"
VIMRC="$HOME/.vimrc"
LINE="source ~/.vim/olympiad/vimrc.$MODE"

mkdir -p "$DEST"

HERE=""
if [ -f "$0" ]; then
  HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
fi

if [ -n "$HERE" ] && [ -f "$HERE/vimrc.$MODE" ]; then
  cp "$HERE/vimrc.$MODE" "$DEST/vimrc.$MODE"
  echo "Взял локальный файл: $HERE/vimrc.$MODE"
elif command -v curl >/dev/null 2>&1; then
  curl -fsSL "$RAW/vimrc.$MODE" -o "$DEST/vimrc.$MODE"
  echo "Скачал: $RAW/vimrc.$MODE"
else
  wget -qO "$DEST/vimrc.$MODE" "$RAW/vimrc.$MODE"
  echo "Скачал: $RAW/vimrc.$MODE"
fi

if [ -f "$VIMRC" ]; then
  cp "$VIMRC" "$VIMRC.bak.$(date +%Y%m%d-%H%M%S)"
  if grep -qF "$LINE" "$VIMRC"; then
    echo "В ~/.vimrc уже есть нужная строка — обновил только файл конфига."
  else
    printf '\n" ===== vim-olympiad (%s) =====\n%s\n' "$MODE" "$LINE" >> "$VIMRC"
    echo "Дописал в ~/.vimrc: $LINE"
  fi
else
  printf '" ===== vim-olympiad (%s) =====\n%s\n' "$MODE" "$LINE" > "$VIMRC"
  echo "Создал ~/.vimrc"
fi

echo
echo "Готово. Проверь:  vim  (должны быть номера строк и цвета)"
echo "Дополнение:       Ctrl+L  (в C++ после 'std::', в Python после 'str.')"
echo "Откатить:         bash uninstall.sh"
