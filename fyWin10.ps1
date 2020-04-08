#   __     __        ___       _  ___
#  / _|_   \ \      / (_)_ __ / |/ _ \
# | |_| | | \ \ /\ / /| | '_ \| | | | |
# |  _| |_| |\ V  V / | | | | | | |_| |
# |_|  \__, | \_/\_/  |_|_| |_|_|\___/
#      |___/

#Requires -RunAsAdministrator

<#  ========================================================================
    # Functions
    ========================================================================  #>

# Remove pre-installed Apps
# ==============================================================================

function removeApps {
  Write-Output "Removing pre-installed Apps..."

  # Remove AppxPackages
  Get-AppxPackage -AllUsers |
  Where-Object { $_.name -notlike "*Microsoft.WindowsStore*" } |
  Where-Object { $_.name -notlike "*Microsoft.Windows.Photos*" } |
  Where-Object { $_.name -notlike "*Microsoft.WindowsCalculator*" } |
  Where-Object { $_.name -notlike "*Microsoft.ScreenSketch*" } |
  # Where-Object {$_.name -notlike "*Microsoft.MicrosoftStickyNotes*"} |
  # Where-Object {$_.name -notlike "*Microsoft.BingWeather*"} |
  Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null

  # Remove AppxProvisionedPackages
  Get-AppxProvisionedPackage -online |
  Where-Object { $_.packagename -notlike "*Microsoft.WindowsStore*" } |
  Where-Object { $_.packagename -notlike "*Microsoft.Windows.Photos*" } |
  Where-Object { $_.packagename -notlike "*Microsoft.WindowsCalculator*" } |
  Where-Object { $_.packagename -notlike "*Microsoft.ScreenSketch*" } |
  # Where-Object {$_.packagename -notlike "*Microsoft.MicrosoftStickyNotes*"} |
  # Where-Object {$_.packagename -notlike "*Microsoft.BingWeather*"} |
  Remove-AppxProvisionedPackage -online -ErrorAction SilentlyContinue | Out-Null

  Write-Output ""
}

# Disable App suggestions and Consumer Features
# ==============================================================================

function disableAppSuggestionsAndConsumerFeatures {
  Write-Output "Disabling App suggestions and Consumer Features..."

  $AppSuggestions = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
  if (Test-Path $AppSuggestions) {
    Set-ItemProperty $AppSuggestions -Name ContentDeliveryAllowed -Value 0 -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name OemPreInstalledAppsEnabled -Value 0 -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name PreInstalledAppsEnabled -Value 0 -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name SilentInstalledAppsEnabled -Value 0 -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name SoftLandingEnabled -Value 0 -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name SubscribedContentEnabled -Value 0 -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name SystemPaneSuggestionsEnabled -Value 0 -ErrorAction SilentlyContinue | Out-Null
  }

  $AppReturning = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
  if (!(Test-Path $AppReturning)) {
    Mkdir $AppReturning -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $AppReturning -Name DisableWindowsConsumerFeatures -Value 1 -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Disable unnecessary Scheduled Tasks
# ==============================================================================

function disableTasks {
  Write-Output "Disabling unnecessary Scheduled Tasks..."

  $Tasks = @(
    "*Consolidator*"
    "*UsbCeip*"
    "*XblGameSaveTask*"
    "*XblGameSaveTaskLogon*"
  )

  foreach ($Task in $Tasks) {
    Get-ScheduledTask -TaskName $Task | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Disable unnecessary Windows Services
# ==============================================================================

function disableServices {
  Write-Output "Disabling unnecessary Windows Services..."

  $Services = @(
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
  )

  foreach ($Service in $Services) {
    Get-Service -Name $Service | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

#  Disable Feedback Experience and Telemetry
# ==============================================================================

function disableFeedbackExperienceAndTelemetry {
  Write-Output "Disabling Feedback Experience and Telemetry..."

  $WindowsFeedbackExperience = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
  if (Test-Path $WindowsFeedbackExperience) {
    Set-ItemProperty $WindowsFeedbackExperience -Name Enabled -Value 0 -ErrorAction SilentlyContinue | Out-Null
  }

  $Siuf = "HKCU:\Software\Microsoft\Siuf"
  $SiufRules = "HKCU:\Software\Microsoft\Siuf\Rules"
  if (!(Test-Path $SiufRules)) {
    Mkdir $Siuf -ErrorAction SilentlyContinue | Out-Null
    Mkdir $SiufRules -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $SiufRules -Name NumberOfSIUFInPeriod -Value 0 -ErrorAction SilentlyContinue | Out-Null
  }

  $DataCollection = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
  if (Test-Path $DataCollection) {
    Set-ItemProperty $DataCollection -Name AllowTelemetry -Value 0 -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Disable Defender Cloud
# ==============================================================================

function disableDefenderCloud {
  Write-Output "Disabling Defender Cloud..."

  $WindowsDefenderCloud = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Spynet"
  if (Test-Path $WindowsDefenderCloud) {
    Set-ItemProperty $WindowsDefenderCloud -Name SpynetReporting -Value 0 -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $WindowsDefenderCloud -Name SubmitSamplesConsent -Value 0 -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

#  Disable Fast Startup
# ==============================================================================

function disableFastStartup {
  Write-Output "Disabling Fast Startup..."

  $FastStartup = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
  if (Test-Path $FastStartup) {
    Set-ItemProperty $FastStartup -Name HiberbootEnabled -Value 0 -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Disable Edge Shortcut creation after update
# ==============================================================================

function disableEdgeShortcut {
  Write-Output "Disabling Edge Shortcut creation after update..."

  $EdgeShortcut = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
  if (Test-Path $EdgeShortcut) {
    New-ItemProperty $EdgeShortcut -Name DisableEdgeDesktopShortcutCreation -Value 1 -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Disable Lock Screen
# ==============================================================================

function disableLockScreen {
  Write-Output "Disabling Lock Screen..."

  $LockScreen = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
  if (!(Test-Path $LockScreen)) {
    Mkdir $LockScreen -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $LockScreen -Name NoLockScreen -Value 1 -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Set 'This PC' as default Explorer start view
# ==============================================================================

function setExplorerThisPC {
  Write-Output "Set 'This PC' as default Explorer start view..."

  $ExplorerThisPC = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
  if (Test-Path $ExplorerThisPC) {
    Set-ItemProperty $ExplorerThisPC -Name LaunchTo -Value 1 -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Disable recently and frequently used in Explorer
# ==============================================================================

function disableRecentlyFrequently {
  Write-Output "Disabling recently and frequently used in Explorer..."

  $RecentlyFrequently = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
  if (Test-Path $RecentlyFrequently) {
    Set-ItemProperty $RecentlyFrequently -Name ShowRecent -Value 0 -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $RecentlyFrequently -Name ShowFrequent -Value 0 -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Remove '3D Objects' folder
# ==============================================================================

function remove3DObjectsFolder {
  Write-Output "Removing '3D Objects' folder..."

  $3DObjectsFolder_Keys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
  )

  ForEach ($3DObjectsFolder_Key in $3DObjectsFolder_Keys) {
    Remove-Item $3DObjectsFolder_Key -Recurse -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Remove 'Edit With Photos' from the context menu
# ==============================================================================

function removeEditWithPhotos {
  Write-Output "Removing the 'Edit With Photos' entry from the context menu..."

  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

  $EditWithPhotos_Key = "HKCR:\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit"
  New-ItemProperty $EditWithPhotos_Key -Name Programmaticaccessonly -ErrorAction SilentlyContinue | Out-Null

  Remove-PSDrive HKCR | Out-Null

  Write-Output ""
}

# Remove 'Create a new Video' from the context menu
# ==============================================================================

function removeCreateANewVideo {
  Write-Output "Removing the 'Create a new Video' entry from the context menu..."

  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

  $CreateANewVideo_Keys = @(
    "HKCR:\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellCreateVideo"
    "HKCR:\AppXk0g4vb8gvt7b93tg50ybcy892pge6jmt\Shell\ShellCreateVideo"
  )

  ForEach ($CreateANewVideo_Key in $CreateANewVideo_Keys) {
    Remove-Item $CreateANewVideo_Key -Recurse -ErrorAction SilentlyContinue | Out-Null
  }

  Remove-PSDrive HKCR | Out-Null

  Write-Output ""
}

# Remove 'Edit with Paint 3D' from the context menu
# ==============================================================================

function removeEditWithPaint3D {
  Write-Output "Removing 'Edit with Paint 3D' from the context menu..."

  $EditWithPaint3D_Keys = @(
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.3mf\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.gif\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.glb\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.fbx\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jfif\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpe\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpeg\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.obj\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.ply\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.stl\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tif\Shell\3D Edit"
    "HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tiff\Shell\3D Edit"
  )

  ForEach ($EditWithPaint3D_Key in $EditWithPaint3D_Keys) {
    Remove-Item $EditWithPaint3D_Key -Recurse -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Remove 'Share' from the context menu
# ==============================================================================

function removeShare {
  Write-Output "Removing the 'Share' entry from the context menu..."

  $Share_Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"
  if (!(Test-Path $Share_Key)) {
    Mkdir $Share_Key -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $Share_Key -Name "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Output ""
}

# Remove 'Include in Library' from context menu
# ==============================================================================

function removeIncludeInLibrary {
  Write-Output "Removing the 'Include in Library' entry from the context menu..."

  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

  $IncludeInLibrary_Keys = @(
    "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location"
    "HKLM:\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location"
  )

  ForEach ($IncludeInLibrary_Key in $IncludeInLibrary_Keys) {
    Remove-Item $IncludeInLibrary_Key -Recurse -ErrorAction SilentlyContinue | Out-Null
  }

  Remove-PSDrive HKCR | Out-Null

  Write-Output ""
}

# Remove 'Restore to previous Versions' from context menu
# ==============================================================================

function removeRestoreToPreviousVersions {
  Write-Output "Removing the 'Restore to previous Versions' entry from the context menu..."

  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

  $RestoreToPreviousVersions_Keys = @(
    "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
    "HKCR:\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
    "HKCR:\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
    "HKCR:\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
  )

  ForEach ($RestoreToPreviousVersions_Key in $RestoreToPreviousVersions_Keys) {
    Remove-Item $RestoreToPreviousVersions_Key -Recurse -ErrorAction SilentlyContinue | Out-Null
  }

  Remove-PSDrive HKCR | Out-Null

  Write-Output ""
}

<#  ========================================================================
    # Execution
    ========================================================================  #>

Write-Output ""
Write-Output "   __     __        ___       _  ___   "
Write-Output "  / _|_   \ \      / (_)_ __ / |/ _ \  "
Write-Output " | |_| | | \ \ /\ / /| | '_ \| | | | | "
Write-Output " |  _| |_| |\ V  V / | | | | | | |_| | "
Write-Output " |_|  \__, | \_/\_/  |_|_| |_|_|\___/  "
Write-Output "      |___/                            "
Write-Output ""
Write-Output ""
Write-Output "*** Welcome to the fyWin10 Script! ***"
Write-Output ""
Write-Output "I recommend you to read the README.md before proceeding."
Write-Output ""
Write-Output ""

Write-Output "How would you like to run this Script?"
Switch (Read-Host "( Interactive / Silent )") {
  # ============================================================================
  # Interactive
  # ============================================================================
  Interactive {
    Write-Output ""
    Write-Output ""
    Write-Output "Remove the pre-installed Apps?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        removeApps
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Disable App suggestions and Consumer Features?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        disableAppSuggestionsAndConsumerFeatures
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Disable unnecessary Scheduled Tasks?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        disableTasks
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Disable unnecessary Windows Services?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        disableServices
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Disable Windows Feedback Experience and Telemetry?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        disableFeedbackExperienceAndTelemetry
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Disable Defender Cloud?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        disableDefenderCloud
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Disable Fast Startup?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        disableFastStartup
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Disable the Edge Shortcut creation after Windows update?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        disableEdgeShortcut
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Disable the Windows 10 Lock Screen?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        disableLockScreen
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Set 'This PC' as default Explorer start view?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        setExplorerThisPC
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Disable recently and frequently used in Explorer?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        disableRecentlyFrequently
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Remove the '3D Objects' folder?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        remove3DObjectsFolder
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Remove the 'Edit With Photos' entry from the context menu?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        removeEditWithPhotos
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Remove the 'Create A New Video' entry from the context menu?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        removeCreateANewVideo
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Remove the 'Edit with Paint 3D' entry from the context menu?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        removeEditWithPaint3D
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Remove the 'Share' entry from the context menu?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        removeShare
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Remove the 'Include in Library' entry from the context menu?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        removeIncludeInLibrary
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output "Remove the 'Restore to previous Versions' entry from the context menu?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        removeRestoreToPreviousVersions
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
      }
    }
    Write-Output " ____                   _"
    Write-Output "|  _ \  ___  _ __   ___| |"
    Write-Output "| | | |/ _ \| '_ \ / _ \ |"
    Write-Output "| |_| | (_) | | | |  __/_|"
    Write-Output "|____/ \___/|_| |_|\___(_)"
    Write-Output ""
    Write-Output ""
    Write-Output "Would you like to restart your System?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        Write-Output "Restarting System..."
        Start-Sleep 3
        Restart-Computer
      }
      No {
        Write-Output "Exiting now..."
        Start-Sleep 3
        Clear-Host
        Exit
      }
    }
  }
  # ============================================================================
  # Silent
  # ============================================================================
  Silent {
    Write-Output ""
    Write-Output ""
    Write-Output "Are you sure?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        # ==================================================
        removeApps
        # ==================================================
        disableAppSuggestionsAndConsumerFeatures
        # ==================================================
        disableTasks
        # ==================================================
        disableServices
        # ==================================================
        disableFeedbackExperienceAndTelemetry
        # ==================================================
        disableDefenderCloud
        # ==================================================
        disableFastStartup
        # ==================================================
        disableEdgeShortcut
        # ==================================================
        disableLockScreen
        # ==================================================
        setExplorerThisPC
        # ==================================================
        disableRecentlyFrequently
        # ==================================================
        remove3DObjectsFolder
        # ==================================================
        removeEditWithPhotos
        # ==================================================
        removeCreateANewVideo
        # ==================================================
        removeEditWithPaint3D
        # ==================================================
        removeShare
        # ==================================================
        removeIncludeInLibrary
        # ==================================================
        removeRestoreToPreviousVersions
      }
      No {
        Write-Output "Script aborted. Exiting now..."
        Start-Sleep 3
        Clear-Host
        Exit
      }
    }
    Write-Output " ____                   _"
    Write-Output "|  _ \  ___  _ __   ___| |"
    Write-Output "| | | |/ _ \| '_ \ / _ \ |"
    Write-Output "| |_| | (_) | | | |  __/_|"
    Write-Output "|____/ \___/|_| |_|\___(_)"
    Write-Output ""
    Write-Output ""
    Write-Output "Would you like to restart your System?"
    Switch (Read-Host "( Yes / No )") {
      Yes {
        Write-Output "Restarting System..."
        Start-Sleep 3
        Restart-Computer
      }
      No {
        Write-Output "Exiting now..."
        Start-Sleep 3
        Clear-Host
        Exit
      }
    }
  }
}
