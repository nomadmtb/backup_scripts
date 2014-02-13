My Backup Scripts
=================

The Files
---------
+ 'backup.sh' -> Shell script that execute on the client. Gathers files, and syncs with remote server.
+ 'rotate_backups.sh' -> Shell script on the server that archives the files, and encrypts with GPG.
+ 'backup_status.sh' -> Shell script that is used with Geektool. Notifies if the files are up-to-date or not.
+ 'backup.command' -> Shell script that execute if clicked on. Lives on my desktop, and it initiates a backup event.
