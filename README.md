# fyWin

This script helps to clean Windows as much as possible from all kinds of software and tracking, as well as to set some settings that are nice to have. The environment will also be enhanced with variables, symbolic links, a PowerShell profile and Terminal settings.

## Disclaimer

**The script is provided "as is" and you use it at your own risk. I assume no liability for any damage or problems that may result from the use of the script.**

This version of the script is designed to work with Windows 11. The old version for Windows 10 can be found in the `windows10` branch.

## How to use

Open PowerShell as administrator and enter this command:

```PowerShell
iwr "https://timschneider.xyz/scripts/fywin" | iex
```

## Modes

You can run this script in two different modes: `Interactive` or `Silent`.

**Interactive:** In this mode, the script asks you which function you want to execute and which not.

**Silent:** If you select this mode, the script will execute all functions without asking you.

## Functions

### Remove unnecessary Apps, Packages and Capabilities

**Apps**
- OneDrive

**Packages**
- Microsoft.BingNews
- Microsoft.BingWeather
- Microsoft.GamingApp
- Microsoft.Getstarted
- Microsoft.MicrosoftOfficeHub
- Microsoft.MicrosoftSolitaireCollection
- Microsoft.MicrosoftStickyNotes
- Microsoft.OneDriveSync
- Microsoft.PowerAutomateDesktop
- Microsoft.Todos
- microsoft.windowscommunicationsapps
- Microsoft.WindowsFeedbackHub
- Microsoft.WindowsSoundRecorder
- Microsoft.Xbox.TCUI
- Microsoft.ZuneMusic
- Microsoft.ZuneVideo
- MicrosoftTeams
- MicrosoftWindows.Client.WebExperience
- Microsoft.GetHelp

**Capabilities**
- Microsoft.Windows.PowerShell.ISE
- Microsoft.Windows.WordPad
- Microsoft.Windows.Notepad.System
- Browser.InternetExplorer
- Media.WindowsMediaPlayer
- App.Support.QuickAssist
- App.StepsRecorder
- MathRecognizer

### Setup Privacy & Security Settings

Disable tracking and set app permissions.

### Setup Preferences

- Disable fast startup
- Disable Lock Screen
- Disable Wallpaper compression
- Enable Clipboard History
- Disable Mouse acceleration & set speed to 12
- Enable Dark Mode
- Explorer:
  - dont show frequently used folders in Quick Access
  - launch to `This PC`
  - show file extensions
  - show hidden files
- Taskbar:
  - hide Search
  - hide Task View
  - hide Widgets
  - hide Teams
- Start Menu:
  - disable Docs tracking

### Setup Environment

- Environment Variables
```plaintext
LESSHISTFILE=-
```

- Add Directories & Symbolic Links
```plaintext
$env:USERPROFILE\Documents\WindowsPowerShell -> $env:APPDATA\PowerShell
$env:USERPROFILE\Documents\My Games -> $env:USERPROFILE\Saved Games
```
- Set Execution Policy for Scripts to unrestricted
- Add PowerShell Profile
- Add Terminal Settings

**Tip:** Install [JetBrains Mono](https://www.jetbrains.com/lp/mono/) for a nice terminal font.

## Donations

If you would like to buy me a beer 🍺, you can do this [here](https://paypal.me/timschneiderxyz). Thanks! ❤️

## License

This project is licensed under MIT. See the [LICENSE](LICENSE) for more details.
