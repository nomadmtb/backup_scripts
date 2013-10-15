#!/bin/bash

# Config Variables
# Backup_folder is the local folder where you will be temporarily backing
# up the local documents.
backup_folder="/Users/kyle/Backup_docs"

# Server_destination is the destination on the server where your local
# files will get rsync'd to.
server_destination=":~/backups/macbookpro/"

# Username and domain of the server you will be backing up to.
server_host="kyle@domain.com"

# Port that SSH is bound to on the server.
ssh_port="20000"

# Documents to be backed up.
ssh_data="/Users/kyle/.ssh"
bash_profile="/Users/kyle/.bash_profile"
school_documents="/Users/kyle/Documents/csuchico"
programming_docs="/Users/kyle/Documents/programming"
scripts="/Users/kyle/my_scripts"

# Error Check Function
function error_check
{
	if [ "$1" -gt 0 ]
	then
		echo -e "\t\t \033[47;31;1mFAIL\033[0m"
		echo -n 'Cleaning Up A Bit'
		cleanup
		exit 1
	else
		echo -e "\t\t \033[38;5;148mComplete\033[39m"
	fi
}

# Cleanup Function
function cleanup
{
	rm -rf $backup_folder/* 2> /dev/null
	error_check "0" 'Cleaning Up A Bit'
}

# Main

clear

if [ ! -d $backup_folder ]
then
	echo "Local Backup Directory: $backup_folder Doesn't exist. Exiting."
	exit 1
else
	echo '...Backing Up Local Files...'

	# Copying data to local location
	echo -n 'Staging SSH Data'
	cp -r $ssh_data $backup_folder
	error_check $?

	echo -n 'Unhiding SSH Data'
	mv $backup_folder/.ssh $backup_folder/ssh
	error_check $?

	echo -n 'Staging Profile Data'
	cp $bash_profile $backup_folder
	error_check $?

	echo -n 'Unhiding Profile Data'
	mv $backup_folder/.bash_profile $backup_folder/bash_profile
	error_check $?

	echo -n 'Staging School Data'
	cp -r $school_documents $backup_folder
	error_check $?

	echo -n 'Staging Program Data'
	cp -r $programming_docs $backup_folder
	error_check $?

	echo -n 'Staging Script Data'
	cp -r $scripts $backup_folder
	error_check $?

	# Syncing with the remote directory
	echo -n 'Sending Backup Data'
	rsync -avz --quiet --delete -e "ssh -p $ssh_port" $backup_folder $server_host$server_destination 2> /dev/null
	error_check $?

	echo -n 'Cleaning Up A Bit'
	cleanup

	echo ' '

	# Executing the server-script
	ssh $server_host "-p $ssh_port" 'rotate_backups.sh'
	exit 0
fi

# End-Main
