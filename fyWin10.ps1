#   __     __        ___       _  ___
#  / _|_   \ \      / (_)_ __ / |/ _ \
# | |_| | | \ \ /\ / /| | '_ \| | | | |
# |  _| |_| |\ V  V / | | | | | | |_| |
# |_|  \__, | \_/\_/  |_|_| |_|_|\___/
#      |___/

<#  ========================================================================
    # Functions
    ========================================================================  #>

<#  Remove undesired and/or not needed Apps
    ========================================================================  #>

Function Remove_Apps {

  # ==================================================
  Write-Output "Removing undesired and/or not needed Apps..."

  #Remove AppxPackages
  Get-AppxPackage -AllUsers |
    Where-Object {$_.name -notlike "*Microsoft.WindowsStore*"} |
    Where-Object {$_.name -notlike "*Microsoft.Windows.Photos*"} |
    Where-Object {$_.name -notlike "*Microsoft.WindowsCalculator*"} |
    Where-Object {$_.name -notlike "*Microsoft.ScreenSketch*"} |
  # Where-Object {$_.name -notlike "*Microsoft.MicrosoftStickyNotes*"} |
  # Where-Object {$_.name -notlike "*Microsoft.BingWeather*"} |
  Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null

  #Remove AppxProvisionedPackages
  Get-AppxProvisionedPackage -online |
    Where-Object {$_.packagename -notlike "*Microsoft.WindowsStore*"} |
    Where-Object {$_.packagename -notlike "*Microsoft.Windows.Photos*"} |
    Where-Object {$_.packagename -notlike "*Microsoft.WindowsCalculator*"} |
    Where-Object {$_.packagename -notlike "*Microsoft.ScreenSketch*"} |
  # Where-Object {$_.packagename -notlike "*Microsoft.MicrosoftStickyNotes*"} |
  # Where-Object {$_.packagename -notlike "*Microsoft.BingWeather*"} |
  Remove-AppxProvisionedPackage -online -ErrorAction SilentlyContinue | Out-Null

  # ==================================================
  Write-Output "Removing remaining Registry Keys..."

  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

  $Leftover_Keys = @(
    #Code Writer
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"

    #Eclipse Manager
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"

    #Get Office
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
    "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"

    #Microsoft.PPIProjection
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.16299.15_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.16299.15_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.16299.15_neutral_neutral_cw5n1h2txyewy"

    #Windows Feedback
    "[HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    "[HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
    "[HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    "[HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
    "[HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    "[HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
  )

  ForEach ($Leftover_Key in $Leftover_Keys) {
    Remove-Item $Leftover_Key -Recurse -ErrorAction SilentlyContinue | Out-Null
  }

  Remove-PSDrive HKCR | Out-Null

  # ==================================================
  Write-Output "Undesired and/or not needed Apps have been removed."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Remove OneDrive
    ========================================================================  #>

Function Remove_OneDrive {

  # ==================================================
  Write-Output "Terminating OneDrive process..."

  taskkill /F /IM "OneDrive.exe" | Out-Null

  # ==================================================
  Write-Output "Uninstalling OneDrive..."

  If (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall | Out-Null
    Start-Sleep 5
  }
  If (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall | Out-Null
    Start-Sleep 5
  }

  # ==================================================
  Write-Output "Disabling OneDrive via Group Policies..."

  $OneDrive_GroupPolicies = "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive"
  If (!(Test-Path $OneDrive_GroupPolicies)) {
    Mkdir $OneDrive_GroupPolicies -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $OneDrive_GroupPolicies -Name DisableFileSyncNGSC -Value 1 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Removing OneDrive from Scheduled Tasks..."

  Get-ScheduledTask -TaskName "*OneDrive*" | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue | Out-Null

  # ==================================================
  Write-Output "Removing OneDrive folders..."

  Remove-Item "$env:systemdrive\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
  Remove-Item "$env:programdata\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
  Remove-Item "$env:localappdata\Microsoft\OneDrive"-Force -Recurse -ErrorAction SilentlyContinue | Out-Null
  # Check if directory is empty before removing:
  If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item "$env:userprofile\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Removing OneDrive Start Menu entry..."

  Remove-Item "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -Force -ErrorAction SilentlyContinue | Out-Null

  # ==================================================
  Write-Output "Removing OneDrive from Explorer sidebar..."

  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
  $OneDrive_ExplorerEntry_Key01 = "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
  If (!(Test-Path $OneDrive_ExplorerEntry_Key01)) {
    Mkdir $OneDrive_ExplorerEntry_Key01 -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $OneDrive_ExplorerEntry_Key01 -Name System.IsPinnedToNameSpaceTree -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }
  $OneDrive_ExplorerEntry_Key02 = "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
  If (!(Test-Path $OneDrive_ExplorerEntry_Key02)) {
    Mkdir $OneDrive_ExplorerEntry_Key02 -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $OneDrive_ExplorerEntry_Key02 -Name System.IsPinnedToNameSpaceTree -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }
  Remove-PSDrive HKCR | Out-Null

  # ==================================================
  Write-Output "OneDrive has been removed."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable App suggestions and Consumer Features
    ========================================================================  #>

Function Disable_AppSuggestionsAndConsumerFeatures {

  # ==================================================
  Write-Output "Disabling App suggestions and prevent the silent installation of Apps..."

  $AppSuggestions = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
  If (Test-Path $AppSuggestions) {
    Set-ItemProperty $AppSuggestions -Name ContentDeliveryAllowed -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name OemPreInstalledAppsEnabled -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name PreInstalledAppsEnabled -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name SilentInstalledAppsEnabled -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name SoftLandingEnabled -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name SubscribedContentEnabled -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $AppSuggestions -Name SystemPaneSuggestionsEnabled -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Disabling Windows Consumer Features..."

  $AppReturning = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
  If (!(Test-Path $AppReturning)) {
    Mkdir $AppReturning -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $AppReturning -Name DisableWindowsConsumerFeatures -Value 1 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "App Suggestions and Windows Consumer Features have been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable unnecessary Scheduled Tasks
    ========================================================================  #>

Function Disable_Tasks {

  # ==================================================
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

  # ==================================================
  Write-Output "Unnecessary Scheduled Tasks have been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable unnecessary Windows Services
    ========================================================================  #>

Function Disable_Services {

  # ==================================================
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

  # ==================================================
  Write-Output "Unnecessary Windows Services have been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable Feedback Experience and Telemetry
    ========================================================================  #>

Function Disable_FeedbackExperienceAndTelemetry {

  # ==================================================
  Write-Output "Disabling Windows Feedback Experience..."

  $WindowsFeedbackExperience = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
  If (Test-Path $WindowsFeedbackExperience) {
    Set-ItemProperty $WindowsFeedbackExperience -Name Enabled -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  $Siuf = "HKCU:\Software\Microsoft\Siuf"
  $SiufRules = "HKCU:\Software\Microsoft\Siuf\Rules"
  If (!(Test-Path $SiufRules)) {
    Mkdir $Siuf -ErrorAction SilentlyContinue | Out-Null
    Mkdir $SiufRules -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $SiufRules -Name NumberOfSIUFInPeriod -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Disabling Windows Telemetry..."

  $DataCollection = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
  If (Test-Path $DataCollection) {
    Set-ItemProperty $DataCollection -Name AllowTelemetry -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Windows Feedback Experience and Telemetry have been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable Windows Defender Cloud
    ========================================================================  #>

Function Disable_WindowsDefenderCloud {

  # ==================================================
  Write-Output "Disabling Windows Defender Cloud..."

  $WindowsDefenderCloud = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Spynet"
  If (Test-Path $WindowsDefenderCloud) {
    Set-ItemProperty $WindowsDefenderCloud -Name SpynetReporting -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $WindowsDefenderCloud -Name SubmitSamplesConsent -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Windows Defender Cloud has been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable Cortana from Search
    ========================================================================  #>

Function Disable_CortanaSearch {

  # ==================================================
  Write-Output "Disabling Cortana from Search..."

  $CortanaSearch_Key01 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
  If (Test-Path $CortanaSearch_Key01) {
    Set-ItemProperty $CortanaSearch_Key01 -Name AllowCortana -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  $CortanaSearch_Key02 = "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\Windows Search"
  If (Test-Path $CortanaSearch_Key02) {
    Set-ItemProperty $CortanaSearch_Key02 -Name AllowCortana -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Cortana has been disabled from Search."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable Fast Startup
    ========================================================================  #>

Function Disable_FastStartup {

  # ==================================================
  Write-Output "Disabling Fast Startup..."

  $FastStartup = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
  If (Test-Path $FastStartup) {
    Set-ItemProperty $FastStartup -Name HiberbootEnabled -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Fast Startup has been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable Edge Shortcut creation after Update
    ========================================================================  #>

Function Disable_EdgeShortcut {

  # ==================================================
  Write-Output "Disabling Edge Shortcut creation after Update..."

  $EdgeShortcut = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
  If (Test-Path $EdgeShortcut) {
    New-ItemProperty $EdgeShortcut -Name DisableEdgeDesktopShortcutCreation -Value 1 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Edge Shortcut creation after Update has been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable Windows 10 Lock Screen
    ========================================================================  #>

Function Disable_LockScreen {

  # ==================================================
  Write-Output "Disabling Windows 10 Lock Screen..."

  $LockScreen = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
  If (!(Test-Path $LockScreen)) {
    Mkdir $LockScreen -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $LockScreen -Name NoLockScreen -Value 1 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Windows 10 Lock Screen has been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Remove the compression for .jpeg Wallpaper
    ========================================================================  #>

Function Remove_JPEGWallpaperCompression {

  # ==================================================
  Write-Output "Removing the compression for .jpeg Wallpaper..."

  $JPEGWallpaperCompression = "HKCU:\Control Panel\Desktop"
  If (Test-Path $JPEGWallpaperCompression) {
    New-ItemProperty $JPEGWallpaperCompression -Name JPEGImportQuality -Value 64 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "The compression for.jpeg Wallpaper has been removed."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Enable small Icons on Taskbar
    ========================================================================  #>

Function Enable_SmallIcons {

  # ==================================================
  Write-Output "Enabling small Icons on Taskbar..."

  $SmallIcons = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
  If (Test-Path $SmallIcons) {
    Set-ItemProperty $SmallIcons -Name TaskbarSmallIcons -Value 1 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Small Icons on Taskbar have been enabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable Search Icon and Box on Taskbar
    ========================================================================  #>

Function Disable_SearchIconBox {

  # ==================================================
  Write-Output "Disabling Search Icon and Box on Taskbar..."

  $SearchIconBox = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
  If (Test-Path $SearchIconBox) {
    Set-ItemProperty $SearchIconBox -Name SearchboxTaskbarMode -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Search Icon and Box on Taskbar have been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Enable Task View Icon on Taskbar
    ========================================================================  #>

Function Enable_TaskView {

  # ==================================================
  Write-Output "Enabling Task View Icon on Taskbar..."

  $TaskView = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
  If (Test-Path $TaskView) {
    Set-ItemProperty $TaskView -Name ShowTaskViewButton -Value 1 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Task View Icon on Taskbar has been enabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable People Icon on Taskbar
    ========================================================================  #>

Function Disable_PeopleIcon {

  # ==================================================
  Write-Output "Disabling People Icon on Taskbar..."

  $PeopleIcon = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"
  If (Test-Path $PeopleIcon) {
    Set-ItemProperty $PeopleIcon -Name PeopleBand -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "People Icon on Taskbar has been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Enable 'This PC' as default Explorer start view
    ========================================================================  #>

Function Enable_ExplorerThisPC {

  # ==================================================
  Write-Output "Enabling 'This PC' as default Explorer start view..."

  $ExplorerThisPC = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
  If (Test-Path $ExplorerThisPC) {
    Set-ItemProperty $ExplorerThisPC -Name LaunchTo -Value 1 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "'This PC' as default Explorer start view has been enabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Disable recently and frequently used in Explorer
    ========================================================================  #>

Function Disable_RecentlyFrequently {

  # ==================================================
  Write-Output "Disabling recently and frequently used in Explorer..."

  $RecentlyFrequently = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
  If (Test-Path $RecentlyFrequently) {
    Set-ItemProperty $RecentlyFrequently -Name ShowRecent -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty $RecentlyFrequently -Name ShowFrequent -Value 0 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "Recently and frequently used in Explorer has been disabled."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Remove '3D Objects' folder
    ========================================================================  #>

Function Remove_3DObjectsFolder {

  # ==================================================
  Write-Output "Removing '3D Objects' folder..."

  $3DObjectsFolder_Keys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
  )

  ForEach ($3DObjectsFolder_Key in $3DObjectsFolder_Keys) {
    Remove-Item $3DObjectsFolder_Key -Recurse -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "'3D Objects' folder has been removed."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Remove 'Edit With Photos' from the context menu
    ========================================================================  #>

Function Remove_EditWithPhotos {

  # ==================================================
  Write-Output "Removing the 'Edit With Photos' entry from the context menu..."

  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

  $EditWithPhotos_Key = "HKCR:\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit"
  New-ItemProperty $EditWithPhotos_Key -Name Programmaticaccessonly -Verbose -ErrorAction SilentlyContinue | Out-Null

  Remove-PSDrive HKCR | Out-Null

  # ==================================================
  Write-Output "The 'Edit With Photos' entry has been removed from the context menu."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Remove 'Create a new Video' from the context menu
    ========================================================================  #>

Function Remove_CreateANewVideo {

  # ==================================================
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

  # ==================================================
  Write-Output "The 'Create a new Video' entry has been removed from the context menu."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Remove 'Edit with Paint 3D' from the context menu
    ========================================================================  #>

Function Remove_EditWithPaint3D {

  # ==================================================
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

  # ==================================================
  Write-Output "The 'Edit with Paint 3D' entry has been removed from the context menu."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Remove 'Share' from the context menu
    ========================================================================  #>

Function Remove_Share {

  # ==================================================
  Write-Output "Removing the 'Share' entry from the context menu..."

  $Share_Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"
  If (!(Test-Path $Share_Key)) {
    Mkdir $Share_Key -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty $Share_Key -Name "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "The 'Share' entry has been removed from the context menu."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Remove 'Include in Library' from context menu
    ========================================================================  #>

Function Remove_IncludeInLibrary {

  # ==================================================
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

  # ==================================================
  Write-Output "The 'Include in Library' entry has been removed from the context menu."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Remove 'Restore to previous Versions' from context menu
    ========================================================================  #>

Function Remove_RestoreToPreviousVersions {

  # ==================================================
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

  # ==================================================
  Write-Output "The 'Restore to previous Versions' entry has been removed from the context menu."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Install OpenSSH
    ========================================================================  #>

Function Install_OpenSSH {

  # ==================================================
  Write-Output "Installing OpenSSH..."

  Add-WindowsCapability -Online -Name OpenSSH*
  Set-Service ssh-agent -StartupType Manual

  # ==================================================
  Write-Output "OpenSSH has been installed."
  Write-Output ""
  Write-Output "=================================================="
  Write-Output ""

}

<#  Allow SMB2 Share Guest Access
    ========================================================================  #>

Function Allow_GuestAccess {

  # ==================================================
  Write-Output "Allowing SMB2 Share Guest Access..."

  $GuestAccess = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
  If (Test-Path $GuestAccess) {
    Set-ItemProperty $GuestAccess -Name AllowInsecureGuestAuth -Value 1 -Verbose -ErrorAction SilentlyContinue | Out-Null
  }

  # ==================================================
  Write-Output "SMB2 Share Guest Access has been allowed."
  Write-Output ""
  Write-Output "=================================================="
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
Write-Output "================================================================="
Write-Output "================================================================="
Write-Output ""
Write-Output "*** Welcome to the fyWin10 Script! ***"
Write-Output ""
Write-Output "I recommend you to read the README.md before proceeding."
Write-Output "This will hopefully prevent questions and problems."
Write-Output ""
Write-Output "================================================================="
Write-Output "================================================================="
Write-Output ""
Start-Sleep 3

Write-Output "How would you like to run this Script?"
$ReadHost = Read-Host " ( Interactive / Silent ) "
Switch ($ReadHost) {
  <#  ======================================================================
      Interactive Execution
      ======================================================================  #>
  Interactive {
    Write-Output ""
    Write-Output "================================================================="
    Write-Output ""
    # ==================================================
    Write-Output "Would you like to remove all undesired and/or not needed Apps?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Remove_Apps
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to remove OneDrive?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Remove_OneDrive
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable App suggestions and prevent Apps from returning?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_AppSuggestionsAndConsumerFeatures
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable unnecessary Scheduled Tasks?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_Tasks
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable unnecessary Windows Services?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_Services
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable Windows Feedback Experience and Telemetry?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_FeedbackExperienceAndTelemetry
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable Windows Defender Cloud?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_WindowsDefenderCloud
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable Cortana from Search?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_CortanaSearch
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable Fast Startup?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_FastStartup
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable the Edge Shortcut creation after Windows Update?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_EdgeShortcut
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable the Windows 10 Lock Screen?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_LockScreen
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to remove the compression for .jpeg Wallpaper?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Remove_JPEGWallpaperCompression
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to enable small Icons on Taskbar?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Enable_SmallIcons
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable the Search Icon and Box on Taskbar?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_SearchIconBox
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to enable the Task View Icon on Taskbar?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Enable_TaskView
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable the People Icon on Taskbar?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_PeopleIcon
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to enable 'This PC' as default Explorer start view?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Enable_ExplorerThisPC
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to disable recently and frequently used in Explorer?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Disable_RecentlyFrequently
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to remove the '3D Objects' folder?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Remove_3DObjectsFolder
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to remove the 'Edit With Photos' entry from the context menu?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Remove_EditWithPhotos
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to remove the 'Create A New Video' entry from the context menu?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Remove_CreateANewVideo
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to remove the 'Edit with Paint 3D' entry from the context menu?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Remove_EditWithPaint3D
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to remove the 'Share' entry from the context menu?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Remove_Share
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to remove the 'Include in Library' entry from the context menu?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Remove_IncludeInLibrary
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to remove the 'Restore to previous Versions' entry from the context menu?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Remove_RestoreToPreviousVersions
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to install OpenSSH?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Install_OpenSSH
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output "Would you like to allow SMB2 Share Guest Access?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        Allow_GuestAccess
        Start-Sleep 1
      }
      No {
        Write-Output "Skipped."
        Write-Output ""
        Write-Output "=================================================="
        Write-Output ""
      }
    }
    # ==================================================
    Write-Output " ____                   _"
    Write-Output "|  _ \  ___  _ __   ___| |"
    Write-Output "| | | |/ _ \| '_ \ / _ \ |"
    Write-Output "| |_| | (_) | | | |  __/_|"
    Write-Output "|____/ \___/|_| |_|\___(_)"
    Write-Output ""
    Write-Output "The Script has been executed."
    Write-Output ""
    Write-Output "=================================================="
    Write-Output ""
    Write-Output "Would you like to restart your System?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
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
  <#  ======================================================================
      Silent Execution
      ======================================================================  #>
  Silent {
    Write-Output ""
    Write-Output "================================================================="
    Write-Output ""
    # ==================================================
    Write-Output "Are you sure?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($ReadHost) {
      Yes {
        # ==================================================
        Remove_Apps
        Start-Sleep 1
        # ==================================================
        Remove_OneDrive
        Start-Sleep 1
        # ==================================================
        Disable_AppSuggestionsAndConsumerFeatures
        Start-Sleep 1
        # ==================================================
        Disable_Tasks
        Start-Sleep 1
        # ==================================================
        Disable_Services
        Start-Sleep 1
        # ==================================================
        Disable_FeedbackExperienceAndTelemetry
        Start-Sleep 1
        # ==================================================
        Disable_WindowsDefenderCloud
        Start-Sleep 1
        # ==================================================
        Disable_CortanaSearch
        Start-Sleep 1
        # ==================================================
        Disable_FastStartup
        Start-Sleep 1
        # ==================================================
        Disable_EdgeShortcut
        Start-Sleep 1
        # ==================================================
        Disable_LockScreen
        Start-Sleep 1
        # ==================================================
        Remove_JPEGWallpaperCompression
        Start-Sleep 1
        # ==================================================
        Enable_SmallIcons
        Start-Sleep 1
        # ==================================================
        Disable_SearchIconBox
        Start-Sleep 1
        # ==================================================
        Enable_TaskView
        Start-Sleep 1
        # ==================================================
        Disable_PeopleIcon
        Start-Sleep 1
        # ==================================================
        Enable_ExplorerThisPC
        Start-Sleep 1
        # ==================================================
        Disable_RecentlyFrequently
        Start-Sleep 1
        # ==================================================
        Remove_3DObjectsFolder
        Start-Sleep 1
        # ==================================================
        Remove_EditWithPhotos
        Start-Sleep 1
        # ==================================================
        Remove_CreateANewVideo
        Start-Sleep 1
        # ==================================================
        Remove_EditWithPaint3D
        Start-Sleep 1
        # ==================================================
        Remove_Share
        Start-Sleep 1
        # ==================================================
        Remove_IncludeInLibrary
        Start-Sleep 1
        # ==================================================
        Remove_RestoreToPreviousVersions
        Start-Sleep 1
      }
      No {
        Write-Output "The Script was aborted. Exiting now..."
        Start-Sleep 3
        Clear-Host
        Exit
      }
    }
    # ==================================================
    Write-Output " ____                   _"
    Write-Output "|  _ \  ___  _ __   ___| |"
    Write-Output "| | | |/ _ \| '_ \ / _ \ |"
    Write-Output "| |_| | (_) | | | |  __/_|"
    Write-Output "|____/ \___/|_| |_|\___(_)"
    Write-Output ""
    Write-Output "The Script has been executed."
    Write-Output ""
    Write-Output "=================================================="
    Write-Output ""
    Write-Output "Would you like to restart your System?"
    $ReadHost = Read-Host " ( Yes / No ) "
    Switch ($Readhost) {
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
