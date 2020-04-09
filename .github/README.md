# fyWin10 - For your Windows 10 <!-- omit in toc -->

This PowerShell Script helps you to get rid of all kinds of bloatware and other inconveniences Windows 10 brings with it. Well, at least most of it. A detailed list of all the features provided by this script is given below.

## Disclaimer

**The script is provided as is and you use it at your own risk. I am not liable for any damages or problems that may result from using it. Also, there is no function to revert the changes.**

**Tested with Windows 10 on Build 1909 64-Bit.**


---


## How to use

Follow the instructions below to avoid any problems and questions.

### Execution

#### Remote

1. Update Windows (Settings -> Updates -> Search for Updates)
2. Open PowerShell as administrator and enter this command:

```PowerShell
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/RanzigeButter/fyWin10/master/fyWin10.ps1'))
```

#### Local

1. Update Windows (Settings -> Updates -> Search for Updates)
2. Download the fyWin10.ps1 file from this repository
3. Open PowerShell as administrator and enter `Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force`
4. Change directory into the folder where the downloaded file is located run the script `.\fyWin10.ps1`

If you want to revert to the execution policy after running the script, simply type `Set-ExecutionPolicy Restricted -Scope CurrentUser -Force` into the command line.

### Modes

You can run this script in two different modes, `Interactive` or `Silent`.

#### Interactive

In this mode the script asks you which function you want to execute and which not.

#### Silent

If you select this mode, the script will execute all functions one after the other without asking you.

### Notes

- You must enter the commands exactly as specified. So for example it needs to be `Yes` not just `Y` to work. However, it does not matter whether the letters are upper or lower case.
- It is recommended to restart the computer after executing the script.


---


## Functions

Following is a list of all the functions provided by this script.

- Remove pre-installed Apps

````plaintext
  These Apps won't be removed with this function:

  Calculator
  Photos
  Snip & Sketch
  *Sticky Notes
  *Weather
  Windows Store

  Apps marked with * must be uncommented in the script if you want to keep them.

  These Apps can't be removed with this function:

  Connect
  Cortana
  Microsoft Edge
  OneDrive
  Settings
  Windows Defender
````

- Disable App suggestions and Windows Consumer Features
- Disable unnecessary Scheduled Tasks

````plaintext
  Consolidator - Windows Customer Experience Improvement Program. Collects usage data
  UsbCeip - Customer Experience Improvement Program. Collects USB related data
  XblGameSaveTask - Synchronize and upload Xbox Live Save Games or related settings
  XblGameSaveTaskLogon - Same as XblGameSaveTask
````

- Disable unnecessary Windows Services

````plaintext
  diagnosticshub.standardcollector.service - Microsoft Diagnostics Hub Standard Collector service
  DiagTrack - Diagnostics Tracking service
  dmwappushsvc - Transmission of user data
  lfsvc - Monitors the current location of the system and manages geofences
  RetailDemo - Controls device activity while it is in retail demo mode
  WbioSrvc - Windows Biometry service
  xbgm - Monitors games
  XblAuthManage - Provides Xbox Live authentication and authorization services
  XblGameSave - Synchronizes data stored for Xbox Live games
  XboxNetApiSvc - Supports the application programming interface Windows.Networking.XboxLive
````

- Disable Feedback Experience and Telemetry
- Disable Windows Defender Cloud
- Disable Fast Startup
- Disable Edge Desktop Shortcut creation after a Windows Update
- Disable the Windows 10 Lock Screen
- Set 'This PC' as default Explorer start view
- Disable recently and frequently used in Explorer
- Remove the '3D Objects' folder
- Remove these entries from the context menu:
  - 'Edit With Photos'
  - 'Create A New Video'
  - 'Edit with Paint 3D'
  - 'Share'
  - 'Include in Library'
  - 'Restore to previous Versions'


---


## Donations

If you would like to buy me a beer 🍺, you can do this [here](https://paypal.me/timschneiderxyz). Thanks! ❤️

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
