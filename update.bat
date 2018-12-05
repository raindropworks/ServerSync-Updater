@echo off
rem ServerSync-Updater v 2.0.1
rem Created by Heather-Lynne Van Wilde under the GNU Affero General Public License v3.0 1 Dec 2018
rem https://github.com/minakitty/ServerSync-Updater

rem Set host and public_files_dir to match a publically accessible web server that hosts the 'bootstrap' files.  Please refer to https://github.com/minakitty/ServerSync-Updater/blob/master/Installation%20and%20use.txt for documentation on the directory structure.
set host=https://puddle.zone
set public_files_dir=minecraft

rem Set host and port information for ServerSync of the Minecraft server here.  If you don't wish to use the live functions of this script, then change ss_live_scan to False.  DO NOT use http or https in the sshost value!
set ss_live_scan=True
set sshost=puddle.zone
set ssport=38067

rem ========================================================
rem Any code that you want run before running the updater
rem should go here, i.e. clean-up scripts
rem ========================================================
firstrun.bat
del firstrun.bat

rem ========================================================
rem Edit values below this line at your own risk
rem ========================================================

echo Checking for latest version of ServerSync software

rem Get client serversync version
for %%f in (serversync*.jar) do (SET client_build=%%~nxf)

rem Fetch serversync version from host
call winhttpjs.bat %host%/%public_files_dir%/sslatest.txt -saveTo sslatest.txt > log.tmp

rem check to make sure got HTTP 200 (OK)
>nul find "200 OK" log.tmp && (
	rem File downloaded fine.  Continuing.
	del log.tmp
) || (
	del log.tmp
	del sslatest.txt
	echo ************
	echo FATAL ERROR: The pointer for the current version of ServerSync is missing.  Please notify your modpack manager.
	echo ************
	pause
	exit /b
)


set /p server_build=<sslatest.txt

echo Current version %client_build%
echo Server version %server_build%

if "%client_build%" == "%server_build%" (
	echo Version current.
)
if not "%client_build%" == "%server_build%" (
	echo ServerSync version mismatch.  Downloading current version from the server.
	call winhttpjs.bat %host%/%public_files_dir%/%server_build% -saveTo %server_build% > log.tmp

	rem check to make sure got HTTP 200 (OK)
	>nul find "200 OK" log.tmp && (
		rem File downloaded fine.  Continuing.
		del log.tmp
	) || (
		del log.tmp
		del %server_build%
		echo ************
		echo FATAL ERROR: The URI referenced by sslatest.txt is missing. Please notify your modpack manager to make sure the file is available and sslatext.txt is pointing it it.
		echo ************
		pause
		exit /b
	)

	echo Download complete.  Removing old version.
	del %client_build%
)

rem Checking for SS config
if not exist config\serversync mkdir config\serversync
if not exist config\serversync\serversync-client.cfg (
	echo Configuration file missing.  Attempting to download from server.
	call winhttpjs.bat %host%/%public_files_dir%/serversync-client.cfg -saveTo config\serversync\serversync-client.cfg > log.tmp
	rem check to make sure got HTTP 200 (OK)
	>nul find "200 OK" log.tmp &&(
		rem File downloaded fine.  Continuing.
		del log.tmp
	) || (
		del log.tmp
		del config\serversync\serversync-client.cfg
		echo ************
		echo FATAL ERROR: The base configuration file is missing.  Please notify your modpack manager to make sure the file is available.
		echo ************
		pause
		exit /b
	)
)

rem beginning live scan
if %ss_live_scan% == True (
	if not exist tcping.exe (
		echo TCPing missing.  Attempting to download.
		call winhttpjs.bat https://download.elifulkerson.com//files/tcping/0.39/tcping.exe -saveTo tcping.exe > log.tmp
		rem check to make sure got HTTP 200 (OK)
		>nul find "200 OK" log.tmp &&(
			echo TCPing downloaded.
			del log.tmp
		) || (
			del log.tmp
			echo ************
			echo FATAL ERROR: Was not able to download TCPing.  Please try again later or go to https://elifulkerson.com/projects/tcping.php and attempt manual download.
			echo ************
			pause
			exit /b
		)
	)
	echo Checking to see if server is available
	tcping.exe -n 1 %sshost% %ssport% > log.tmp
	rem check to see if port is open
	>nul find "Port is open" log.tmp &&(
		echo Server appears to be live.
		del log.tmp
	) || (
		del log.tmp
		echo ************
		echo FATAL ERROR: Was not able to get a response from the update server.  If the problem does not resolve in a few minutes, check with your server admin to make sure the world didn't crash.
		echo ************
		pause
		exit /b
	)
)
if NOT %ss_live_scan% == True echo Live Scan disabled

echo Launching ServerSync.
java -jar %server_build% progress-only