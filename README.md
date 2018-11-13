# ServerSync Updater


This batch script allows a client to automatically make sure their version of ServerSync.  This version is hard coded for my server, but maybe down the road I'll make it more variable based to allow for better ease of use.

Other tools used:
Npocmaka's winhttpjs jscript system (https://github.com/npocmaka/batch.scripts/blob/master/hybrids/jscript/winhttpjs.bat) Used under MIT license (different than this script's AGPL3)

Server requirements:
A web server with two files added somewhere publically accessible.  One is a text file with the simple name of the current ServerSync jar file.  The other is the jar file itself.  This jar file needs to be the same one that is being used on the server hosting the minecraft mods.

Client requirements:
In the root of the Minecraft instance put this batch file and Npocmaka's winhttpjs.bat.  Also from that root make /config/serversync/serversync-client.cfg (putting the specific connection info for your server into that config)

Process:
The scripts works in three phases
1) Look for, and copy the file name of any existing ServerSync jar file.  Then query the web server to find out the name of the proper version (it's currently hardcoded to https://puddle.zone/minecraft/sslatest.txt)
2) Compare the local copy to the server version.  If they match, skip to the end and start running ServerSync in progress-only mode
3) If they don't match, download the correct version, delete the old version, and then start ServerSync in progress-only mode

TO-DO:
- Convert more of the script to variable based to make it more customizable
- Create a Linux Bash version of the script.  A Linux version may not require Winhttpjs because of wget and/or curl
- Maybe make an OS agnostic version (one that can identify the OS and script with the proper syntax)
- ...
- ...
- ...
- Mac version?