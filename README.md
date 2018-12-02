# ServerSync Updater


This batch script allows a client to automatically make sure their version of ServerSync matches the server.  This version is hard coded for my server, but maybe down the road I'll make it more variable based to allow for better ease of use.

Other tools used:
Npocmaka's winhttpjs jscript system (https://github.com/npocmaka/batch.scripts/blob/master/hybrids/jscript/winhttpjs.bat) Used under MIT license (different than this script's Affero GPL)
TCPing from Eli Fulkerson (https://elifulkerson.com/projects/tcping.php) ... I couldn't pin down the license yet, but most likely a GPL (also different than this script's Affero GPL)

For configuration, check the 'Installation and use.txt' file

Usage:
In MultiMC, under Pre-launch command, put "#INST_MC_DIR/update.bat" (quotes are necessary to prevent crashes with directory structures with spaces in them)
In Twitch and likely most other launchers, since there's no pre-launch option, just double click the 'update.bat' file from the Minecraft root before starting the client

In case of errors:
In MultiMC, if there's a error, it's usually a missing file somewhere else, and the script will tell you in the console window.  You'll have to use the 'Kill' button in the MultiMC instance to close the script
In other launchers, the command prompt will stay open with the error information until the user presses a key to close the script.

How it works:
The does a number of things
1) Look for, and copy the file name of any existing ServerSync jar file as well as a configuration file.  Then query the web server to find out the name of the proper version 
2) Compare the local copy to the server version and update if needed
3) Download and use TCping if the Live Scan option is enabled to make sure the server is ready before launching ServerSync
4) Start ServerSync and update the files on the client to match the server

TO-DO:
- Convert more of the script to variable based to make it more customizable - done
- Seperate version allowing port check of update server before launching (looking at using https://elifulkerson.com/projects/tcping.php ) - done
- Create a Linux Bash version of the script.  A Linux version may not require Winhttpjs because of wget and/or curl
- Maybe make an OS agnostic version (one that can identify the OS and script with the proper syntax)
- ...
- ...
- ...
- Mac version?
