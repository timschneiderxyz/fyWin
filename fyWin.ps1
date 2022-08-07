# Requires -RunAsAdministrator
Write-Host -ForegroundColor Blue @"

           .d888          888       888 d8b
          d88P"           888   o   888 Y8P
          888             888  d8b  888
          888888 888  888 888 d888b 888 888 88888b.
          888    888  888 888d88888b888 888 888 "88b
          888    888  888 88888P Y88888 888 888  888
          888    Y88b 888 8888P   Y8888 888 888  888
          888     "Y88888 888P     Y888 888 888  888
                      888
                 Y8b d88P
                  "Y88P"

"@
Write-Host -ForegroundColor Yellow @"
  ----------------------------------------------------------

  Author     : Tim Schneider
  Website    : https://timschneider.xyz
  Repository : https://github.com/timschneiderxyz/fyWin

  ----------------------------------------------------------


"@

# Apps, Packages and Capabilities
# ==============================================================================

function cleanupAppsPackagesCapabilities {
  Write-Host -NoNewline "Cleaning up Apps, Packages and Capabilities..."

  # Apps
  foreach ($app in @(
      "Microsoft.OneDrive"
    )) {
    winget uninstall $app
  }

  # Packages
  foreach ($package in @(
      "*Microsoft.BingNews*"
      "*Microsoft.BingWeather*"
      "*Microsoft.GamingApp*"
      "*Microsoft.Getstarted*"
      "*Microsoft.MicrosoftOfficeHub*"
      "*Microsoft.MicrosoftSolitaireCollection*"
      "*Microsoft.MicrosoftStickyNotes*"
      "*Microsoft.OneDriveSync*"
      "*Microsoft.PowerAutomateDesktop*"
      "*Microsoft.Todos*"
      "*microsoft.windowscommunicationsapps*"
      "*Microsoft.WindowsFeedbackHub*"
      "*Microsoft.WindowsSoundRecorder*"
      "*Microsoft.Xbox.TCUI*"
      "*Microsoft.ZuneMusic*"
      "*Microsoft.ZuneVideo*"
      "*MicrosoftTeams*"

      "*MicrosoftWindows.Client.WebExperience*"
      "*Microsoft.GetHelp*"
    )) {
    Get-AppxPackage -AllUsers $package | Remove-AppxPackage
    Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -Like $package } | ForEach-Object {
      Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName
    } | Out-Null
  }

  # Capabilities
  foreach ($capability in @(
      "Microsoft.Windows.PowerShell.ISE"
      "Microsoft.Windows.WordPad"
      "Microsoft.Windows.Notepad.System"
      "Browser.InternetExplorer"
      "Media.WindowsMediaPlayer~~~~0.0.12.0"
      "App.Support.QuickAssist~~~~0.0.1.0"
      "App.StepsRecorder~~~~0.0.1.0"
      "MathRecognizer"
    )) {
    Remove-WindowsCapability -Online –Name $capability | Out-Null
  }

  Write-Host " Done"
}

# Privacy & Security
# ==============================================================================

function setupPrivacySecurity {
  Write-Host -NoNewline "Setting up Privacy & Security..."

  # General
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name Enabled -Value 0 # Advertising ID for Apps
  New-ItemProperty "HKCU:\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -Value 1 | Out-Null # Websites access to language list
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Start_TrackProgs -Value 0 # Track Apps
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SilentInstalledAppsEnabled -Value 0 # Automatic installation of Apps
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-338393Enabled -Value 0 # Suggested Content
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-353694Enabled -Value 0 # Suggested Content
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-353696Enabled -Value 0 # Suggested Content

  # Inking & Typing
  Set-ItemProperty "HKCU:\Software\Microsoft\InputPersonalization" -Name RestrictImplicitTextCollection -Value 1
  Set-ItemProperty "HKCU:\Software\Microsoft\InputPersonalization" -Name RestrictImplicitInkCollection -Value 1

  # Diagnostics & Feedback
  Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -Value 0
  Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name MaxTelemetryAllowed -Value 0
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name TailoredExperiencesWithDiagnosticDataEnabled -Value 0
  New-Item -Force -ItemType Directory "HKCU:\Software\Microsoft\Siuf\Rules" | Out-Null
  New-ItemProperty "HKCU:\Software\Microsoft\Siuf\Rules" -Name NumberOfSIUFInPeriod -Value 0 | Out-Null

  # App Permissions
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name Value -Value Deny
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" -Name Value -Value Deny

  # Services
  Get-Service "*DiagTrack*" | Set-Service -StartupType Disabled
  Get-Service "*dmwappushservice*" | Set-Service -StartupType Disabled

  # Tasks
  Get-ScheduledTask "*Consolidator*" | Disable-ScheduledTask | Out-Null
  Get-ScheduledTask "*UsbCeip*" | Disable-ScheduledTask | Out-Null

  # Defender
  Set-MpPreference -MAPSReporting Disabled
  Set-MpPreference -SubmitSamplesConsent NeverSend

  Write-Host " Done"
}

# Preferences
# ==============================================================================

function setupPreferences {
  Write-Host -NoNewline "Setting up Preferences..."

  # Disable fast startup
  Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -Value 0

  # Disable Lock Screen
  New-Item -Force -ItemType Directory "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
  New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name NoLockScreen -Value 1 | Out-Null

  # Disable Wallpaper Compression
  New-ItemProperty "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -Value 0x00000064 | Out-Null

  # Enable Clipboard History
  Set-ItemProperty "HKCU:\Software\Microsoft\Clipboard" -Name EnableClipboardHistory -Value 1

  # Mouse
  Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 0
  Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseSensitivity -Value 12

  # Enable Dark Mode
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name SystemUsesLightTheme -Value 0
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AppsUseLightTheme -Value 0

  # Explorer
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowFrequent -Value 0
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name LaunchTo -Value 1
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name AutoCheckSelect -Value 0

  # Taskbar
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name SearchboxTaskbarMode -Value 0
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowTaskViewButton -Value 0
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Value 0
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Value 0

  # Start Menu
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Start_TrackDocs -Value 0

  Write-Host " Done"
}

# Environment
# ==============================================================================

function setupEnvironment {
  Write-Host -NoNewline "Setting up Environment..."

  # Add Environment Variables
  [Environment]::SetEnvironmentVariable("LESSHISTFILE", "-", 'User')

  # Add Directories & Symbolic Links
  New-Item -Force -ItemType Directory "$env:APPDATA\PowerShell" | Out-Null # PowerShell
  New-Item -Force -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\WindowsPowerShell" -Value "$env:APPDATA\PowerShell" | Out-Null # PowerShell
  attrib +h +s /l "$env:USERPROFILE\Documents\WindowsPowerShell" # PowerShell
  New-Item -Force -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\My Games" -Value "$env:USERPROFILE\Saved Games" | Out-Null # My Games
  attrib +h +s /l "$env:USERPROFILE\Documents\My Games" # My Games
  attrib +h +s "$env:USERPROFILE\NTUSER.DAT"

  # Set Execution Policy for Scripts
  Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

  # Add PowerShell Profile
  (Invoke-WebRequest "https://raw.githubusercontent.com/timschneiderxyz/fyWin/main/configs/powershell-profile.ps1").content | Set-Content "$env:APPDATA\PowerShell\profile.ps1"

  # Add Terminal Settings
  $dirWT = Get-ChildItem "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*" | Select-Object -First 1 -Expand FullName
  (Invoke-WebRequest "https://raw.githubusercontent.com/timschneiderxyz/fyWin/main/configs/terminal-settings.json").content | Set-Content "$dirWT\LocalState\settings.json"

  Write-Host " Done"
}

# ==============================================================================
# Execution
# ==============================================================================

$functions = @(
  [pscustomobject]@{
    question = "Cleanup Apps, Packages and Capabilities?";
    function = "cleanupAppsPackagesCapabilities"
  }
  [pscustomobject]@{
    question = "Setup Privacy and Security?";
    function = "setupPrivacySecurity"
  }
  [pscustomobject]@{
    question = "Setup Preferences?";
    function = "setupPreferences"
  }
  [pscustomobject]@{
    question = "Setup Environment?";
    function = "setupEnvironment"
  }
)

function askMode {
  do { $response = Read-Host "In which mode would you like to run this script? ( Interactive / Silent )" }
  until(
    ($response -eq "Interactive") -or
    ($response -eq "i") -or
    ($response -eq "Silent") -or
    ($response -eq "s")
  )

  if ( ($response -eq "Interactive") -or ($response -eq "i")) {
    return "Interactive"
  }
  elseif (($response -eq "Silent") -or ($response -eq "s")) {
    return "Silent"
  }
}

function askYesNo {
  param (
    [Parameter(Mandatory)]
    [String] $question
  )

  do { $response = Read-Host "$question ( Yes / No )" }
  until(
    ($response -eq "Yes") -or
    ($response -eq "y") -or
    ($response -eq "No") -or
    ($response -eq "n")
  )

  if (($response -eq "Yes") -or ($response -eq "y")) {
    return "Yes"
  }
  elseif (($response -eq "No") -or ($response -eq "n")) {
    return "No"
  }
}

function finalize {
  Write-Host -ForegroundColor Red "

           ____                   _
          |  _ \  ___  _ __   ___| |
          | | | |/ _ \| '_ \ / _ \ |
          | |_| | (_) | | | |  __/_|
          |____/ \___/|_| |_|\___(_)

  "
  switch (askYesNo "Would you like to restart your computer?") {
    Yes {
      Write-Host "Restarting computer..."
      Start-Sleep 1
      Restart-Computer
    }
    No {
      Write-Host "Exiting now..."
      Start-Sleep 1
    }
  }
}

switch (askMode) {
  Interactive {
    foreach ($entry in $functions) {
      switch (askYesNo $entry.question) {
        Yes {
          & $entry.function
        }
        No {
          Write-Host "Skipped."
        }
      }
    }
    finalize
  }
  Silent {
    foreach ($entry in $functions) {
      & $entry.function
    }
    finalize
  }
}
