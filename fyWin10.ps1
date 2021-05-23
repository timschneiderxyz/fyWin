# Requires -RunAsAdministrator
Write-Host -ForegroundColor Blue @"

           .d888          888       888 d8b           d888   .d8888b.
          d88P"           888   o   888 Y8P          d8888  d88P  Y88b
          888             888  d8b  888                888  888    888
          888888 888  888 888 d888b 888 888 88888b.    888  888    888
          888    888  888 888d88888b888 888 888 "88b   888  888    888
          888    888  888 88888P Y88888 888 888  888   888  888    888
          888    Y88b 888 8888P   Y8888 888 888  888   888  Y88b  d88P
          888     "Y88888 888P     Y888 888 888  888 8888888 "Y8888P"
                      888
                 Y8b d88P
                  "Y88P"

"@
Write-Host -ForegroundColor Red @"

          ------------------------------------------------------------

          Author     : Tim Schneider
          Website    : https://timschneider.xyz
          Repository : https://github.com/RanzigeButter/fyWin10

          ------------------------------------------------------------


"@

# ==============================================================================
# Functions
# ==============================================================================

# Remove pre-installed apps
# ==============================================================================

function removeApps {
  # Remove AppxPackages
  Get-AppxPackage -AllUsers |
  Where-Object { $_.name -notlike "*Microsoft.WindowsStore*" } |
  Where-Object { $_.name -notlike "*Microsoft.Windows.Photos*" } |
  Where-Object { $_.name -notlike "*Microsoft.WindowsCalculator*" } |
  Where-Object { $_.name -notlike "*Microsoft.ScreenSketch*" } |
  # Where-Object {$_.name -notlike "*Microsoft.MicrosoftStickyNotes*"} |
  # Where-Object {$_.name -notlike "*Microsoft.BingWeather*"} |
  Remove-AppxPackage -ea 0 | Out-Null

  # Remove AppxProvisionedPackages
  Get-AppxProvisionedPackage -online |
  Where-Object { $_.packagename -notlike "*Microsoft.WindowsStore*" } |
  Where-Object { $_.packagename -notlike "*Microsoft.Windows.Photos*" } |
  Where-Object { $_.packagename -notlike "*Microsoft.WindowsCalculator*" } |
  Where-Object { $_.packagename -notlike "*Microsoft.ScreenSketch*" } |
  # Where-Object {$_.packagename -notlike "*Microsoft.MicrosoftStickyNotes*"} |
  # Where-Object {$_.packagename -notlike "*Microsoft.BingWeather*"} |
  Remove-AppxProvisionedPackage -online -ea 0 | Out-Null
}

# Disable app suggestions and consumer features
# ==============================================================================

function disableAppSuggestionsAndConsumerFeatures {
  $pathOne = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"

  Set-ItemProperty $pathOne -Name ContentDeliveryAllowed -Value 0
  Set-ItemProperty $pathOne -Name OemPreInstalledAppsEnabled -Value 0
  Set-ItemProperty $pathOne -Name PreInstalledAppsEnabled -Value 0
  Set-ItemProperty $pathOne -Name SilentInstalledAppsEnabled -Value 0
  Set-ItemProperty $pathOne -Name SoftLandingEnabled -Value 0
  Set-ItemProperty $pathOne -Name SubscribedContentEnabled -Value 0
  Set-ItemProperty $pathOne -Name SystemPaneSuggestionsEnabled -Value 0

  $pathTwo = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"

  if (!(Test-Path $pathTwo)) {
    New-Item $pathTwo -ItemType Directory -Force -ea 0 | Out-Null
  }

  New-ItemProperty $pathTwo -Name DisableWindowsConsumerFeatures -Value 1 -ea 0 | Out-Null
}

# Disable tasks
# ==============================================================================

function disableTasks {
  foreach ($task in @(
      "*Consolidator*"
      "*UsbCeip*"
      "*XblGameSaveTask*"
      "*XblGameSaveTaskLogon*"
    )) {
    Get-ScheduledTask -TaskName $task | Disable-ScheduledTask -ea 0 | Out-Null
  }
}

# Disable services
# ==============================================================================

function disableServices {
  foreach ($service in @(
      "*diagnosticshub.standardcollector.service*"
      "*DiagTrack*"
      "*dmwappushsvc*"
      "*lfsvc*"
      "*RetailDemo*"
      "*WbioSrvc*"
      "*xbgm*"
      "*XblAuthManager*"
      "*XblGameSave*"
      "*XboxNetApiSvc*"
    )) {
    Get-Service -Name $service | Set-Service -StartupType Disabled -ea 0 | Out-Null
  }
}

# Disable feedback experience and telemetry
# ==============================================================================

function disableFeedbackExperienceAndTelemetry {
  $path = "HKCU:\Software\Microsoft\Siuf\Rules"

  if (!(Test-Path $path)) {
    New-Item $path -ItemType Directory -Force -ea 0 | Out-Null
  }

  New-ItemProperty $path -Name NumberOfSIUFInPeriod -Value 0 -ea 0 | Out-Null

  Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name Enabled -Value 0
  Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -Value 0
}

# Disable defender cloud
# ==============================================================================

function disableDefenderCloud {
  Set-MpPreference -MAPSReporting Disabled
  Set-MpPreference -SubmitSamplesConsent NeverSend
}

# Disable fast startup
# ==============================================================================

function disableFastStartup {
  Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -Value 0
}

# Disable lock screen
# ==============================================================================

function disableLockScreen {
  $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"

  if (!(Test-Path $path)) {
    New-Item $path -ItemType Directory -Force -ea 0 | Out-Null
  }

  New-ItemProperty $path -Name NoLockScreen -Value 1 -ea 0 | Out-Null
}

# Disable mouse acceleration
# ==============================================================================

function disableMouseAcceleration {
  Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 0
}

# Cleanup taskbar
# ==============================================================================

function cleanupTaskbar {
  $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion"

  Set-ItemProperty "$path\Explorer\Advanced" -Name ShowCortanaButton -Value 0
  Set-ItemProperty "$path\Explorer\Advanced" -Name ShowTaskViewButton -Value 0
  Set-ItemProperty "$path\Search" -Name SearchboxTaskbarMode -Value 0
}

# Set 'This PC' as Explorer start view
# ==============================================================================

function setExplorerThisPC {
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name LaunchTo -Value 1
}

# Disable recently and frequently used in Explorer
# ==============================================================================

function disableRecentlyFrequently {
  $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"

  Set-ItemProperty $path -Name ShowRecent -Value 0
  Set-ItemProperty $path -Name ShowFrequent -Value 0
}

# Show hidden folders/files in Explorer
# ==============================================================================

function showHiddenFoldersFiles {
  Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
}

# Remove '3D Objects' folder
# ==============================================================================

function remove3DObjectsFolder {
  foreach ($path in @(
      "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
      "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    )) {
    Remove-Item $path -Recurse -ea 0
  }
}

# Remove 'Edit With Photos' from the context menu
# ==============================================================================

function removeEditWithPhotos {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
  New-ItemProperty "HKCR:\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit" -Name ProgrammaticAccessOnly -Value 1 -ea 0 | Out-Null
  Remove-PSDrive HKCR | Out-Null
}

# Remove 'Create a new Video' from the context menu
# ==============================================================================

function removeCreateANewVideo {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

  foreach ($path in @(
      "HKCR:\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellCreateVideo"
      "HKCR:\AppXk0g4vb8gvt7b93tg50ybcy892pge6jmt\Shell\ShellCreateVideo"
    )) {
    Remove-Item $path -Recurse -ea 0
  }

  Remove-PSDrive HKCR | Out-Null
}

# Remove 'Edit with Paint 3D' from the context menu
# ==============================================================================

function removeEditWithPaint3D {
  $pathFA = "HKLM:\SOFTWARE\Classes\SystemFileAssociations"
  foreach ($path in @(
      "$pathFA\.3mf\Shell\3D Edit"
      "$pathFA\.bmp\Shell\3D Edit"
      "$pathFA\.gif\Shell\3D Edit"
      "$pathFA\.glb\Shell\3D Edit"
      "$pathFA\.fbx\Shell\3D Edit"
      "$pathFA\.jfif\Shell\3D Edit"
      "$pathFA\.jpe\Shell\3D Edit"
      "$pathFA\.jpeg\Shell\3D Edit"
      "$pathFA\.jpg\Shell\3D Edit"
      "$pathFA\.obj\Shell\3D Edit"
      "$pathFA\.ply\Shell\3D Edit"
      "$pathFA\.png\Shell\3D Edit"
      "$pathFA\.stl\Shell\3D Edit"
      "$pathFA\.tif\Shell\3D Edit"
      "$pathFA\.tiff\Shell\3D Edit"
    )) {
    Remove-Item $path -Recurse -ea 0
  }
}

# Remove 'Share' from the context menu
# ==============================================================================

function removeShare {
  Remove-Item "HKCR:\*\shellex\ContextMenuHandlers\ModernSharing" -Recurse -ea 0
}

# Remove 'Include in Library' from the context menu
# ==============================================================================

function removeIncludeInLibrary {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

  foreach ($path in @(
      "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location"
      "HKLM:\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location"
    )) {
    Remove-Item $path -Recurse -ea 0
  }

  Remove-PSDrive HKCR | Out-Null
}

# Remove 'Restore to previous Versions' from the context menu
# ==============================================================================

function removeRestoreToPreviousVersions {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

  foreach ($path in @(
      "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
      "HKCR:\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
      "HKCR:\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
      "HKCR:\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
    )) {
    Remove-Item $path -Recurse -ea 0
  }

  Remove-PSDrive HKCR | Out-Null
}

# Disable Edge shortcut creation after update
# ==============================================================================

function disableEdgeShortcut {
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name DisableEdgeDesktopShortcutCreation -Value 1 -ea 0 | Out-Null
}

# ==============================================================================
# Execution
# ==============================================================================

$functions = @(
  [pscustomobject]@{
    question = "Remove pre-installed apps?";
    execute  = "Removing pre-installed apps...";
    function = "removeApps"
  }
  [pscustomobject]@{
    question = "Disable app suggestions and consumer features?";
    execute  = "Disabling app suggestions and consumer features...";
    function = "disableAppSuggestionsAndConsumerFeatures"
  }
  [pscustomobject]@{
    question = "Disable unnecessary tasks?";
    execute  = "Disabling unnecessary tasks...";
    function = "disableTasks"
  }
  [pscustomobject]@{
    question = "Disable unnecessary services?";
    execute  = "Disabling unnecessary services...";
    function = "disableServices"
  }
  [pscustomobject]@{
    question = "Disable feedback experience and telemetry?";
    execute  = "Disabling feedback experience and telemetry...";
    function = "disableFeedbackExperienceAndTelemetry"
  }
  [pscustomobject]@{
    question = "Disable defender cloud?";
    execute  = "Disabling defender cloud...";
    function = "disableDefenderCloud"
  }
  [pscustomobject]@{
    question = "Disable fast startup?";
    execute  = "Disabling fast startup...";
    function = "disableFastStartup"
  }
  [pscustomobject]@{
    question = "Disable lock screen?";
    execute  = "Disabling lock screen...";
    function = "disableLockScreen"
  }
  [pscustomobject]@{
    question = "Disable mouse acceleration?";
    execute  = "Disabling mouse acceleration...";
    function = "disableMouseAcceleration"
  }
  [pscustomobject]@{
    question = "Cleanup taskbar?";
    execute  = "Cleaning up taskbar...";
    function = "cleanupTaskbar"
  }
  [pscustomobject]@{
    question = "Set 'This PC' as default Explorer start view?";
    execute  = "Setting 'This PC' as default Explorer start view...";
    function = "setExplorerThisPC"
  }
  [pscustomobject]@{
    question = "Disable recently and frequently used in Explorer?";
    execute  = "Disabling recently and frequently used in Explorer...";
    function = "disableRecentlyFrequently"
  }
  [pscustomobject]@{
    question = "Show hidden folders/files in Explorer?";
    execute  = "Showing hidden folders/files in Explorer...";
    function = "showHiddenFoldersFiles"
  }
  [pscustomobject]@{
    question = "Remove '3D Objects' folder?";
    execute  = "Removing '3D Objects' folder...";
    function = "remove3DObjectsFolder"
  }
  [pscustomobject]@{
    question = "Remove 'Edit With Photos' from the context menu?";
    execute  = "Removing 'Edit With Photos' from the context menu...";
    function = "removeEditWithPhotos"
  }
  [pscustomobject]@{
    question = "Remove 'Create A New Video' from the context menu?";
    execute  = "Removing 'Create a new Video' from the context menu...";
    function = "removeCreateANewVideo"
  }
  [pscustomobject]@{
    question = "Remove 'Edit with Paint 3D' from the context menu?";
    execute  = "Removing 'Edit with Paint 3D' from the context menu...";
    function = "removeEditWithPaint3D"
  }
  [pscustomobject]@{
    question = "Remove 'Share' from the context menu?";
    execute  = "Removing 'Share' from the context menu...";
    function = "removeShare"
  }
  [pscustomobject]@{
    question = "Remove 'Include in Library' from the context menu?";
    execute  = "Removing 'Include in Library' from the context menu...";
    function = "removeIncludeInLibrary"
  }
  [pscustomobject]@{
    question = "Remove 'Restore to previous Versions' from the context menu?";
    execute  = "Removing 'Restore to previous Versions' from the context menu...";
    function = "removeRestoreToPreviousVersions"
  }
  [pscustomobject]@{
    question = "Disable Edge shortcut creation after Windows update?";
    execute  = "Disabling Edge Shortcut creation after Windows update...";
    function = "disableEdgeShortcut"
  }
)

function askMode {
  do { $response = Read-Host "How would you like to run this script? ( Interactive / Silent )" }
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
  switch (askYesNo "Would you like to restart your system?") {
    Yes {
      Write-Host "Restarting system..."
      Start-Sleep 1
      Restart-Computer
    }
    No {
      Write-Host "Exiting now..."
      Start-Sleep 1
      Clear-Host
    }
  }
}

switch (askMode) {
  Interactive {
    Write-Host ""
    Write-Host ""
    foreach ($entry in $functions) {
      switch (askYesNo $entry.question) {
        Yes {
          Write-Host $entry.execute -NoNewline
          & $entry.function
          Write-Host " Done"
          Write-Host ""
        }
        No {
          Write-Host "Skipped."
          Write-Host ""
        }
      }
    }
    finalize
  }
  Silent {
    Write-Host ""
    Write-Host ""
    switch (askYesNo "Are you sure?") {
      Yes {
        foreach ($entry in $functions) {
          Write-Host $entry.execute -NoNewline
          & $entry.function
          Write-Host " Done"
        }
        finalize
      }
      No {
        Write-Host "Script aborted. Exiting now..."
        Start-Sleep 1
        Clear-Host
      }
    }
  }
}
