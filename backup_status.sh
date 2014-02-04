#!/bin/bash

# Obtaining the date on the local system.
current_date=$(date +%m_%d_%Y)

# Attempting to connect to the server to see if it's up and available, and obtain the latest update time.
current_backup=$(ssh -o ConnectTimeout=3 -q mtb 'ls -t ~/backups/macbookpro/archives | cut -f1 | cut -d\'.' -f1 | head -1')

# Capturing the return value from the above command. Did the server recieve the message? Did the connection occur?
ssh_status="$?"

# If the status variable did not return 0 ---> Print error message.
if [ ! "$ssh_status" -eq "0" ]
then
	echo "Backup Server Unavailable"
	exit 1
else
	# Print backup status.
	if [ "$current_date" != "$current_backup" ]
	then
		echo "Backups NOT Current: Latest on $current_backup"
	else
		echo "Backups ARE Current: Latest on $current_backup"
	fi
fi
