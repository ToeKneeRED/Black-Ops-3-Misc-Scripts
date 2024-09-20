@echo off
cls
title Toe Knee UEM t7 bat

set t7Path=
set steamPath=""
set argCount=0
set argVec=
set debugMode=

:START
if "%~1"=="" (
	goto T7_SEARCH
) else (
	goto HANDLE_ARGUMENTS
)

:HANDLE_ARGUMENTS
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
   
   if "%%~x"=="-debug" (
	set "debugMode=1"
   ) else (
	set "t7Path=%%~x"
   )
)
if not defined t7Path goto T7_NOT_FOUND
goto T7_SEARCH

:T7_SEARCH
echo Searching for t7patch...
for %%i in ("%~dp0t7patch_*.exe") do (
	set "t7Path=%%~i"
)
if not defined t7Path (
	goto T7_NOT_FOUND
)
goto T7_FOUND

:T7_FOUND
echo t7patch path: %t7Path%

:T7_START
if not defined t7Path ( 
	goto T7_NOT_FOUND
)
start "" "%t7Path%"
timeout 1 >nul
goto STEAM_SEARCH

:T7_NOT_FOUND
echo t7patch executable was not found
pause
goto END

:STEAM_SEARCH
echo Searching for steam...
for /f "tokens=1,3*" %%E in ('reg query "HKEY_CURRENT_USER\Software\Valve\Steam"') do (
    if %%E==SteamExe (
		set "steamPath=%%E"
		REM if "%%G"=="" (
			REM set steamPath="%%F"
		REM ) else (
			REM set steamPath="%%F %%G"
		REM )
		goto STEAM_FOUND
	)
)

:STEAM_FOUND
echo Steam path: %steamPath%

:STEAM_START
if %steamPath%=="" ( 
	goto STEAM_NOT_FOUND
) else  (
	if defined debugMode (
		echo would launch game
		pause
	) else (
		%steamPath% -applaunch 311210 +set fs_game 2942053577
	)
)
goto END

:STEAM_NOT_FOUND
echo steam executable was not found
pause
goto END

:END
exit