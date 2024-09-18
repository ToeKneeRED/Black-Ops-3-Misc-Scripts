@echo off
cls
title Toe Knee UEM t7 bat

set t7Path=""
set steamPath=""

if "%~1"=="" (
	echo Searching for t7patch...
	for %%i in ("%~dp0t7patch_*.exe") do (
		set t7Path="%%~i"
		goto :T7_FOUND
	)
	
	if %t7Path%=="" (
        goto T7_NOT_FOUND
    )
) else (
		set t7Path="%~1"
		if t7Path=="" goto T7_NOT_FOUND
)

:T7_FOUND
echo t7patch path: %t7Path%

:T7START
if t7Path=="" ( 
	goto T7_NOT_FOUND
)
start "" %t7Path%
timeout 1 >nul

echo Searching for steam...
for /f "tokens=1,3*" %%E in ('reg query "HKEY_CURRENT_USER\Software\Valve\Steam"') do (
    if %%E==SteamExe (
		if "%%G"=="" (
			set steamPath="%%F"
		) else (
			set steamPath="%%F %%G"
		)
	)
)

echo Steam path: %steamPath%

if %steamPath%=="" ( 
	goto STEAM_NOT_FOUND
) else  (
 	%steamPath% -applaunch 311210 +set fs_game 2942053577
)
goto END

:T7_NOT_FOUND
echo t7patch executable was not found
pause
goto END

:STEAM_NOT_FOUND
echo steam executable was not found
pause
goto END

:END
exit