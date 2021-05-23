# fyWin10

This PowerShell Script helps you to get rid of all kinds of bloatware and other inconveniences Windows 10 brings with it. Well, at least most of it. A detailed list of all the features provided by this script is given below.

## Disclaimer

**The script is provided as is and you use it at your own risk. I am not liable for any damages or problems that may result from using it. Also, there is no function to revert the changes.**

**Tested with Windows 10 on Build 21h1.**

## How to use

Follow the instructions below to avoid any problems and questions.

### Execution

Remote:

1. Update Windows (Settings -> Updates -> Search for Updates)
2. Open PowerShell as administrator and enter this command:

```PowerShell
iwr "https://raw.githubusercontent.com/RanzigeButter/fyWin10/master/fyWin10.ps1" -UseBasicParsing | iex
```

Local:

1. Update Windows (Settings -> Updates -> Search for Updates)
2. Download the fyWin10.ps1 file from this repository
3. Open PowerShell as administrator and enter `Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force`
4. Change directory into the folder where the downloaded file is located run the script `.\fyWin10.ps1`

If you want to revert to the execution policy after running the script, simply type `Set-ExecutionPolicy Restricted -Scope CurrentUser -Force` into the command line.

### Modes

You can run this script in two different modes, `Interactive` or `Silent`.

**Interactive:** In this mode the script asks you which function you want to execute and which not.

**Silent:** If you select this mode, the script will execute all functions without asking you.

## Functions

Following is a list of all the functions provided by this script.

- Remove pre-installed apps:

````plaintext
These apps won't be removed with this function:

Calculator
Photos
Snip & Sketch
*Sticky Notes
*Weather
Windows Store

Apps marked with * must be uncommented in the script if you want to keep them.

These apps can't be removed with this function:

Connect
Cortana
Microsoft Edge
OneDrive
Settings
Windows Defender
````

- Disable app suggestions and consumer features
- Disable unnecessary tasks:

````plaintext
Consolidator - Customer experience improvement program, collects usage data
UsbCeip - Same as Consolidator for USB related data
XblGameSaveTask - Synchronize and upload Xbox Live save games or related settings
XblGameSaveTaskLogon - Same as XblGameSaveTask
````

- Disable unnecessary services:

````plaintext
diagnosticshub.standardcollector.service - Microsoft diagnostics hub standard collector
DiagTrack - Diagnostics tracking
dmwappushsvc - Transmission of user data
lfsvc - Monitors the current location of the system and manages geofences
RetailDemo - Controls device activity while it is in retail demo mode
WbioSrvc - Biometry service
xbgm - Monitors games
XblAuthManage - Provides Xbox Live authentication and authorization services
XblGameSave - Synchronizes data stored for Xbox Live games
XboxNetApiSvc - Supports the application programming interface Windows.Networking.XboxLive
````

- Disable feedback experience and telemetry
- Disable defender cloud
- Disable fast startup
- Disable lock screen
- Disable mouse acceleration
- Cleanup taskbar (hide search, cortana and Taskview)
- Set 'This PC' as Explorer start view
- Disable recently and frequently used in Explorer
- Show hidden folders/files in Explorer
- Remove the '3D Objects' folder
- Remove these entries from the context menu:
  - "Edit With Photos"
  - "Create A New Video"
  - "Edit with Paint 3D"
  - "Share"
  - "Include in Library"
  - "Restore to previous Versions"
- Disable Edge shortcut creation after a Windows update

## Donations

If you would like to buy me a beer 🍺, you can do this [here](https://paypal.me/timschneiderxyz). Thanks! ❤️

## License

This project is licensed under MIT. See the [LICENSE](LICENSE) file for more details.
