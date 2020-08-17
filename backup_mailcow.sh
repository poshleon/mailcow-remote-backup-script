#!/bin/sh
# a simple script to run on Linux or FreeBSD to  ssh in mailcow and grab last backup. i

# This script assumes you have mailcow backup run by mailcow locally on remote mailcow servers
# You could do that by adding a line
# 0 1 * * * root MAILCOW_BACKUP_LOCATION=/opt/backup /opt/mailcow-dockerized/helper-scripts/backup_and_restore.sh backup all --delete-days 60
# to /etc/crontab or cron.daily


# Location to store backups on local server where script is running. i
# Directory must exist, if not create it.
backuplocation=/var/mailcowbackup/

#IP or FQDN of mailcow server
mailcowserver=mail.mydomain.com

#User on remote mailcow server to ssh. User must have generated ssh key which must be installed on mailcow server. User must have read permissions on mailcow backup dir. 
remoteuser=root

#Absolute location of backupdir on remote mailcow server
mailcowbackupdir=/opt/backup

# Get last backup on remote server
lastbackup=$(ssh $remoteuser@$mailcowserver ls -tr $mailcowbackupdir | tail -1 2> /dev/null)


# Test if last backup is not empty string
[ -z "$lastbackup"  ] &&  { echo "Cannot find Last backup, check variables and backup and check if user can log in."; exit 1; } ||
# copy remote backup to local backup
        rsync -av "$remoteuser"@"$mailcowserver":"$mailcowbackupdir"/"$lastbackup" "$backuplocation"

