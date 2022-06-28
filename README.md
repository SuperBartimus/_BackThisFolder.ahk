# _BackThisFolder.ahk
Simple directory backup script.

This Autohotkey script leverages the use of 7Zip to build simple file/folder backups.
It will date stamp them for history.

Destination location is hardcoded in the script, but the script will backup any folder (and it's subfolders) that it's located in.

Built this script for use in my cloud storage locations (Dropbox, Google Drive, etc) to back them up as I was having problems with corruption.  It keeps 30days of worth of backups for each location and removes those that are older via a Powershell call.
