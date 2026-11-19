# vim

Минимальный конфиг **Vim (не Neovim)** для олимпиад и школьных ПК:
подсветка синтаксиса, нормальные отступы, автодополнение для **C++ и Python**,
номера строк и запуск решения по `F5`. Без плагинов и без интернета после установки.

| Файл | Что это |
|---|---|
| `vimrc.min` | **10 строк** — выучить наизусть и вставлять руками куда угодно |
| `vimrc.full` | полный конфиг: то же + `F5`, буфер обмена, мелочи |
| `install.sh` / `install.ps1` | установка на macOS/Linux и Windows |
| `uninstall.sh` / `uninstall.ps1` | откат (старый конфиг сохраняется в `*.bak.*`) |

---

## Установка на школьном ПК

### Windows (PowerShell)

```powershell
powershell -ExecutionPolicy Bypass -Command "iwr -UseBasicParsing https://raw.githubusercontent.com/nevermind477/vim/main/install.ps1 -OutFile $env:TEMP\vim-config.ps1; & $env:TEMP\vim-config.ps1"
```

Полный конфиг — добавь `full` в конец:

```powershell
powershell -ExecutionPolicy Bypass -Command "iwr -UseBasicParsing https://raw.githubusercontent.com/nevermind477/vim/main/install.ps1 -OutFile $env:TEMP\vim-config.ps1; & $env:TEMP\vim-config.ps1 full"
```

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/nevermind477/vim/main/install.sh | bash
# полный конфиг:
curl -fsSL https://raw.githubusercontent.com/nevermind477/vim/main/install.sh | bash -s full
```

### Без интернета (флешка)

Скопируй папку репозитория на флешку и запусти установщик оттуда — он возьмёт
файлы рядом с собой, сеть не нужна:

```bash
bash install.sh          # macOS/Linux
powershell -ExecutionPolicy Bypass -File install.ps1   # Windows
```

Или вообще без установки, одним запуском:

```bash
vim -u /путь/к/vimrc.min main.cpp
```

---

## 10 строк, которые надо помнить

```vim
" vimrc.min — 10 строк для олимпиад. Обычный vim (не neovim).
syntax on
filetype plugin indent on
set number ruler showcmd noswapfile
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 expandtab smartindent
set incsearch ignorecase smartcase hlsearch wildmenu mouse=a
set omnifunc=syntaxcomplete#Complete
inoremap <C-l> <C-x><C-o>
nnoremap ; :
```

Что каждая строка даёт:

| Строка | Смысл |
|---|---|
| `syntax on` | подсветка синтаксиса |
| `filetype plugin indent on` | определяет язык и включает отступы/плагины для него |
| `number ruler showcmd noswapfile` | номера строк, позиция курсора, команда; без мусорных `.swp` на чужих дисках |
| `backspace=indent,eol,start` | Backspace работает «как в нормальном редакторе» |
| `tabstop=4 shiftwidth=4 expandtab smartindent` | Tab = 4 пробела (Python), `>>`/`<<` — тоже 4, автоотступы |
| `incsearch ignorecase smartcase hlsearch wildmenu mouse=a` | поиск `/` сразу подсвечивает, регистр важен только при заглавных; мышь и меню команд |
| `omnifunc=syntaxcomplete#Complete` | запасное автодополнение, если для языка нет своего |
| `inoremap <C-l> <C-x><C-o` | **Ctrl+L** — умное автодополнение |
| `nnoremap ; :` | `;` = `:`, то есть `;w`, `;q` вместо Shift+двоеточие |

> `set nocompatible` не нужен: при запуске с файлом конфига Vim и так
> выключает режим совместимости.

> `nnoremap ; :` ломает повтор `f;` / `t;`. На олимпиадах это не нужно,
> но если мешает — просто удали последнюю строку.

---

## Автодополнение

В Vim всё уже встроено, плагины не нужны:

* **Ctrl+L** — умное (omni) дополнение по контексту:
  * C++: `std::` → Ctrl+L, `vec.` → Ctrl+L;
  * Python: `"abc".` → Ctrl+L, `os.` → Ctrl+L.
* **Ctrl+N** — слова из текущего файла (работает всегда, даже в Vim 7).
* **Ctrl+X Ctrl+O** — то же, что Ctrl+L, «родная» комбинация Vim.

Проверка, что язык определился: `:set ft?` → `filetype=cpp` или `filetype=python`.

`set omnifunc=syntaxcomplete#Complete` — страховка: если в сборке Vim нет
своего дополнения для языка (например, системный `/usr/bin/vim` на macOS собран
без `+python3`, или это старый Vim 8), Ctrl+L всё равно что-то предложит по
синтаксису. Полноценное Python-дополнение (`os.`, `str.`) требует Vim с
`+python3` — проверь `vim --version | grep python3`. Если флага нет, Ctrl+N
и запасной `syntaxcomplete` всё равно работают.

---

## Полный конфиг (`vimrc.full`)

Дополнительно к минимальному:

* `F5` — сохранить, собрать и запустить:
  * C++: `g++ -std=c++17 -O2 -Wall` и сразу запуск;
  * Python: `python3` (на Windows — `python`);
* `Esc Esc` — снять подсветку поиска;
* `clipboard=unnamedplus` — `y`/`p` работают с системным буфером (если сборка Vim это умеет);
* `scrolloff`, `cursorline`, `nowrap`, `showmatch`, `wildmenu`;
* `encoding=utf-8` и `fileformats=unix,dos` — русские комментарии на Windows не превращаются в кракозябры.

---

## Шпаргалка на олимпиаду

| Клавиши | Действие |
|---|---|
| `i` / `a` / `o` | вставка до / после курсора / новая строка ниже |
| `Esc` | назад в нормальный режим |
| `;w` (`:w`) | сохранить |
| `;q` / `;wq` | выйти / сохранить и выйти |
| `;q!` | выйти без сохранения |
| `dd` / `yy` / `p` | удалить / скопировать строку / вставить |
| `u` / `Ctrl+R` | отменить / вернуть |
| `gg` / `G` / `:42` | начало / конец / строка 42 |
| `/слово`, `n`, `N` | поиск вперёд, следующее, предыдущее |
| `:%s/old/new/g` | заменить во всём файле |
| `v` + move + `y`/`d` | выделить и скопировать/удалить |
| `V` + `d` | удалить строки целиком |
| `Ctrl+L` | автодополнение |
| `F5` | собрать и запустить (полный конфиг) |

---

## Где лежит конфиг

* macOS/Linux: `~/.vimrc` (системный `/usr/share/vim/vimrc` не трогаем — он под SIP).
* Windows: `%USERPROFILE%\_vimrc` (то есть `~/_vimrc` для Vim).

Установщик **не перезаписывает** ваш конфиг: он кладёт файлы в
`~/.vim/olympiad/` и добавляет в конец `~/.vimrc` (или `_vimrc`) две строки:

```vim
" ===== vim (min) =====
source ~/.vim/olympiad/vimrc.min
```

Перед изменением делается бэкап `~/.vimrc.bak.ГГГГММДД-ЧЧММСС`.

## Удаление

```bash
bash uninstall.sh                                           # macOS/Linux
powershell -ExecutionPolicy Bypass -File uninstall.ps1      # Windows
```

---

## Vim, а не Neovim

Эти файлы рассчитаны на `vim` (на macOS это `/usr/bin/vim`, на Windows — `vim.exe`/`gvim.exe`).
Neovim читает `init.vim`, а не `~/.vimrc`, поэтому там конфиг сам не подхватится —
этот репозиторий про обычный Vim, как и просили.
