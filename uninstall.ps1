<#
  Удаление конфига vim. Windows.
    powershell -ExecutionPolicy Bypass -File uninstall.ps1
#>
$vimrc = Join-Path $HOME '_vimrc'

if (Test-Path $vimrc) {
  Copy-Item $vimrc "$vimrc.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
  $lines = Get-Content $vimrc | Where-Object {
    $_ -notmatch '^" ===== vim' -and $_ -notmatch '^source ~/\.vim/olympiad/vimrc\.(min|full)$'
  }
  Set-Content -Path $vimrc -Value $lines -Encoding ascii
  Write-Host 'Убрал строки vim из _vimrc (бэкап рядом: _vimrc.bak.*)'
} else {
  Write-Host '_vimrc не найден - нечего чистить.'
}

Remove-Item -Recurse -Force (Join-Path $HOME '.vim\olympiad') -ErrorAction SilentlyContinue
Write-Host 'Удалено: ~/.vim/olympiad'
