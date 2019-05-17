# **fyWin10 - For your Windows 10** <!-- omit in toc -->

This PowerShell Script helps you, among other things, to get rid of pre-installed apps on Windows 10, disable unnecessary tasks and services as well as to protect your privacy. A detailed list of all the features provided by this script is given below.

## Disclaimer <!-- omit in toc -->

**The script is provided as is and you use it at your own risk. I am not liable for any damages or problems that may result from using it. Also, there is no function to revert the changes.**

**Last tested with Windows 10 Home and Education on Build 1809 64-Bit.**

## Table of Contents <!-- omit in toc -->

- [**Purpose**](#purpose)
- [**How to use**](#how-to-use)
  - [Preperation](#preperation)
  - [Execution](#execution)
- [**Functions**](#functions)
  - [Remove undesired and unneeded Apps](#remove-undesired-and-unneeded-apps)
  - [Disable App suggestions and Windows Consumer Features](#disable-app-suggestions-and-windows-consumer-features)
  - [Disable unnecessary Scheduled Tasks](#disable-unnecessary-scheduled-tasks)
  - [Disable unnecessary Windows Services](#disable-unnecessary-windows-services)
  - [Disable Feedback Experience and Telemetry](#disable-feedback-experience-and-telemetry)
  - [Disable Windows Defender Cloud](#disable-windows-defender-cloud)
  - [Disable Cortana from Search](#disable-cortana-from-search)
  - [Disable Fast Startup](#disable-fast-startup)
  - [Disable Edge Shortcut creation after Update](#disable-edge-shortcut-creation-after-update)
  - [Disable Windows 10 Lock Screen](#disable-windows-10-lock-screen)
  - [Remove the compression for .jpeg Wallpaper](#remove-the-compression-for-jpeg-wallpaper)
  - [Enable small Icons on Taskbar](#enable-small-icons-on-taskbar)
  - [Disable Search Icon and Box on Taskbar](#disable-search-icon-and-box-on-taskbar)
  - [Enable Task View Icon on Taskbar](#enable-task-view-icon-on-taskbar)
  - [Disable People Icon on Taskbar](#disable-people-icon-on-taskbar)
  - [Enable This PC as default Explorer start view](#enable-this-pc-as-default-explorer-start-view)
  - [Disable recently and frequently used in Explorer](#disable-recently-and-frequently-used-in-explorer)
  - [Remove 3D Objects folder](#remove-3d-objects-folder)
  - [Remove Edit With Photos from the context menu](#remove-edit-with-photos-from-the-context-menu)
  - [Remove Create A New Video from the context menu](#remove-create-a-new-video-from-the-context-menu)
  - [Remove Edit with Paint 3D from the context menu](#remove-edit-with-paint-3d-from-the-context-menu)
  - [Remove Share from the context menu](#remove-share-from-the-context-menu)
  - [Remove Include in Library from the context menu](#remove-include-in-library-from-the-context-menu)
  - [Remove Restore to previous Versions from the context menu](#remove-restore-to-previous-versions-from-the-context-menu)
  - [Install OpenSSH](#install-openssh)
  - [Allow SMB2 Share Guest Access](#allow-smb2-share-guest-access)
- [**Contributing**](#contributing)
- [**Donations**](#donations)
- [**License**](#license)

## **Purpose**

The purpose of this Script is quite simple: To get rid of all the inconveniences Windows 10 brings with it. At least most of them.

It is very annoying that such a script is even necessary, after all you have paid for your operating system (at least most people did). Nevertheless, Microsoft doesn't seem to care about this and puts all kinds of bloatware and other inconveniences into the operating system. With the help of this Script it is possible to fix at least some of this.

## **How to use**

Follow the instructions below carefully to avoid any problems and questions.

### Preperation

First of all you need to change the Execution Policy to enable the execution of PowerShell scripts.

1. Open your PowerShell as an Administrator `(Start Menu -> Windows PowerShell -> Run as Administrator)`.
2. Copy `Set-ExecutionPolicy Unrestricted` into the opened command line and press `Enter`.
3. Agree to change the Execution Policy. We are now able to execute the Script.

If you want to revert this after executing the Script, simply copy `Set-ExecutionPolicy Restricted` to the command line and agree again.

### Execution

After the preparation is done we can now start to run the Script.

1. Download the fyWin10.ps1 file from this repository.
2. Open the PowerShell ISE as an Administrator `(Start Menu -> Windows PowerShell ISE -> Run as Administrator)`.
3. Open the fyWin10.ps1 file with PowerShell ISE `(Strg + o)`.
4. If necessary you can now edit the Script according to your needs.
5. Run the Script `(F5)`.

You will now be asked how you would like to run the Script. There are two options: `Interactive` and `Silent`.

**Interactive:** In this mode the script asks you which function you want to execute and which not. All functions are available in this mode.

**Silent:** If you select this mode, the script will execute all functions one after the other without asking you. Some specific functions are not available in this mode because a lot of people just don't need them.

> **Important:** You must enter the commands exactly as specified. So for example it needs to be `Yes` not just `Y` to work. However, it does not matter whether the letters are upper or lower case.
>
> **Advice:** It is recommended to restart the computer after executing the script.

## **Functions**

Following is a list of all the functions provided by this script.

### Remove undesired and unneeded Apps

This function takes care of most of the pre-installed apps on Windows 10 and removes them.

The following Apps **wont** be removed with this function:

````plaintext
  Calculator
  Photos
  Snip & Sketch
  *Sticky Notes
  *Weather
  Windows Store
````

Apps marked with * must be uncommented in the script if you want to keep them. To do this simply remove the # in the corresponding line. Same thing goes in reverse.

The following Apps **cant** be removed with this function:

````plaintext
  Connect
  Cortana
  Microsoft Edge
  OneDrive
  Settings
  Windows Defender
````

### Disable App suggestions and Windows Consumer Features

With this function it is ensured that once removed apps will not come back and you will also not receive any App suggestions in the start menu.

### Disable unnecessary Scheduled Tasks

The following scheduled tasks are disabled after using this function:

````plaintext
  Consolidator - Windows Customer Experience Improvement Program. Collects and sends usage data to Microsoft.
  UsbCeip - Customer Experience Improvement Program. Collects USB related data and sends it to Microsoft.
  XblGameSaveTask - Supposed to synchronize and upload Xbox Live Save Games or related settings.
  XblGameSaveTaskLogon - Same as XblGameSaveTask.
````

Disabling these scheduled tasks has no negative effect on the functionality of the operating system.

### Disable unnecessary Windows Services

The following Windows services are disabled after using this function:

````plaintext
  diagnosticshub.standardcollector.service - Microsoft Diagnostics Hub Standard Collector service.
  DiagTrack - Diagnostics Tracking service.
  dmwappushsvc - Service for the transmission of user data.
  lfsvc - This service monitors the current location of the system and manages geofences.
  RetailDemo - This service controls device activity while it is in retail demo mode.
  WbioSrvc - Windows Biometry service.
  xbgm - This service monitors games.
  XblAuthManage -  Provides Xbox Live authentication and authorization services.
  XblGameSave - Service that synchronizes data stored for Xbox Live games.
  XboxNetApiSvc - Service that supports the application programming interface Windows.Networking.XboxLive.
````

Disabling these services has no negative effect on the functionality of the operating system.

### Disable Feedback Experience and Telemetry

Prevents Windows from asking for feedback and collecting various user data to share them with Microsoft. This is achieved by editing various Registry entries.

### Disable Windows Defender Cloud

Disables Windows Defender Cloud by editing Registry entries.

### Disable Cortana from Search

Disables Cortana from Search by editing Registry entries.

### Disable Fast Startup

Disables Fast Startup by editing a Registry entry.

### Disable Edge Shortcut creation after Update

Disables Edge Desktop Shortcut creation after a Windows Update by editing Registry entries.

### Disable Windows 10 Lock Screen

Disables the Windows 10 Lock Screen by editing a Registry entry.

### Remove the compression for .jpeg Wallpaper

If you set a .jpeg image as background Windows compresses it to 85% of the actual image quality (for whatever reason). This will be prevented by creating a registry entry so that Windows takes over 100% of the quality.

### Enable small Icons on Taskbar

Enables small Icons on Taskbar by editing a Registry entry.

### Disable Search Icon and Box on Taskbar

Disables the Search Icon and Box on Taskbar by editing a Registry entry.

### Enable Task View Icon on Taskbar

Enables the Task View Icon on Taskbar by editing a Registry entry.

### Disable People Icon on Taskbar

Disables the People Icon on Taskbar by editing a Registry entry.

### Enable This PC as default Explorer start view

Enables 'This PC' as default Explorer start view by editing a Registry entry.

> **Note:** If you set the value to 0, the default Explorer start view will be Quick Access.

### Disable recently and frequently used in Explorer

Disables recently and frequently used in Explorer by editing a Registry entry.

### Remove 3D Objects folder

Removes the '3D Objects' folder by deleting Registry entries.

### Remove Edit With Photos from the context menu

Removes the 'Edit With Photos' entry from the context menu by adding a Registry entry.

### Remove Create A New Video from the context menu

Removes the 'Create A New Video' entry from the context menu by deleting a Registry entry.

### Remove Edit with Paint 3D from the context menu

Removes the 'Edit with Paint 3D' entry from the context menu by deleting a Registry entry.

### Remove Share from the context menu

Removes the 'Share' entry from the context menu by adding a Registry entry.

### Remove Include in Library from the context menu

Removes the 'Include in Library' entry from the context menu by deleting Registry entries.

### Remove Restore to previous Versions from the context menu

Removes the 'Restore to previous Versions' entry from the context menu by deleting Registry entries.

### Install OpenSSH

For more informations click [here](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview).

> **Note:** This function is only available when the script is executed in `Interactive` mode.

### Allow SMB2 Share Guest Access

For more informations click [here](https://support.microsoft.com/de-de/help/4046019/guest-access-smb2-disabled-by-default-in-windows-10-server-2016).

> **Note:** This function is only available when the script is executed in `Interactive` mode.

## **Contributing**

Your feedback is appreciated and allows me to further improve this script and/or add additional functions. To do so just simply open an `issue` or send a `pull request`.

## **Donations**

If you would like to buy me a beer :beer:, you can do this [here](https://paypal.me/timschneiderxyz). Thanks! :heart:

## **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
