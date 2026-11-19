<#
  Установка конфига Vim для олимпиад (обычный vim, не neovim). Windows.
  Запуск из папки репозитория или с флешки (интернет не нужен):

    powershell -ExecutionPolicy Bypass -File install.ps1
    powershell -ExecutionPolicy Bypass -File install.ps1 full

  Удалить: powershell -ExecutionPolicy Bypass -File uninstall.ps1
#>
param(
  [ValidateSet('min', 'full')]
  [string]$Mode = 'min'
)

$raw  = 'https://raw.githubusercontent.com/nevermind477/vim-olympiad/main'
$dest = Join-Path $HOME '.vim\olympiad'
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$here = ''
if ($MyInvocation.MyCommand.Path) {
  $here = Split-Path -Parent $MyInvocation.MyCommand.Path
}
$local  = if ($here) { Join-Path $here "vimrc.$Mode" } else { '' }
$target = Join-Path $dest "vimrc.$Mode"

if ($local -and (Test-Path $local)) {
  Copy-Item $local $target -Force
  Write-Host "Взял локальный файл: $local"
} else {
  Invoke-WebRequest -UseBasicParsing -Uri "$raw/vimrc.$Mode" -OutFile $target
  Write-Host "Скачал: $raw/vimrc.$Mode"
}

$line   = "source ~/.vim/olympiad/vimrc.$Mode"
$header = '" ===== vim-olympiad (' + $Mode + ') ====='
$vimrc  = Join-Path $HOME '_vimrc'

if (Test-Path $vimrc) {
  Copy-Item $vimrc "$vimrc.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
  if (Select-String -Path $vimrc -SimpleMatch $line -Quiet) {
    Write-Host "В _vimrc уже есть нужная строка — обновил только файл конфига."
  } else {
    Add-Content -Path $vimrc -Value @('', $header, $line) -Encoding ascii
    Write-Host "Дописал в _vimrc: $line"
  }
} else {
  Set-Content -Path $vimrc -Value @($header, $line) -Encoding ascii
  Write-Host "Создал _vimrc"
}

Write-Host ''
Write-Host 'Готово. Проверь:  vim  (должны быть номера строк и цвета)'
Write-Host 'Дополнение:       Ctrl+L  (в C++ после std::, в Python после str.)'
Write-Host 'Откатить:         powershell -ExecutionPolicy Bypass -File uninstall.ps1'
