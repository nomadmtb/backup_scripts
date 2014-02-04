#!/bin/bash
terminal_notifier='/Users/kyle/my_scripts/terminal-notifier.app/Contents/MacOS/terminal-notifier'

# Adjusting window size to 15(height) and 41(width)
echo -e "\033[8;18;41t"

# Check to see if server is up
ssh -o ConnectTimeout=5 mtb 'echo hi'

# If server-test returns an error
if [ $? -gt "0" ]
then
	# Error has occurred. Make a notification.
	$terminal_notifier -message "Server is down. Exiting." -title "Backup ERROR" > /dev/null
else
	# Execute backup.
	/Users/kyle/my_scripts/backup.sh

	if [ $? -eq "0" ]
	then
		$terminal_notifier -message "Data has been successfully backed up to the server" -title "Backup Complete" > /dev/null
	else
		$terminal_notifier -message "Data has NOT been successfully backed up to the server" -title "Backup ERROR" > /dev/null
	fi
fi
