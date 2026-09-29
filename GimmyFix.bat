@echo off
:: ============================================================================
::  GimmyFix - Windows 11 Insider Toolkit
::  By Pignolo Gimmy e Fable 5.1
::  Salvare in UTF-8 SENZA BOM. Eseguire con doppio clic (si auto-eleva).
:: ============================================================================
setlocal EnableDelayedExpansion
title GimmyFix - Windows 11 Insider Toolkit

:: ---- Auto-elevazione ad amministratore --------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Richiedo i privilegi di amministratore...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: ---- Setup console -----------------------------------------------------------
chcp 65001 >nul
mode con: cols=90 lines=40
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "R=%ESC%[0m"
set "B=%ESC%[1m"
set "CY=%ESC%[96m"
set "GR=%ESC%[92m"
set "YE=%ESC%[93m"
set "RE=%ESC%[91m"
set "MA=%ESC%[95m"
set "BL=%ESC%[94m"
set "GY=%ESC%[90m"
set "WH=%ESC%[97m"
set "LOG=%~dp0GimmyFix_log.txt"
set "FOOT= %GY%───────────────────────%MA%  By Pignolo Gimmy e Fable 5.1  %GY%───────────────────────%R%"

call :log "==== Sessione avviata ===="

:: ---- Info build per l'intestazione ------------------------------------------
set "BUILDINFO=n/d"
for /f "tokens=3" %%b in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul ^| findstr CurrentBuild') do set "BUILDINFO=%%b"
for /f "tokens=3" %%u in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR 2^>nul ^| findstr UBR') do set /a UBR=%%u
if defined UBR set "BUILDINFO=!BUILDINFO!.!UBR!"

:: ============================================================================
:MENU
cls
echo.
echo %CY%%B%  ██████╗ ██╗███╗   ███╗███╗   ███╗██╗   ██╗███████╗██╗██╗  ██╗%R%
echo %CY%%B% ██╔════╝ ██║████╗ ████║████╗ ████║╚██╗ ██╔╝██╔════╝██║╚██╗██╔╝%R%
echo %CY%%B% ██║  ███╗██║██╔████╔██║██╔████╔██║ ╚████╔╝ █████╗  ██║ ╚███╔╝ %R%
echo %CY%%B% ██║   ██║██║██║╚██╔╝██║██║╚██╔╝██║  ╚██╔╝  ██╔══╝  ██║ ██╔██╗ %R%
echo %CY%%B% ╚██████╔╝██║██║ ╚═╝ ██║██║ ╚═╝ ██║   ██║   ██║     ██║██╔╝ ██╗%R%
echo %CY%%B%  ╚═════╝ ╚═╝╚═╝     ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝     ╚═╝╚═╝  ╚═╝%R%
echo %GY%              Windows 11 Insider Toolkit  ·  Build:%R% %WH%!BUILDINFO!%R%
echo.
echo %BL% ╔════════════════════════════════════════════════════════════════════════════╗%R%
echo %BL% ║%R%                                                                            %BL%║%R%
echo %BL% ║%R%  %YE%RIPARAZIONI%R%                          %YE%SISTEMA%R%                              %BL%║%R%
echo %BL% ║%R%                                                                            %BL%║%R%
echo %BL% ║%R%  %GR% [1]%R% Audio (servizi, driver)          %GR% [7]%R% SFC + DISM (file sistema)      %BL%║%R%
echo %BL% ║%R%  %GR% [2]%R% Icone / cache miniature          %GR% [8]%R% Reset rete (DNS/Winsock/IP)    %BL%║%R%
echo %BL% ║%R%  %GR% [3]%R% Indicizzazione on/off/rebuild    %GR% [9]%R% Pulizia file temporanei        %BL%║%R%
echo %BL% ║%R%  %GR% [4]%R% Windows Update (reset)           %GR%[10]%R% Microsoft Store (reset)        %BL%║%R%
echo %BL% ║%R%  %GR% [5]%R% Start / Taskbar / Explorer       %GR%[11]%R% CHKDSK al riavvio              %BL%║%R%
echo %BL% ║%R%  %GR% [6]%R% Associazioni file/immagini       %GR%[12]%R% Punto di ripristino            %BL%║%R%
echo %BL% ║%R%                                                                            %BL%║%R%
echo %BL% ║%R%  %YE%DIAGNOSI / INSIDER / INFO%R%                                                 %BL%║%R%
echo %BL% ║%R%                                                                            %BL%║%R%
echo %BL% ║%R%  %MA%%B%[17] » DIAGNOSI AUTOMATICA%R%  11 test, verdetto e consigli mirati           %BL%║%R%
echo %BL% ║%R%                                                                            %BL%║%R%
echo %BL% ║%R%  %GR%[13]%R% Info build / canale Insider     %GR%[14]%R% Apri log                        %BL%║%R%
echo %BL% ║%R%  %GR%[15]%R% Risoluzione problemi Windows    %GR%[16]%R% Riavvia PC                      %BL%║%R%
echo %BL% ║%R%                                                                            %BL%║%R%
echo %BL% ║%R%   %RE%[0]%R% Esci                                                                 %BL%║%R%
echo %BL% ║%R%                                                                            %BL%║%R%
echo %BL% ╚════════════════════════════════════════════════════════════════════════════╝%R%
echo.
echo %FOOT%
echo.
set "SCELTA="
set /p "SCELTA=%WH%  Scelta ► %R%"
if "%SCELTA%"=="1"  goto AUDIO
if "%SCELTA%"=="2"  goto ICONE
if "%SCELTA%"=="3"  goto INDEX
if "%SCELTA%"=="4"  goto WU
if "%SCELTA%"=="5"  goto SHELL
if "%SCELTA%"=="6"  goto ASSOC
if "%SCELTA%"=="7"  goto SFCDISM
if "%SCELTA%"=="8"  goto NET
if "%SCELTA%"=="9"  goto CLEAN
if "%SCELTA%"=="10" goto STORE
if "%SCELTA%"=="11" goto CHK
if "%SCELTA%"=="12" goto RESTORE
if "%SCELTA%"=="13" goto INFO
if "%SCELTA%"=="14" start "" notepad "%LOG%" & goto MENU
if "%SCELTA%"=="15" start "" ms-settings:troubleshoot & goto MENU
if "%SCELTA%"=="16" goto REBOOT
if "%SCELTA%"=="17" goto DIAG
if "%SCELTA%"=="0"  goto FINE
goto MENU

:: ============================================================================
:AUDIO
call :HEAD "RIPARAZIONE AUDIO"
echo   %GR%[1]%R% Riavvia servizi audio (Audiosrv, AudioEndpointBuilder, RpcEptMapper)
echo   %GR%[2]%R% Riavvio servizi + reset dispositivi audio (disattiva/riattiva)
echo   %GR%[3]%R% Mostra dispositivi audio e stato driver
echo   %GR%[4]%R% Apri impostazioni audio di Windows
echo   %GR%[0]%R% Indietro
echo.
set /p "S=%WH%  Scelta ► %R%"
if "%S%"=="1" (
    call :step "Riavvio servizi audio"
    sc config Audiosrv start= auto >nul
    sc config AudioEndpointBuilder start= auto >nul
    net stop Audiosrv >nul 2>&1
    net stop AudioEndpointBuilder >nul 2>&1
    net start AudioEndpointBuilder
    net start Audiosrv
    call :ok "Servizi audio riavviati"
    call :pausa
)
if "%S%"=="2" (
    call :step "Reset dispositivi audio (classe MEDIA)"
    powershell -NoProfile -Command "Get-PnpDevice -Class MEDIA -Status OK | ForEach-Object { Write-Host ('  > ' + $_.FriendlyName); Disable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false -ErrorAction SilentlyContinue; Start-Sleep 1; Enable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false -ErrorAction SilentlyContinue }"
    net stop Audiosrv >nul 2>&1
    net start Audiosrv >nul 2>&1
    call :ok "Dispositivi audio resettati"
    call :pausa
)
if "%S%"=="3" (
    call :step "Dispositivi audio rilevati"
    powershell -NoProfile -Command "Get-PnpDevice -Class MEDIA,AudioEndpoint | Sort-Object Class | Format-Table Class,Status,FriendlyName -AutoSize"
    sc query Audiosrv | findstr STATE
    call :pausa
)
if "%S%"=="4" start "" ms-settings:sound
if "%S%"=="0" goto MENU
goto AUDIO

:: ============================================================================
:ICONE
call :HEAD "RIPARAZIONE ICONE E MINIATURE"
echo   %GR%[1]%R% Ricostruisci cache icone (IconCache + iconcache_*.db) e riavvia Explorer
echo   %GR%[2]%R% Ricostruisci anche cache miniature (thumbcache_*.db)
echo   %GR%[3]%R% Ripristina icone desktop di default (Questo PC, Cestino, ecc.)
echo   %GR%[0]%R% Indietro
echo.
set /p "S=%WH%  Scelta ► %R%"
if "%S%"=="1" call :ICONCACHE 0
if "%S%"=="2" call :ICONCACHE 1
if "%S%"=="3" (
    call :step "Ripristino icone desktop e reset dimensione icone"
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop" /v IconSize /f >nul 2>&1
    ie4uinit.exe -show
    call :ok "Fatto - se serve, apri: ms-settings:themes → Impostazioni icone del desktop"
    call :pausa
)
if "%S%"=="0" goto MENU
goto ICONE

:ICONCACHE
call :step "Chiudo Explorer e cancello la cache icone"
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
del /a /q /f "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
del /a /q /f "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
if "%~1"=="1" (
    del /a /q /f "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
    call :ok "Cache miniature cancellata"
)
ie4uinit.exe -ClearIconCache >nul 2>&1
call :ok "Cache icone cancellata"
call :STARTEXPLORER
call :pausa
exit /b

:: ============================================================================
:INDEX
call :HEAD "INDICIZZAZIONE FILE (Windows Search)"
for /f "tokens=4" %%s in ('sc query WSearch ^| findstr "STATE"') do set "WSTATE=%%s"
echo   Stato attuale servizio WSearch: %YE%!WSTATE!%R%
echo.
echo   %GR%[1]%R% Attiva indicizzazione (avvio automatico ritardato)
echo   %GR%[2]%R% Disattiva indicizzazione (ferma e disabilita il servizio)
echo   %GR%[3]%R% Ricostruisci indice da zero (cancella Windows.edb)
echo   %GR%[4]%R% Apri Opzioni di indicizzazione
echo   %GR%[0]%R% Indietro
echo.
set /p "S=%WH%  Scelta ► %R%"
if "%S%"=="1" (
    sc config WSearch start= delayed-auto >nul
    net start WSearch >nul 2>&1
    call :ok "Indicizzazione ATTIVATA"
    call :pausa
)
if "%S%"=="2" (
    net stop WSearch >nul 2>&1
    sc config WSearch start= disabled >nul
    call :ok "Indicizzazione DISATTIVATA"
    call :pausa
)
if "%S%"=="3" (
    call :step "Ricostruzione indice"
    net stop WSearch >nul 2>&1
    del /q /f "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb" >nul 2>&1
    del /q /f "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.db" >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f >nul
    sc config WSearch start= delayed-auto >nul
    net start WSearch >nul 2>&1
    call :ok "Indice cancellato, verrà ricostruito in background"
    call :pausa
)
if "%S%"=="4" control srchadmin.dll
if "%S%"=="0" goto MENU
goto INDEX

:: ============================================================================
:WU
call :HEAD "RESET COMPLETO WINDOWS UPDATE"
echo   Questa procedura: ferma i servizi, rinomina SoftwareDistribution e catroot2,
echo   ri-registra le DLL di Update, resetta Winsock/BITS e riavvia i servizi.
echo.
set /p "S=%WH%  Procedere? [S/N] ► %R%"
if /i not "%S%"=="S" goto MENU
call :step "Arresto servizi"
for %%s in (wuauserv cryptSvc bits msiserver usosvc dosvc) do net stop %%s >nul 2>&1
call :step "Pulizia code BITS"
del /q /f "%ALLUSERSPROFILE%\Microsoft\Network\Downloader\qmgr*.dat" >nul 2>&1
call :step "Rinomino cartelle"
if exist "%SystemRoot%\SoftwareDistribution.old" rd /s /q "%SystemRoot%\SoftwareDistribution.old" >nul 2>&1
if exist "%SystemRoot%\System32\catroot2.old" rd /s /q "%SystemRoot%\System32\catroot2.old" >nul 2>&1
ren "%SystemRoot%\SoftwareDistribution" SoftwareDistribution.old >nul 2>&1
ren "%SystemRoot%\System32\catroot2" catroot2.old >nul 2>&1
call :step "Reset descrittori di sicurezza"
sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU) >nul
sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU) >nul
call :step "Ri-registrazione DLL"
cd /d %SystemRoot%\System32
for %%d in (atl.dll urlmon.dll mshtml.dll shdocvw.dll browseui.dll jscript.dll vbscript.dll scrrun.dll msxml.dll msxml3.dll msxml6.dll actxprxy.dll softpub.dll wintrust.dll dssenh.dll rsaenh.dll gpkcsp.dll sccbase.dll slbcsp.dll cryptdlg.dll oleaut32.dll ole32.dll shell32.dll initpki.dll wuapi.dll wuaueng.dll wuaueng1.dll wucltui.dll wups.dll wups2.dll wuweb.dll qmgr.dll qmgrprxy.dll wucltux.dll muweb.dll wuwebv.dll) do regsvr32.exe /s %%d >nul 2>&1
call :step "Reset Winsock e proxy"
netsh winsock reset >nul
netsh winhttp reset proxy >nul
call :step "Riavvio servizi"
for %%s in (bits cryptSvc msiserver wuauserv usosvc dosvc) do net start %%s >nul 2>&1
call :step "Avvio scansione aggiornamenti"
usoclient StartScan >nul 2>&1
call :ok "Windows Update resettato. Consigliato un riavvio."
call :pausa
goto MENU

:: ============================================================================
:SHELL
call :HEAD "START MENU / TASKBAR / EXPLORER"
echo   %GR%[1]%R% Riavvia solo Explorer
echo   %GR%[2]%R% Ri-registra Start Menu, Taskbar, Shell Experience e Search
echo   %GR%[3]%R% Reset completo shell: 1 + 2 + cache icone
echo   %GR%[0]%R% Indietro
echo.
set /p "S=%WH%  Scelta ► %R%"
if "%S%"=="1" (
    taskkill /f /im explorer.exe >nul 2>&1
    timeout /t 1 >nul
    call :STARTEXPLORER
    call :pausa
)
if "%S%"=="2" call :REREGSHELL
if "%S%"=="3" (
    call :REREGSHELL
    call :ICONCACHE 0
)
if "%S%"=="0" goto MENU
goto SHELL

:REREGSHELL
call :step "Ri-registrazione pacchetti della shell (può richiedere 1-2 minuti)"
taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
taskkill /f /im ShellExperienceHost.exe >nul 2>&1
taskkill /f /im SearchHost.exe >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$pk='Microsoft.Windows.StartMenuExperienceHost','Microsoft.Windows.ShellExperienceHost','MicrosoftWindows.Client.CBS','Microsoft.Windows.Search','Microsoft.UI.Xaml.*','Microsoft.WindowsAppRuntime.*'; foreach($p in $pk){ Get-AppxPackage -AllUsers $p -ErrorAction SilentlyContinue | ForEach-Object { Write-Host ('  > ' + $_.Name); Add-AppxPackage -DisableDevelopmentMode -Register ($_.InstallLocation + '\AppxManifest.xml') -ErrorAction SilentlyContinue } }"
call :ok "Pacchetti shell ri-registrati"
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 >nul
call :STARTEXPLORER
call :pausa
exit /b

:: ============================================================================
:ASSOC
call :HEAD "ASSOCIAZIONI FILE"
echo   %GR%[1]%R% Ripristina apertura immagini con Foto (jpg/png/gif/bmp/webp)
echo   %GR%[2]%R% Ripristina .lnk / .exe / .bat / .reg (se doppio clic non funziona)
echo   %GR%[3]%R% Apri App predefinite
echo   %GR%[0]%R% Indietro
echo.
set /p "S=%WH%  Scelta ► %R%"
if "%S%"=="1" (
    for %%e in (jpg jpeg png gif bmp webp tif tiff) do reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.%%e\UserChoice" /f >nul 2>&1
    start "" ms-settings:defaultapps
    call :ok "Aperte le App predefinite: imposta Foto per le immagini"
    call :pausa
)
if "%S%"=="2" (
    assoc .lnk=lnkfile >nul
    assoc .exe=exefile >nul
    assoc .bat=batfile >nul
    assoc .cmd=cmdfile >nul
    assoc .reg=regfile >nul
    ftype exefile="%%1" %%* >nul
    ftype batfile="%%1" %%* >nul
    ftype cmdfile="%%1" %%* >nul
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.lnk\UserChoice" /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\UserChoice" /f >nul 2>&1
    call :ok "Associazioni base ripristinate"
    call :pausa
)
if "%S%"=="3" start "" ms-settings:defaultapps
if "%S%"=="0" goto MENU
goto ASSOC

:: ============================================================================
:SFCDISM
call :HEAD "SFC + DISM"
echo   %GR%[1]%R% Solo SFC /scannow
echo   %GR%[2]%R% DISM CheckHealth + ScanHealth (solo verifica)
echo   %GR%[3]%R% DISM RestoreHealth + SFC (riparazione completa, ~10-20 min)
echo   %GR%[4]%R% Pulizia Component Store (StartComponentCleanup /ResetBase)
echo   %GR%[0]%R% Indietro
echo.
set /p "S=%WH%  Scelta ► %R%"
if "%S%"=="1" sfc /scannow & call :pausa
if "%S%"=="2" dism /online /cleanup-image /checkhealth & dism /online /cleanup-image /scanhealth & call :pausa
if "%S%"=="3" dism /online /cleanup-image /restorehealth & sfc /scannow & call :ok "Log DISM: %SystemRoot%\Logs\DISM\dism.log" & call :pausa
if "%S%"=="4" dism /online /cleanup-image /startcomponentcleanup /resetbase & call :pausa
if "%S%"=="0" goto MENU
goto SFCDISM

:: ============================================================================
:NET
call :HEAD "RESET RETE"
echo   %GR%[1]%R% Flush DNS + rinnovo DHCP (leggero)
echo   %GR%[2]%R% Reset completo: Winsock, IPv4, IPv6, proxy, firewall (richiede riavvio)
echo   %GR%[3]%R% Mostra configurazione IP
echo   %GR%[0]%R% Indietro
echo.
set /p "S=%WH%  Scelta ► %R%"
if "%S%"=="1" (
    ipconfig /flushdns
    ipconfig /release >nul & ipconfig /renew >nul
    call :ok "DNS svuotato, IP rinnovato"
    call :pausa
)
if "%S%"=="2" (
    ipconfig /flushdns
    netsh winsock reset
    netsh int ip reset
    netsh int ipv6 reset
    netsh winhttp reset proxy
    netsh advfirewall reset
    call :ok "Stack di rete resettato - RIAVVIA il PC"
    call :pausa
)
if "%S%"=="3" ipconfig /all | more & call :pausa
if "%S%"=="0" goto MENU
goto NET

:: ============================================================================
:CLEAN
call :HEAD "PULIZIA FILE TEMPORANEI"
call :step "Pulizia %%TEMP%%, Windows\Temp, Prefetch, log Update, cestino"
del /s /q /f "%TEMP%\*" >nul 2>&1
for /d %%d in ("%TEMP%\*") do rd /s /q "%%d" >nul 2>&1
del /s /q /f "%SystemRoot%\Temp\*" >nul 2>&1
del /s /q /f "%SystemRoot%\Prefetch\*" >nul 2>&1
del /s /q /f "%SystemRoot%\Logs\CBS\*.log" >nul 2>&1
del /q /f "%LOCALAPPDATA%\Microsoft\Windows\WER\ReportQueue\*" >nul 2>&1
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
call :ok "Pulizia completata"
set /p "S=%WH%  Avviare anche Pulizia disco di Windows? [S/N] ► %R%"
if /i "%S%"=="S" cleanmgr /d %SystemDrive%
goto MENU

:: ============================================================================
:STORE
call :HEAD "MICROSOFT STORE"
echo   %GR%[1]%R% wsreset (svuota cache Store)
echo   %GR%[2]%R% Ri-registra Microsoft Store e app inbox (tutti gli utenti)
echo   %GR%[0]%R% Indietro
echo.
set /p "S=%WH%  Scelta ► %R%"
if "%S%"=="1" wsreset.exe & call :ok "Cache Store svuotata" & call :pausa
if "%S%"=="2" (
    call :step "Ri-registrazione app (può richiedere qualche minuto)"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register ($_.InstallLocation + '\AppxManifest.xml') -ErrorAction SilentlyContinue }"
    call :ok "App ri-registrate"
    call :pausa
)
if "%S%"=="0" goto MENU
goto STORE

:: ============================================================================
:CHK
call :HEAD "CHKDSK"
echo   Marca %SystemDrive% come dirty: al prossimo riavvio parte chkdsk /f (indipendente dalla lingua).
set /p "S=%WH%  Procedere? [S/N] ► %R%"
if /i "%S%"=="S" (
    fsutil dirty set %SystemDrive% >nul
    chkntfs /c %SystemDrive% >nul
    call :ok "Volume marcato dirty: chkdsk /f girerà al prossimo riavvio (per /r: chkdsk C: /r da terminale e rispondi)"
    call :pausa
)
goto MENU

:: ============================================================================
:RESTORE
call :HEAD "PUNTO DI RIPRISTINO"
call :step "Creo punto di ripristino 'GimmyFix'"
powershell -NoProfile -Command "Enable-ComputerRestore -Drive $env:SystemDrive -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'GimmyFix' -RestorePointType MODIFY_SETTINGS"
call :ok "Se non compare errore, il punto è stato creato (limite: 1 ogni 24h)"
call :pausa
goto MENU

:: ============================================================================
:INFO
call :HEAD "INFO SISTEMA / INSIDER"
powershell -NoProfile -Command "$cv=Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'; $ins=Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\WindowsSelfHost\UI\Selection' -EA SilentlyContinue; $os=Get-CimInstance Win32_OperatingSystem; Write-Host ('  Prodotto      : ' + $cv.ProductName + ' ' + $cv.DisplayVersion); Write-Host ('  Build         : ' + $cv.CurrentBuild + '.' + $cv.UBR + '   (' + $cv.BuildLabEx + ')'); Write-Host ('  Canale Insider: ' + $(if($ins){$ins.UIRing + ' / ' + $ins.UIContentType}else{'non iscritto'})); Write-Host ('  Uptime        : ' + ((Get-Date) - $os.LastBootUpTime).ToString('d\.hh\:mm')); Write-Host ('  RAM           : ' + [math]::Round($os.TotalVisibleMemorySize/1MB,1) + ' GB, libera ' + [math]::Round($os.FreePhysicalMemory/1MB,1) + ' GB'); Write-Host ''; Write-Host '  Ultimi 5 errori critici (System log):'; Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2} -MaxEvents 5 -EA SilentlyContinue | Format-Table TimeCreated,Id,ProviderName -AutoSize"
call :pausa
goto MENU

:: ============================================================================
:DIAG
call :HEAD "DIAGNOSI AUTOMATICA"
echo   Eseguo i test (30-90 secondi). Non chiudere la finestra.
echo   Report salvato in: %GY%%~dp0GimmyFix_diagnosi.txt%R%
echo.
set "GF_REPORT=%~dp0GimmyFix_diagnosi.txt"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$f=[IO.File]::ReadAllText('%~f0',[Text.Encoding]::UTF8); $c=$f.Substring($f.IndexOf('#::PS'+'BEGIN')); & ([scriptblock]::Create($c))"
call :log "   diagnosi eseguita"
call :pausa
goto MENU

:: ============================================================================
:REBOOT
set /p "S=%WH%  Riavviare ora? [S/N] ► %R%"
if /i "%S%"=="S" shutdown /r /t 5 /c "GimmyFix: riavvio"
goto MENU

:: ============================================================================
:: FUNZIONI
:: ============================================================================
:HEAD
cls
echo.
echo %BL% ╔════════════════════════════════════════════════════════════════════════════╗%R%
echo %BL% ║%R%  %CY%%B%%~1%R%
echo %BL% ╚════════════════════════════════════════════════════════════════════════════╝%R%
echo.
call :log "-- %~1"
exit /b

:step
echo   %YE%► %~1%R%
call :log "   step: %~1"
exit /b

:ok
echo   %GR%✔ %~1%R%
call :log "   ok:   %~1"
exit /b

:: ----------------------------------------------------------------------------
:: STARTEXPLORER - Explorer lanciato da un prompt ELEVATO non parte come shell:
:: cerca di delegare a una shell esistente, non la trova e si chiude in silenzio.
:: Strategia: 1) riavvio automatico di Winlogon  2) attivita pianificata come
::            utente normale (/IT /RL LIMITED)  3) runas /trustlevel  4) istruzioni
:STARTEXPLORER
call :step "Riavvio Explorer come utente normale (non elevato)"
call :WAITEXP 5 && goto :EXPOK
set "IUSER="
for /f "usebackq delims=" %%u in (`powershell -NoProfile -Command "(Get-CimInstance Win32_ComputerSystem).UserName"`) do set "IUSER=%%u"
if not defined IUSER set "IUSER=%USERDOMAIN%\%USERNAME%"
schtasks /create /tn "GimmyFix_Explorer" /tr "%WINDIR%\explorer.exe" /sc once /st 23:59 /ru "%IUSER%" /it /rl limited /f >nul 2>&1
schtasks /run /tn "GimmyFix_Explorer" >nul 2>&1
call :WAITEXP 8
set "EXPRC=%errorlevel%"
schtasks /delete /tn "GimmyFix_Explorer" /f >nul 2>&1
if "%EXPRC%"=="0" goto :EXPOK
runas /trustlevel:0x20000 "%WINDIR%\explorer.exe" >nul 2>&1
call :WAITEXP 6 && goto :EXPOK
echo   %RE%✖ Explorer non si e riavviato da solo.%R%
echo   %WH%  Premi Ctrl+Shift+Esc ^> Esegui nuova attivita ^> scrivi explorer ^> Invio%R%
call :log "   ERR:  Explorer non riavviato (utente %IUSER%)"
exit /b 1
:EXPOK
call :ok "Explorer attivo"
exit /b 0

:WAITEXP
:: attende fino a %1 secondi che explorer.exe sia in esecuzione
set /a "_WN=%~1"
:WAITEXP_LOOP
tasklist /fi "imagename eq explorer.exe" /nh 2>nul | find /i "explorer.exe" >nul && exit /b 0
set /a "_WN-=1"
if %_WN% LEQ 0 exit /b 1
timeout /t 1 /nobreak >nul
goto :WAITEXP_LOOP

:pausa
echo.
echo %FOOT%
echo.
pause
exit /b

:log
echo [%date% %time:~0,8%] %~1>>"%LOG%"
exit /b

:FINE
call :log "==== Sessione chiusa ===="
cls
echo.
echo   %CY%Ciao Gimmy, alla prossima.%R%
echo.
echo %FOOT%
timeout /t 2 >nul
exit /b

:: ============================================================================
:: Da qui in poi: script PowerShell della diagnosi. cmd non arriva mai qui
:: (il batch termina con exit /b). Viene estratto ed eseguito dall'opzione 17.
:: ============================================================================
#::PSBEGIN
$ErrorActionPreference = 'SilentlyContinue'
$script:issues = @()
$script:lines  = @()
$since14 = (Get-Date).AddDays(-14)

function Add-Issue($sev,$area,$msg,$fix){ $script:issues += [pscustomobject]@{Sev=$sev;Area=$area;Msg=$msg;Fix=$fix} }
function Out($t,$c='Gray'){ Write-Host $t -ForegroundColor $c; $script:lines += $t }
function T($t){ Out '' ; Out ("  ► " + $t) 'Yellow' }
function OK($t){ Out ("    ✔ " + $t) 'Green' }
function WA($t){ Out ("    ⚠ " + $t) 'DarkYellow' }
function KO($t){ Out ("    ✖ " + $t) 'Red' }
function Cut($s,$n=150){ $s = ($s -replace '\s+',' ').Trim(); if($s.Length -gt $n){ $s.Substring(0,$n)+'…' } else { $s } }
$fixByArea = @{ 'Audio'='Opzione [1]'; 'Windows Update'='Opzione [4]'; 'Indicizzazione'='Opzione [3]'; 'Shell'='Opzione [5]'; 'Rete'='Opzione [8]'; 'Store/App'='Opzione [10]'; 'Sistema'='Opzione [7]' }

Out ("  Avvio: " + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')) 'DarkGray'

# ---------------------------------------------------------------- 1. DISCO
T "Disco: spazio, salute volume e dischi fisici"
$sd = $env:SystemDrive.TrimEnd(':')
$v  = Get-Volume -DriveLetter $sd
if($v){
  $freePct = [math]::Round($v.SizeRemaining / $v.Size * 100, 1)
  $freeGB  = [math]::Round($v.SizeRemaining / 1GB, 1)
  if($freePct -lt 10){ KO "Spazio libero su ${sd}: $freeGB GB ($freePct%)"; Add-Issue 3 'Disco' "Solo $freePct% libero su ${sd}: Windows Update, DISM e Store falliscono spesso sotto il 10%" 'Opzione [9] pulizia, poi [7]/4 ResetBase' }
  elseif($freePct -lt 20){ WA "Spazio libero su ${sd}: $freeGB GB ($freePct%)"; Add-Issue 1 'Disco' "Spazio libero al $freePct%, sotto la soglia di comfort per un Insider (i flight scaricano 5-8 GB)" 'Opzione [9]' }
  else { OK "Spazio libero su ${sd}: $freeGB GB ($freePct%)" }
  if($v.HealthStatus -ne 'Healthy'){ KO "Volume ${sd}: HealthStatus = $($v.HealthStatus)"; Add-Issue 3 'Disco' "Il volume $sd non è Healthy ($($v.HealthStatus))" 'Opzione [11] CHKDSK al riavvio' } else { OK "Volume ${sd}: Healthy" }
}
foreach($pd in Get-PhysicalDisk){
  if($pd.HealthStatus -ne 'Healthy'){ KO "Disco fisico '$($pd.FriendlyName)': $($pd.HealthStatus) / $($pd.OperationalStatus)"; Add-Issue 3 'Hardware' "Disco '$($pd.FriendlyName)' segnala $($pd.HealthStatus)" 'BACKUP SUBITO. Nessuna riparazione software risolve un disco malato.' }
  else { OK "Disco fisico '$($pd.FriendlyName)' ($($pd.MediaType)): Healthy" }
  $rc = $pd | Get-StorageReliabilityCounter
  if($rc){
    if(($rc.ReadErrorsUncorrected -gt 0) -or ($rc.WriteErrorsUncorrected -gt 0)){ KO "  errori non correggibili: R=$($rc.ReadErrorsUncorrected) W=$($rc.WriteErrorsUncorrected)"; Add-Issue 3 'Hardware' "Disco '$($pd.FriendlyName)': errori di lettura/scrittura non correggibili" 'BACKUP e sostituzione' }
    if($rc.Wear -gt 85){ WA "  usura SSD: $($rc.Wear)%"; Add-Issue 2 'Hardware' "SSD '$($pd.FriendlyName)' usura $($rc.Wear)%" 'Pianifica la sostituzione' }
    if($rc.Temperature -gt 65){ WA "  temperatura: $($rc.Temperature)°C"; Add-Issue 2 'Hardware' "Disco '$($pd.FriendlyName)' a $($rc.Temperature)°C" 'Controlla ventilazione / dissipatore NVMe' }
  }
}
$diskEv = @(Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='disk','Ntfs','volmgr','stornvme','storahci';Level=1,2,3;StartTime=(Get-Date).AddDays(-7)})
if($diskEv.Count -gt 0){ WA "$($diskEv.Count) eventi disco/NTFS/storage negli ultimi 7 giorni (primo: $($diskEv[0].ProviderName) ID $($diskEv[0].Id))"; Add-Issue 2 'Disco' "$($diskEv.Count) eventi disco/NTFS in 7 giorni — $(Cut $diskEv[0].Message 110)" 'Opzione [11] CHKDSK; se persistono, cavi/slot e SMART del disco' }
else { OK "Nessun evento disco/NTFS negli ultimi 7 giorni" }

# ---------------------------------------------------------------- 2. SERVIZI
T "Servizi critici"
$svcMap = [ordered]@{
  Audiosrv='Audio'; AudioEndpointBuilder='Audio';
  wuauserv='Windows Update'; bits='Windows Update'; cryptSvc='Windows Update'; UsoSvc='Windows Update';
  WSearch='Indicizzazione';
  Themes='Shell'; ShellHWDetection='Shell';
  Dnscache='Rete'; Dhcp='Rete'; nsi='Rete'; NlaSvc='Rete';
  EventLog='Sistema'; Winmgmt='Sistema'; RpcSs='Sistema'; Schedule='Sistema'; W32Time='Sistema';
  StateRepository='Store/App'; AppXSvc='Store/App'; ClipSVC='Store/App'; LicenseManager='Store/App'
}
$onDemandOk = 'wuauserv','bits','cryptSvc','UsoSvc','AppXSvc','ClipSVC','LicenseManager','W32Time','ShellHWDetection'
$svcBad = 0
foreach($k in $svcMap.Keys){
  $s = Get-Service $k
  $area = $svcMap[$k]
  if(-not $s){ WA "$k non esiste su questa build"; continue }
  if($s.StartType -eq 'Disabled' -and $k -ne 'WSearch'){ KO "$k DISABILITATO ($area)"; Add-Issue 3 $area "Il servizio $k è disabilitato: $area non può funzionare" $fixByArea[$area]; $svcBad++ }
  elseif($s.StartType -eq 'Disabled' -and $k -eq 'WSearch'){ WA "WSearch disabilitato (indicizzazione spenta di proposito?)" }
  elseif($s.Status -ne 'Running' -and $k -notin $onDemandOk){ WA "$k fermo ($area)"; Add-Issue 2 $area "Il servizio $k non è in esecuzione" $fixByArea[$area]; $svcBad++ }
}
if($svcBad -eq 0){ OK "Tutti i servizi critici sono nello stato atteso" }

# ---------------------------------------------------------------- 3. RIAVVIO / UPTIME
T "Riavvio in sospeso e uptime"
$pend = @()
if(Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'){ $pend += 'WindowsUpdate' }
if(Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'){ $pend += 'CBS' }
if((Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager').PendingFileRenameOperations){ $pend += 'PendingFileRename' }
if($pend.Count){ WA "Riavvio in sospeso richiesto da: $($pend -join ', ')"; Add-Issue 2 'Sistema' "Riavvio in sospeso ($($pend -join ', ')): SFC/DISM/Update possono dare risultati falsati finché non riavvii" 'Opzione [16] riavvio PRIMA di altre riparazioni' }
else { OK "Nessun riavvio in sospeso" }
$os = Get-CimInstance Win32_OperatingSystem
$up = (Get-Date) - $os.LastBootUpTime
if($up.TotalDays -gt 10){ WA "Uptime: $([int]$up.TotalDays) giorni"; Add-Issue 1 'Sistema' "Uptime di $([int]$up.TotalDays) giorni (con Avvio rapido attivo lo spegnimento NON azzera il kernel)" 'Riavvio vero: shutdown /r, non spegni-accendi' }
else { OK "Uptime: $($up.ToString('d\.hh\:mm'))" }

# ---------------------------------------------------------------- 4. WINDOWS UPDATE
T "Windows Update"
$au = (New-Object -ComObject Microsoft.Update.AutoUpdate).Results
if($au.LastSearchSuccessDate){
  $ageS = ((Get-Date) - $au.LastSearchSuccessDate).TotalDays
  if($ageS -gt 7){ WA "Ultima ricerca riuscita: $($au.LastSearchSuccessDate) ($([int]$ageS) gg fa)"; Add-Issue 2 'Windows Update' "Nessuna ricerca aggiornamenti riuscita da $([int]$ageS) giorni" 'Opzione [4] reset completo' }
  else { OK "Ultima ricerca riuscita: $($au.LastSearchSuccessDate)" }
} else { WA "Nessuna ricerca riuscita registrata"; Add-Issue 2 'Windows Update' 'Il client Update non ha mai registrato una ricerca riuscita' 'Opzione [4]' }
if($au.LastInstallationSuccessDate){ OK "Ultima installazione riuscita: $($au.LastInstallationSuccessDate)" }
$wuFail = @(Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='Microsoft-Windows-WindowsUpdateClient';Id=20;StartTime=$since14})
if($wuFail.Count){ KO "$($wuFail.Count) installazioni fallite in 14 gg"; KO ("  ultima: " + (Cut $wuFail[0].Message 140)); Add-Issue 3 'Windows Update' "$($wuFail.Count) installazioni fallite in 14 gg — $(Cut $wuFail[0].Message 120)" 'Opzione [4], poi [7]/3 RestoreHealth+SFC. Se il codice è 0x800F08xx/0x8007000D quasi sempre è il component store.' }
else { OK "Nessuna installazione fallita negli ultimi 14 giorni" }
$sdGB = [math]::Round(((Get-ChildItem "$env:SystemRoot\SoftwareDistribution\Download" -Recurse -File | Measure-Object Length -Sum).Sum / 1GB), 1)
if($sdGB -gt 5){ WA "SoftwareDistribution\Download pesa $sdGB GB"; Add-Issue 1 'Windows Update' "Cache download di Update a $sdGB GB (probabili download corrotti/ripetuti)" 'Opzione [4] la svuota' } else { OK "Cache download Update: $sdGB GB" }

# ---------------------------------------------------------------- 5. INTEGRITÀ
T "Integrità immagine (DISM /CheckHealth, ~10 s)"
$d = (dism /online /cleanup-image /checkhealth 2>&1 | Out-String)
if($d -match 'not repairable|non riparabile|non è riparabile'){ KO "Component store DANNEGGIATO e non riparabile"; Add-Issue 3 'Sistema' 'DISM: component store corrotto e non riparabile' 'Riparazione in-place da ISO (setup.exe → Mantieni file e app). Sconsigliato insistere con SFC.' }
elseif($d -match 'repairable|riparabile'){ KO "Component store danneggiato ma riparabile"; Add-Issue 3 'Sistema' 'DISM: component store corrotto ma riparabile' 'Opzione [7]/3 RestoreHealth + SFC' }
elseif($d -match 'No component store corruption|Nessun danneggiamento'){ OK "Component store integro" }
else { WA "DISM ha risposto in modo inatteso: $(Cut $d 100)" }
$cbs = Get-Item "$env:SystemRoot\Logs\CBS\CBS.log"
if($cbs -and $cbs.Length/1MB -gt 300){ WA "CBS.log pesa $([int]($cbs.Length/1MB)) MB"; Add-Issue 1 'Sistema' 'CBS.log enorme: sintomo di SFC/DISM che girano in loop o falliscono' 'Opzione [9] lo ripulisce; leggi le ultime righe prima' }
$sfcHint = Select-String -Path "$env:SystemRoot\Logs\CBS\CBS.log" -Pattern 'cannot repair member file' -SimpleMatch | Select-Object -Last 1
if($sfcHint){ WA "CBS.log: SFC ha trovato file che NON riesce a riparare"; Add-Issue 2 'Sistema' "SFC ha trovato file non riparabili ($(Cut $sfcHint.Line 100))" 'Opzione [7]/3 (DISM prima, SFC dopo). Su Insider può essere un falso positivo del flight.' }

# ---------------------------------------------------------------- 6. STABILITÀ
T "Crash, BSOD, spegnimenti anomali, hardware (14 gg)"
$bsod = @(Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='Microsoft-Windows-WER-SystemErrorReporting';Id=1001;StartTime=$since14})
if($bsod.Count){ KO "$($bsod.Count) BSOD"; KO ("  ultimo: " + (Cut $bsod[0].Message 140)); Add-Issue 3 'Stabilità' "$($bsod.Count) schermate blu in 14 gg — $(Cut $bsod[0].Message 100)" 'Analizza C:\Windows\Minidump (WinDbg: !analyze -v). Su Insider: driver GPU/audio/rete sono i primi sospetti.' }
else { OK "Nessun BSOD" }
$kp = @(Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='Microsoft-Windows-Kernel-Power';Id=41;StartTime=$since14})
if($kp.Count){ WA "$($kp.Count) spegnimenti improvvisi (Kernel-Power 41)"; Add-Issue 2 'Stabilità' "$($kp.Count) spegnimenti non puliti in 14 gg" 'Alimentatore/UPS, temperature CPU-GPU, RAM (mdsched.exe). Se coincidono con BSOD, guarda i minidump.' }
else { OK "Nessuno spegnimento anomalo" }
$whea = @(Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='Microsoft-Windows-WHEA-Logger';StartTime=$since14})
if($whea.Count){ KO "$($whea.Count) errori hardware WHEA"; Add-Issue 3 'Hardware' "$($whea.Count) errori WHEA (CPU/cache/memoria/PCIe) in 14 gg" 'Problema fisico, non software: test RAM, togli overclock/XMP, controlla temperature e alimentazione' }
else { OK "Nessun errore hardware WHEA" }
$appcr = @(Get-WinEvent -FilterHashtable @{LogName='Application';ProviderName='Application Error';Id=1000;StartTime=$since14})
if($appcr.Count){
  $expl = @($appcr | Where-Object { $_.Message -match 'explorer\.exe' })
  if($expl.Count -ge 3){ WA "Explorer crashato $($expl.Count) volte"; Add-Issue 2 'Shell' "Explorer.exe crasha spesso ($($expl.Count) volte in 14 gg)" 'Opzione [5]/3 reset shell + [2] cache icone. Se il modulo colpevole è una DLL di terze parti (menu contestuali), disinstallala.' }
  $top = $appcr | ForEach-Object { if($_.Message -match '(?m)^[^\r\n]*?:\s*([^\s,]+\.exe)'){ $matches[1] } } | Group-Object | Sort-Object Count -Descending | Select-Object -First 4
  if($top){ WA ("App crashate più spesso: " + (($top | ForEach-Object { "$($_.Name) x$($_.Count)" }) -join ', ')) }
} else { OK "Nessun crash applicativo registrato" }
$scm = @(Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='Service Control Manager';Id=7000,7001,7011,7023,7031,7034;StartTime=(Get-Date).AddDays(-3)})
if($scm.Count -gt 5){ WA "$($scm.Count) errori avvio/arresto servizi (SCM) in 3 gg"; Add-Issue 1 'Sistema' "$($scm.Count) errori SCM in 3 giorni — $(Cut $scm[0].Message 100)" 'Visualizzatore eventi → Sistema, filtra ID 7000-7034 e vedi quale servizio' }
else { OK "Errori servizi (SCM) nella norma" }

# ---------------------------------------------------------------- 7. DRIVER / DISPOSITIVI
T "Dispositivi con problemi e audio"
$bad = @(Get-PnpDevice -PresentOnly | Where-Object { $_.Status -in 'Error','Degraded' })
if($bad.Count){
  foreach($b in $bad){
    KO "$($b.Class): $($b.FriendlyName)  [codice $($b.Problem)]"
    if($b.Class -in 'MEDIA','AudioEndpoint'){ Add-Issue 3 'Audio' "Dispositivo audio in errore: $($b.FriendlyName) (codice $($b.Problem))" 'Opzione [1]/2 reset; se resta, reinstalla il driver dal produttore (non da Update)' }
    elseif($b.Class -in 'Net'){ Add-Issue 3 'Rete' "Scheda di rete in errore: $($b.FriendlyName) (codice $($b.Problem))" 'Reinstalla driver; opzione [8]/2 dopo' }
    else { Add-Issue 2 'Driver' "$($b.Class) '$($b.FriendlyName)' in errore (codice $($b.Problem))" 'Gestione dispositivi → disinstalla con rimozione driver → riavvio. Codice 10/43 = driver/hardware, 28 = driver mancante, 45 = staccato.' }
  }
} else { OK "Nessun dispositivo in errore in Gestione dispositivi" }
$ep = @(Get-PnpDevice -Class AudioEndpoint -PresentOnly | Where-Object Status -eq 'OK')
$media = @(Get-PnpDevice -Class MEDIA -PresentOnly | Where-Object Status -eq 'OK')
if($media.Count -eq 0){ KO "Nessun controller audio (classe MEDIA) attivo"; Add-Issue 3 'Audio' 'Nessun controller audio attivo: driver assente o disabilitato' 'Gestione dispositivi → Controller audio; opzione [1]/2' }
elseif($ep.Count -eq 0){ KO "Controller audio ok ma NESSUN endpoint (nessun dispositivo di riproduzione/registrazione)"; Add-Issue 3 'Audio' 'Controller presente ma nessun endpoint audio: tipico di AudioEndpointBuilder bloccato o driver parzialmente caricato' 'Opzione [1]/1 riavvio servizi, poi [1]/2' }
else { OK "$($media.Count) controller audio, $($ep.Count) endpoint attivi" }
$audioEv = @(Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='Microsoft-Windows-Audio';Level=1,2,3;StartTime=$since14})
if($audioEv.Count){ WA "$($audioEv.Count) eventi del servizio Audio in 14 gg"; Add-Issue 1 'Audio' "$($audioEv.Count) warning/errori del servizio Audio" 'Opzione [1]' }

# ---------------------------------------------------------------- 8. RETE
T "Rete"
$gw = (Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Sort-Object RouteMetric | Select-Object -First 1).NextHop
if(-not $gw){ KO "Nessun gateway predefinito"; Add-Issue 3 'Rete' 'Nessun gateway: il PC non ha una rotta verso Internet' 'Cavo/Wi-Fi/router; poi opzione [8]/2' }
elseif(Test-Connection $gw -Count 1 -Quiet){ OK "Gateway $gw raggiungibile" }
else { WA "Gateway $gw non risponde al ping (può essere normale se il router blocca ICMP)" }
$dnsOk = $null; try { $dnsOk = [Net.Dns]::GetHostAddresses('www.microsoft.com') } catch {}
if($dnsOk){ OK "Risoluzione DNS funzionante" } else { KO "Risoluzione DNS FALLITA"; Add-Issue 3 'Rete' 'Il DNS non risolve: browser, Update e Store falliscono tutti' 'Opzione [8]/1 flush, poi [8]/2; verifica DNS del router o prova 1.1.1.1' }
$inet = Test-NetConnection 1.1.1.1 -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue
if($inet){ OK "Internet raggiungibile (1.1.1.1:443)" } else { KO "Internet NON raggiungibile"; Add-Issue 3 'Rete' 'Nessuna connessione TCP verso Internet' 'Opzione [8]/2; controlla firewall/VPN/proxy' }
$proxy = (netsh winhttp show proxy | Out-String)
if($proxy -notmatch 'Direct access|Accesso diretto'){ WA "Proxy WinHTTP configurato"; Add-Issue 2 'Rete' 'Un proxy WinHTTP è impostato: Update/Store/Defender passano di lì e falliscono se è morto' 'Opzione [4] include "netsh winhttp reset proxy"' } else { OK "Nessun proxy WinHTTP" }
$vpn = @(Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.InterfaceDescription -match 'VPN|TAP|Wintun|WireGuard|Tailscale|ZeroTier' })
if($vpn.Count){ WA ("Adattatori VPN attivi: " + (($vpn | ForEach-Object Name) -join ', ') + " — possono deviare DNS/Update") }

# ---------------------------------------------------------------- 9. ORARIO
T "Orologio di sistema"
$w = (w32tm /query /status 2>&1 | Out-String)
if($w -match '(?:Phase Offset|Offset di fase)\s*:\s*(-?[\d\.,]+)s'){
  $off = [math]::Abs([double]($matches[1] -replace ',','.'))
  if($off -gt 60){ KO "Orologio sfasato di $off s"; Add-Issue 3 'Sistema' "Orologio sfasato di $off secondi: rompe TLS, quindi Update, Store, Defender e login Microsoft" 'w32tm /resync (o net start w32time && w32tm /resync)' } else { OK "Orologio sincronizzato (offset $off s)" }
} else { WA "Servizio Ora di Windows non risponde"; Add-Issue 1 'Sistema' 'W32Time non attivo: l''orologio deriva nel tempo' 'net start w32time && w32tm /resync' }

# ---------------------------------------------------------------- 10. RISORSE
T "Carico attuale e file temporanei"
$cpu = [int](Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average
$ramPct = [math]::Round((1 - $os.FreePhysicalMemory / $os.TotalVisibleMemorySize) * 100)
Out ("    CPU $cpu%  ·  RAM $ramPct% (" + [math]::Round($os.TotalVisibleMemorySize/1MB,1) + " GB totali)") 'Gray'
if($ramPct -gt 90){ WA "RAM quasi esaurita"; Add-Issue 2 'Risorse' "RAM al $ramPct%" 'Chiudi app; se è dwm/explorer/SearchHost a crescere, opzione [5]/3' }
$topP = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 4
Out ("    Top RAM: " + (($topP | ForEach-Object { "$($_.Name) $([int]($_.WorkingSet64/1MB))MB" }) -join ', ')) 'Gray'
$tmpGB = [math]::Round(((Get-ChildItem $env:TEMP -Recurse -File | Measure-Object Length -Sum).Sum / 1GB), 2)
if($tmpGB -gt 2){ WA "TEMP utente pesa $tmpGB GB"; Add-Issue 1 'Disco' "TEMP a $tmpGB GB" 'Opzione [9]' } else { OK "TEMP utente: $tmpGB GB" }
$icon = @(Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\iconcache_*.db","$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db")
$iconMB = [int](($icon | Measure-Object Length -Sum).Sum / 1MB)
if($iconMB -gt 1500){ WA "Cache icone/miniature: $iconMB MB (gonfia)"; Add-Issue 1 'Shell' "Cache icone+miniature a $iconMB MB: quando è così grossa le icone iniziano a sballare" 'Opzione [2]/2' } else { OK "Cache icone/miniature: $iconMB MB" }

# ---------------------------------------------------------------- 11. INSIDER
T "Insider"
$cv  = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$ins = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\WindowsSelfHost\UI\Selection'
Out ("    Build $($cv.CurrentBuild).$($cv.UBR) — $($cv.BuildLabEx)") 'Gray'
if($ins){
  Out ("    Canale: $($ins.UIRing) / $($ins.UIContentType)") 'Gray'
  if($ins.UIRing -match 'Canary|Dev'){ WA "Canale $($ins.UIRing): instabilità e regressioni sono previste"; Add-Issue 1 'Insider' "Sei su $($ins.UIRing) (build $($cv.CurrentBuild))" 'Prima di riparare, confronta il sintomo con i Known Issues del flight (Flight Hub / blog Windows Insider): se è noto, riparare non serve.' }
} else { OK "Non iscritto al programma Insider (build stabile)" }
$flt = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\WindowsSelfHost\Applicability'
if($flt -and $flt.EnablePreviewBuilds -eq 0 -and $ins){ WA "Iscrizione Insider presente ma EnablePreviewBuilds=0: i flight non arrivano"; Add-Issue 1 'Insider' 'Flag EnablePreviewBuilds a 0' 'Impostazioni → Windows Update → Programma Insider, ri-conferma il canale' }

# ---------------------------------------------------------------- VERDETTO
Out ''
Out '  ╔══════════════════════════════════════════════════════════════════════════╗' 'Cyan'
Out '  ║  VERDETTO                                                                ║' 'Cyan'
Out '  ╚══════════════════════════════════════════════════════════════════════════╝' 'Cyan'
if($script:issues.Count -eq 0){
  OK "Nessun problema rilevato: se qualcosa non va, è probabilmente un'app specifica o un bug del flight, non il sistema."
} else {
  $lbl = @{3='CRITICO';2='ATTENZIONE';1='NOTA'}; $col = @{3='Red';2='DarkYellow';1='Gray'}
  foreach($i in ($script:issues | Sort-Object Sev -Descending)){
    Out ("  [" + $lbl[$i.Sev] + "] " + $i.Area + " — " + $i.Msg) $col[$i.Sev]
    Out ("        → " + $i.Fix) 'Cyan'
  }
  Out ''
  $areas = $script:issues | Where-Object Sev -ge 2 | Group-Object Area | Sort-Object Count -Descending
  if($areas){ Out ("  Aree più colpite: " + (($areas | ForEach-Object { "$($_.Name) ($($_.Count))" }) -join ', ')) 'White' }
  $hw = $script:issues | Where-Object Area -eq 'Hardware'
  if($hw){ Out '  ► Ci sono segnali HARDWARE: le riparazioni software sopra non risolvono la causa. Parti da lì.' 'Red' }
  elseif(($script:issues | Where-Object Area -eq 'Sistema' | Where-Object Msg -match 'DISM|SFC').Count){ Out '  ► Component store danneggiato: fai PRIMA [7]/3, poi le altre riparazioni. Ripararle prima è tempo perso.' 'Yellow' }
  elseif(($script:issues | Where-Object Msg -match 'Riavvio in sospeso').Count){ Out '  ► Riavvia prima di qualsiasi altra cosa: metà delle voci sopra potrebbe sparire da sola.' 'Yellow' }
}
Out ''
Out ("  Fine: " + (Get-Date -Format 'HH:mm:ss')) 'DarkGray'
if($env:GF_REPORT){ $script:lines | Out-File -FilePath $env:GF_REPORT -Encoding UTF8; Out ("  Report salvato: " + $env:GF_REPORT) 'DarkGray' }
