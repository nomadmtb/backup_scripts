#!/bin/bash

#Server GPG key-name, name of the key that belongs to the server.
server_keyname="backup_server"

#GPG key-name of the public key that belogs to the client.
#The server only has the client's PUBLIC KEY. Do not share the private key!
client_keyname="client_key"

# Config Variables
current_date=$(date +"%m_%d_%Y")
source_folder='/home/kyle/backups/macbookpro/Backup_docs'
destination_path='/home/kyle/backups/macbookpro/archives'

# Error Check Function
function error_check
{
	if [ "$1" -gt 0 ]
	then
		echo -e "\t\t \033[47;31;1mFAIL\033[0m"
		exit 1
	else
		echo -e "\t\t \033[38;5;148mComplete\033[39m"
	fi
}

function clean_up
{
	rm $destination_path/$current_date.tgz
}

function check_duplicate
{
	ls 11_20_2013.tgz.g3g > /dev/null 2>&1
	if [ "$?" -eq 0 ]
	then
		echo -n 'Removing Duplicate'
		echo -e "\t\t \033[47;31;1mREMOVED\033[0m"
		rm $destination_path/$current_date.tgz.gpg
	fi
}

# Main

if [ ! -d $source_folder ]
then
	echo "Source Backup Directory: $source_folder Doesn't exist. Exiting."
	exit 1
else
	# Checking for repeat backup. Remove old if necessary
	check_duplicate

	# Creating archive of the source_folder
	echo '...Rotating Remote Backup Files...'

	echo -n 'Archiving the backup'
	tar czf $destination_path/$current_date.tgz -C $source_folder . > /dev/null 2>&1
	error_check $?

	# Encrypting the archive
	echo -n 'Encrypting the backup'
	gpg --batch -q --trust-model always -e -u "$server_keyname" -r "$client_keyname" $destination_path/$current_date.tgz
	error_check $?

	# Clean Up
	echo -n 'Cleaning Up A Bit'
	clean_up
	error_check $?
fi
