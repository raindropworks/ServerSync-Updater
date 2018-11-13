@echo off
echo Checking for latest version of ServerSync software
for %%f in (serversync*.jar) do (SET serversync=%%~nxf)
call winhttpjs.bat https://puddle.zone/minecraft/sslatest.txt -saveTo sslatest.txt
set /p Build=<sslatest.txt
echo Current version %serversync%
echo Server version %Build%
if "%serversync%" == "%Build%" (
	echo Version current.  Launching ServerSync.
)
if not "%serversync%" == "%Build%" (
	echo ServerSync version mismatch.  Downloading current version from the server.
	call winhttpjs.bat https://puddle.zone/minecraft/%Build% -saveTo %Build%
	echo Download complete.  Removing old version.
	del %serversync%
	echo Launching ServerSync.
)
java -jar %Build% progress-only