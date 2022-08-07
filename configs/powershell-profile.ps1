#  ____                        ____  _          _ _   ____             __ _ _
# |  _ \ _____      _____ _ __/ ___|| |__   ___| | | |  _ \ _ __ ___  / _(_) | ___
# | |_) / _ \ \ /\ / / _ \ '__\___ \| '_ \ / _ \ | | | |_) | '__/ _ \| |_| | |/ _ \
# |  __/ (_) \ V  V /  __/ |   ___) | | | |  __/ | | |  __/| | | (_) |  _| | |  __/
# |_|   \___/ \_/\_/ \___|_|  |____/|_| |_|\___|_|_| |_|   |_|  \___/|_| |_|_|\___|


# Options
Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# WinGet Completion
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# Prompt
function global:prompt {
  $startbracket = Write-Host -NoNewline -ForegroundColor Red "["
  $username = Write-Host -NoNewline -ForegroundColor Yellow $env:USERNAME
  $separator = Write-Host -NoNewline -ForegroundColor Green "@"
  $computername = Write-Host -NoNewline -ForegroundColor Blue $env:COMPUTERNAME
  $location = Write-Host -NoNewline -ForegroundColor Magenta " $(Split-Path -Leaf -Path (Get-Location))"
  $endbracket = Write-Host -NoNewline -ForegroundColor Red "]"

  "$startbracket$username$separator$computername$location$endbracket$([char]0x276F) "
}

# Aliases - Common
function x { exit }
function sudo { Start-Process -Verb RunAs wt "-p PowerShell" }
function sst([int]$timeInMinutes) {
  $timeInSeconds = $timeInMinutes * 60
  shutdown -s -t $timeInSeconds
  Write-Host "The Computer will shut down in $timeInMinutes minutes."
}

# Aliases - Directories & Files
function .. { Set-Location ".." }
function ... { Set-Location "..\.." }
function .... { Set-Location "..\..\.." }
function dl { Set-Location "$env:USERPROFILE\Downloads" }
function ll { Get-ChildItem -Force }
function touch([string[]]$file) { New-Item -Force -ItemType File $file }
function mkd([string[]]$directory) { New-Item -Force -ItemType Directory $directory }
function rmrf([string[]]$path) { Remove-Item -Recurse -Force $path }
