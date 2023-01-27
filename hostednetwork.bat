@echo off

:main
echo.
echo.
title Hotspot script v 1.0 @ Bluzsh 

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------   

:options
mode con cols=98 lines=30
echo               -------------------------------------------------------------------------
echo                 This script will create a hotspot for you.
echo                 {*} Your password most be eight characters and,
echo.                {*} Your hotspot name most be one word.
echo                 Use Documentation for the Further Details.
echo               -------------------------------------------------------------------------
echo.
echo                        _________________________________________________________   
echo                      ^|                                                         ^|
echo                      ^|                                                         ^|
echo                      ^|     [A] To Create a Hotspot                             ^|
echo                      ^|                                                         ^|
echo                      ^|     [B] To Turn the Hotspot ON                          ^|
echo                      ^|                                                         ^|
echo                      ^|     [C] To Turn the Hotspot OFF                         ^|
echo                      ^|     _______________________________________________     ^|
echo                      ^|                                                         ^|
echo                      ^|                                                         ^|
echo                      ^|     [D] Documentation                                   ^|
echo                      ^|     [E] Close the program                               ^|
echo                      ^|_________________________________________________________^|
echo.                                                                                
choice /C:ABCDE /N /M ".                     Enter Your Choice [A,B,C,D,E] : "
if errorlevel 5 goto:close
if errorlevel 4 goto:ReadMe
if errorlevel 3 goto:network_stop
if errorlevel 2 goto:network_start
if errorlevel 1 goto:load_function

:======================================================================================================================================================

:load_function
cls
:: loading the hotspot name and password name in variables.
echo.
echo.
set /p name=Type a Name for your Hotspot: 
echo.
echo.
set /p password=Type a Password for your Hotspot: 
cls
netsh wlan set hostednetwork mode=allow ssid="%name%" key="%password%"

echo Processing... 
timeout /t 5 >nul /nobreak
goto options

:network_stop
cls
netsh wlan stop hostednetwork
echo Your hotspot is turning off...
timeout /t 3 >nul /nobreak
pause 
goto options

:network_start
cls 
netsh wlan start hostednetwork
echo Your Hotspot has been start successfully...
timeout /t 5 >nul /nobreak
echo Hotspot Name:
echo.
netsh wlan show hostednetwork | findstr "SSID name"
echo.
echo Hotspot Password:
echo.
netsh wlan show hostednetwork setting=security | findstr "User" 
pause 
goto options

:close
echo Press any key to close the Program...
pause >nul
exit

:ReadMe
con cols=98 lines=30
cls
echo ================================================================================================
echo + {*} A: Allows you to create the hostednetwork (hotspot).                                      ^|
echo + {*} Then in the INPUT below in A, Type the name you want for the hotspot and a password.      ^|
echo + {*} B: After Creating a hotspot, select Option B to 'start' the hotspot.                      ^|
echo + {*} The ssid specifies the name of the hotspot and 'User security key' specifies the Password.^|
echo + {*} C: This option Turns off the hotspot                                                      ^|
echo =================================================================================================
pause 
goto options
::Project complete!!
