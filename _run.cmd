@echo off
cls
echo.
echo Windows 10 Crapware and Telemetry Hotfix Uninstaller 0.2 by zuz (based on Uninstaller 0.1 by @seitics http://pastebin.com/8z7VXeb6)
echo NO WARRANTY, EITHER EXPRESS OR IMPLIED. USE AT YOUR OWN RISK.
echo.
echo Uninstalls and hides the following hotfixes in conjunction with advertisements of Windows 10 on Windows 7/8/8.1 computers:
echo KB3035583, KB2952664, KB2976978, KB3021917
echo And hotfixes, that adding collecting telemeptry and customer expierence information:
echo KB3022345, KB3068708, KB3075249, KB3080149
echo See: http://www.ghacks.net/2015/04/17/how-to-remove-windows-10-upgrade-updates-in-windows-7-and-8/
echo.
echo Requirements
echo.
echo + Must be run from an elevated prompt
echo + Working Internet connection (to reach Microsoft Windows Update)
echo + PSWindowsUpdate in sub-directory of same name relative to this script
echo   Download: https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc
echo.
"%systemroot%\system32\reg.exe" query "HKU\S-1-5-19" 1>nul 2>nul
if not %ERRORLEVEL% EQU 0 (
      echo.
      echo ERROR: Need administrative privileges, aborting.
      echo Press any key to exit.
      pause >nul
      exit /b 1
)
echo Press Ctrl-C to cancel, Enter to continue
pause >nul
cd /d %~dp0 
if not %ERRORLEVEL% EQU 0 (
      echo.
      echo ERROR: Cannot change dir to script. Running from fileshare? Some functions may not work. 
      echo Press any key to continue or Ctrl-C to cancel
      pause >nul
)
if not exist "%~dp0PSWindowsUpdate" (
      echo.
      echo ERROR: Cannot locate PSWindowsUpdate folder. Automatic hide of this junk updates will not work.
      echo Press any key to continue or Ctrl-C to cancel
      pause >nul
)
echo.
echo * Killing GWX.exe
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableOSUpgrade /t REG_DWORD /d "1" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ReservationsAllowed /t REG_DWORD /d "0" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Gwx" /v DisableGwx /t REG_DWORD /d "1" /f
taskkill /f /im GWX.exe /T
echo.
echo * Listing any installed crapware hotfix KBs
powershell get-hotfix -ErrorAction SilentlyContinue -id KB3035583,KB2952664,KB2976978,KB3021917,KB3022345,KB3068708,KB3075249,KB3080149
echo * Uninstalling Microsoft crapware, hang tight
echo.
echo KB3035583 (Windows 7/8/8.1 - Update installs Get Windows 10 app in Windows 8.1 and Windows 7 SP1)
wusa /uninstall /kb:3035583 /quiet /norestart
echo.
echo KB2952664 (Windows 7 only - Compatibility update for upgrading Windows 7)
wusa /uninstall /kb:2952664 /quiet /norestart
echo Did it work? If not, try this manually in an elevated prompt:
echo ^> dism /online /get-packages ^| findstr KB2952664
echo ^> dism /online /remove-package /PackageName:Package_for_KB2952664~31bf3856ad364e35~amd64~~6.1.1.3
echo (for all packages found; this is one fucked up "update")
echo.
echo KB2976978 (Windows 8/8.1 only - Compatibility update for Windows 8.1 and Windows 8)
wusa /uninstall /kb:2976978 /quiet /norestart
echo.
echo KB3021917 (Windows 7 only - Update to Windows 7 SP1 for performance improvements)
wusa /uninstall /kb:3021917 /quiet /norestart
echo.
echo KB3022345 (Windows 7 only - Update to Windows 7 SP1 for performance improvements)
wusa /uninstall /kb:3022345 /quiet /norestart
echo.
echo KB3068708 (Windows 7 only - Update to Windows 7 SP1 for performance improvements)
wusa /uninstall /kb:3068708 /quiet /norestart
echo.
echo KB3075249 (Windows 7/8/8.1 - Update that adds telemetry points to consent.exe in Windows 8.1 and Windows 7)
wusa /uninstall /kb:3075249 /quiet /norestart
echo.
echo KB3080149 (Windows 7/8/8.1 - Update for customer experience and diagnostic telemetry)
wusa /uninstall /kb:3080149 /quiet /norestart
echo.
if exist "%~dp0PSWindowsUpdate" (
       echo * Hiding crapware hotfix KBs in Windows Update, this will take a moment
       echo   NOTE: Confirm with Y or A when asked
       echo.

       powershell -ExecutionPolicy RemoteSigned -NoLogo ^
          -Command "Import-Module '%~dp0PSWindowsUpdate' ; Hide-WUUpdate -confirm:$false -KBArticleID KB3035583,KB2952664,KB2976978,KB3021917,KB3022345,KB3068708,KB3075249,KB3080149"

       echo NOTE: The "H"-status stands for "hidden".
       echo.
)

echo Disabling tasks
schtasks /Change /TN "\Microsoft\Windows\Application Experience\AitAgent" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\ActivateWindowsSearch" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\ConfigureInternetTimeService" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\DispatchRecoveryTasks" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\ehDRMInit" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\InstallPlayReady" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\mcupdate" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\MediaCenterRecoveryTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\ObjectStoreRecoveryTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\OCURActivate" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\OCURDiscovery" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\PBDADiscovery" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\PBDADiscoveryW1" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\PBDADiscoveryW2" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\PvrRecoveryTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\PvrScheduleTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\RegisterSearch" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\ReindexSearchRoot" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\SqlLiteRecoveryTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\UpdateRecordPath" /DISABLE
echo.
echo Disabling DigiTrack Service
sc stop Diagtrack
sc delete Diagtrack
echo.
echo All done, hit Enter to reboot now or Crtl+C to exit.
echo Thanks for nothing, Microsoft.
pause >nul
shutdown /r /f /t 60