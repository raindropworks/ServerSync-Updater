@echo off

set host=https://puddle.zone
set public_files_dir=minecraft

echo Checking for latest version of ServerSync software

rem Get client serversync version
for %%f in (serversync*.jar) do (SET client_build=%%~nxf)

rem Fetch serversync version from host
call winhttpjs.bat %host%/%public_files_dir%/sslatest.txt -saveTo sslatest.txt
set /p server_build=<sslatest.txt

echo Current version %client_build%
echo Server version %server_build%

if "%client_build%" == "%server_build%" (
	echo Version current.
)
if not "%client_build%" == "%server_build%" (
	echo ServerSync version mismatch.  Downloading current version from the server.
	call winhttpjs.bat %host%/%public_files_dir%/%server_build% -saveTo %server_build%
	echo Download complete.  Removing old version.
	del %client_build%
)

echo Launching ServerSync.
java -jar %server_build% progress-only