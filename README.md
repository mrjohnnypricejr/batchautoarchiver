# batchautoarchiver
Searches a folder and moves files older than a specified date modified to an Archives folder.

Right click batch file and edit.

Change the values in bold of these lines to match your desired case:

set "sourceFolder=<b>.Projects<\b>" rem Folder to move old files from<\n>
set "archiveFolder=<b>.Archives<\b>" rem Folder to move old files to<\n>
set "cutoffTime=<b>365<\b>" rem Files older than this many days get moved to archiveFolder<\n>
