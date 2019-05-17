@echo off

set installs=0
set count=0

title Quick installer for Visual C++ Runtimes V1 by EliteCodexer
ver|"%windir%\system32\findstr.exe" /c:" 5."
if %errorlevel% equ 0 (
echo.
echo Windows versions older than Windows Vista are not supported.
echo No changes have been made.
echo.
echo.
echo Press any key to exit installer.
pause >nul
goto :eof
)


if defined PROCESSOR_ARCHITEW6432 (set arch=x64) else (set arch=x86)
"%windir%\system32\reg.exe" query "hklm\software\microsoft\Windows NT\currentversion" /v buildlabex >"%temp%\os.txt"

for /f "tokens=3* delims= " %%G in ('reg query "hklm\software\microsoft\Windows NT\currentversion" /v productname') do (set winv=%%G %%H)
echo %winv%|find /i "Windows 10" >nul
if errorlevel 0 (set w10=1&for /f "tokens=3" %%G in ('reg query "hklm\software\microsoft\Windows NT\currentversion" /v UBR') do (set /a UBR=%%G))

if defined w10 (for /f "skip=2 tokens=3,4,6,7 delims=. " %%G in ('type "%temp%\os.txt"') do (set "win=%winv% %arch% Build %%G.%UBR% {%%I %%J}")
) else (
for /f "skip=2 tokens=3,4,6,7 delims=. " %%G in ('type "%temp%\os.txt"') do (set "win=%winv% %arch% Build %%G.%%H {%%I %%J}")
)
del "%temp%\os.txt"

if %arch% equ x64 (for /f %%G in ('type "redists_x64.txt"') do (set /a installs+=1))
for /f %%G in ('type "redists_x86.txt"') do (set /a installs+=1)

if defined auto goto :proceed

if exist "%windir%\winsxs\pending.xml" goto :pending
"%windir%\system32\reg.exe" query "hklm\SYSTEM\CurrentControlSet\Control\Session Manager" /f "\??\C:" >nul
if %errorlevel% equ 0 goto :pending

:top
call :title
echo Before installing the latest Visual C++ Runtimes existing
echo versions should be removed.
echo.
echo It is recommended that you only run this on a fresh Windows
echo session, such as after a reboot, and that you close all other
echo programs before proceeding.
echo.
echo Would you like to remove current Visual C++ Runtimes and
echo install those packaged with this installer?
echo.
echo Selecting 'N' for 'No' will exit this installer.
echo.
echo.
echo.
choice /c YRN /n /m "Press Y for Yes, R for Readme, or N to cancel and exit> "

if errorlevel 3 goto :eof
if errorlevel 2 goto :readme
if errorlevel 1 goto :proceed

:proceed
if exist "%temp%\list.txt" (del "%temp%\list.txt")
if exist "%temp%\list2.txt" (del "%temp%\list2.txt")

if %arch% neq x64 goto :x64skip
call :title
echo Uninstalling existing Visual C++ x86 Runtime Redistributables
echo (please wait as this process may take a few moments)

reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2012 Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 Preview Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 RC Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 14 CTP Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 Preview Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 CTP Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 RC Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2017 RC Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2017 Redistributable" /s >>"%temp%\list2.txt"

if exist "%temp%\list2.txt" (for /f "delims=\ tokens=8" %%a in ('type "%temp%\list2.txt"') do (if exist "C:\ProgramData\Package Cache\%%a\vcredist_x86.exe" ("C:\ProgramData\Package Cache\%%a\vcredist_x86.exe" /uninstall /norestart /quiet) else (if exist "C:\ProgramData\Package Cache\%%a\vcredist_x64.exe" ("C:\ProgramData\Package Cache\%%a\vcredist_x64.exe" /uninstall /norestart /quiet))))

if exist "%temp%\list2.txt" (for /f "delims=\ tokens=8" %%a in ('type "%temp%\list2.txt"') do (if exist "C:\ProgramData\Package Cache\%%a\vc_redist.x86.exe" ("C:\ProgramData\Package Cache\%%a\vc_redist.x86.exe" /uninstall /norestart /quiet) else (if exist "C:\ProgramData\Package Cache\%%a\vc_redist.x64.exe" ("C:\ProgramData\Package Cache\%%a\vc_redist.x64.exe" /uninstall /norestart /quiet))))

reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2005 Redistributable" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2008 Redistributable" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2010  x86 Redistributable" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2012 x86 Minimum Runtime" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2012 x86 Additional Runtime" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 x86 Minimum Runtime" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 x86 Additional Runtime" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 14 x86 Minimum Runtime" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 14 x86 Additional Runtime" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 x86 Minimum Runtime" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 x86 Additional Runtime" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2017 x86 Minimum Runtime" /s >>"%temp%\list.txt"
reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2017 x86 Additional Runtime" /s >>"%temp%\list.txt"

if exist "%temp%\list.txt" (for /f "delims=\ tokens=8" %%a in ('type "%temp%\list.txt"') do ("%windir%\system32\msiexec.exe" /X%%a /q /norestart))

if exist "%temp%\list.txt" (del "%temp%\list.txt")
if exist "%temp%\list2.txt" (del "%temp%\list2.txt")

:x64skip
call :title
echo Uninstalling existing Visual C++ %arch% Runtime Redistributables
echo (please wait as this process may take a few moments)

reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2012 Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 Preview Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 RC Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 14 CTP Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 Preview Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 CTP Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 RC Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2017 RC Redistributable" /s >>"%temp%\list2.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2017 Redistributable" /s >>"%temp%\list2.txt"

if exist "%temp%\list2.txt" (if %arch% equ x86 (for /f "delims=\ tokens=7" %%a in ('type "%temp%\list2.txt"') do (if exist "C:\ProgramData\Package Cache\%%a\vcredist_x86.exe" ("C:\ProgramData\Package Cache\%%a\vcredist_x86.exe" /uninstall /quiet))))

if exist "%temp%\list2.txt" (if %arch% equ x86 (for /f "delims=\ tokens=7" %%a in ('type "%temp%\list2.txt"') do (if exist "C:\ProgramData\Package Cache\%%a\vc_redist.x86.exe" ("C:\ProgramData\Package Cache\%%a\vc_redist.x86.exe" /uninstall /quiet))))

reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2005 Redistributable" /s >>"%temp%\list.txt"
reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2008 Redistributable" /s >>"%temp%\list.txt"


if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "C++ 2010  x64 Redistributable" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "C++ 2010  x86 Redistributable" /s >"%temp%\list.txt")

if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2012 x64 Minimum Runtime" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2012 x86 Minimum Runtime" /s >"%temp%\list.txt")

if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2012 x64 Additional Runtime" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2012 x86 Additional Runtime" /s >"%temp%\list.txt")

if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 x64 Minimum Runtime" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 x86 Minimum Runtime" /s >"%temp%\list.txt")

if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 x64 Additional Runtime" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2013 x86 Additional Runtime" /s >"%temp%\list.txt")

if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 14 x64 Minimum Runtime" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 14 x86 Minimum Runtime" /s >"%temp%\list.txt")

if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 14 x64 Additional Runtime" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 14 x86 Additional Runtime" /s >"%temp%\list.txt")

if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 x64 Minimum Runtime" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 x86 Minimum Runtime" /s >"%temp%\list.txt")

if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 x64 Additional Runtime" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2015 x86 Additional Runtime" /s >"%temp%\list.txt")

if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2017 x64 Minimum Runtime" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2017 x86 Minimum Runtime" /s >"%temp%\list.txt")

if %arch% equ x64 (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2017 x64 Additional Runtime" /s >>"%temp%\list.txt") else (reg query hklm\software\microsoft\windows\currentversion\uninstall /f "Microsoft Visual C++ 2017 x86 Additional Runtime" /s >"%temp%\list.txt")

if exist "%temp%\list.txt" (for /f "delims=\ tokens=7" %%a in ('type "%temp%\list.txt"') do ("%windir%\system32\msiexec.exe" /X%%a /q))

for /f %%G in ('type "redists_x86.txt"') do (call :install "%%G")
if %arch% equ x64 (for /f %%G in ('type "redists_x64.txt"') do (call :install "%%G"))
if %arch% equ x64 (copy /y old_runtimes\* "%windir%\syswow64">nul) else (copy /y old_runtimes\* "%windir%\system32">nul)
if %arch% equ x64 ("%windir%\system32\regsvr32.exe" "%windir%\syswow64\comctl32.ocx" "%windir%\syswow64\comdlg32.ocx" "%windir%\syswow64\mscomctl.ocx" /s) else ("%windir%\system32\regsvr32.exe" "%windir%\system32\comctl32.ocx" "%windir%\system32\comdlg32.ocx" "%windir%\system32\mscomctl.ocx" /s)

if exist "%temp%\list.txt" (del "%temp%\list.txt")
if exist "%temp%\list2.txt" (del "%temp%\list2.txt")

if defined auto goto :eof

call :title
echo Installer has completed. 

if exist "%windir%\winsxs\pending.xml" (echo.&echo Your system has pending file operations&echo Please reboot as soon as possible!)
echo.
echo.
echo.
echo Press any key to exit...
pause >nul
goto :eof


:install
call :title
set /a count+=1
echo Installing package %count% of %installs%: %1
echo.
echo.
echo Each package may take a moment, please be patient!
"%1" /q
goto :eof


:title
cls
echo -------------------------------------
echo Installer for Visual C++ Runtimes v1 by EliteCodexer
echo -------------------------------------
echo %win%
echo.
goto :eof


:readme
cls
echo ----------------------------------------
echo Installer for Visual C++ Runtimes Readme Page 1 of 2
echo ----------------------------------------
echo %win%
echo.
echo This installer automatically installs the latest Visual C++ Runtimes
echo available at the time this version of the installer was made.
echo.
echo Runtimes included are the latest full Visual C++ Runtimes for Visual
echo C++ versions 2005, 2008, 2010, 2012, 2013, and 2015/2017. This includes
echo both x86 and x64 runtimes. On 32-bit systems only the 32 bit runtimes
echo are installed.
echo. 
echo Its written to be fast, and will be updated as soon as possible
echo after new versions of C++ Runtimes are released.
echo.
echo.
echo *****************************************************************
echo Visual Studio 2017 'branded' runtimes have been built on the 2015
echo runtimes and cover both 2015 and 2017 applications. 
echo *****************************************************************
echo.
echo.
echo.
echo.
choice /c NM /N /M "N - Next page, M - Return to Installer"

if errorlevel 2 goto :top
if errorlevel 1 goto :page2

:page2
cls
echo ----------------------------------------
echo Installer for Visual C++ Runtimes Readme Page 2 of 2
echo ----------------------------------------
echo %win%
echo.
echo Before installation the script needs to remove existing Visual C++
echo Runtimes.  You will be asked whether you want to proceed and
echo uninstall existing Visual C++ Runtimes (recommended) or cancel and
echo exit the installer. To proceed simply press Y (yes), which will
echo automatically uninstall existing Runtimes and install those packaged
echo included with this installer.
echo.
echo This script can be used in 'auto mode' (no prompting) by typing
echo 'auto' after the script name, as an option.  This is useful
echo for situations where you want it to be completely automated.
echo.
echo This installer and any later versions can be found at:
echo http://1drv.ms/1oVTfju
echo.
echo.
echo.
echo.
echo.
echo.
echo.
choice /c PLM /N /M "P - Previous Page, L - Open above link in browser, M - Return to Installer"

if errorlevel 3 goto :top
if errorlevel 2 start http://1drv.ms/1oVTfju&goto :page2
if errorlevel 1 goto :readme


:pending
call :title
echo.
echo Your system has pending file operations. System must be restarted
echo to ensure proper installation.
echo.
echo Would you like to restart your computer now? Selecting 'N' for 'No'
echo will cancel installation. If on a fresh restart you may select 'I'
echo to ignore and install.
echo.
echo If selecting yes, please save all unfinished work, as any unsaved
echo work will be lost with the system reboot.
echo.
echo.
echo.
echo.
echo.
choice /c YNI /n /m "Press Y for Yes, N to cancel and exit, or I to ignore message and continue> "

if errorlevel 3 goto :top
if errorlevel 2 goto :eof
if errorlevel 1 "%windir%\system32\shutdown.exe" /r /f /t 0