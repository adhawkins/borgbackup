#!/bin/bash

. /root/.borgbackup/borg-settings.sh

/usr/local/sbin/borg --version
echo

echo
echo "Backing up..."
echo

if [ -f /root/.borgbackup/excludes ]
then
	EXCLUDE="--exclude-from /root/.borgbackup/excludes"
fi

/usr/local/sbin/borg create -v --stats --exclude-caches \
		$EXCLUDE \
    $BORG_REPO::'{now:%Y-%m-%d-%H-%M-%S}' \
		"${DIRECTORIES[@]}" # expand the array, quoting each element

echo
echo "Pruning..."
echo

/usr/local/sbin/borg prune -v --list $BORG_REPO \
    --keep-hourly=$HOURLY --keep-daily=$DAILY --keep-weekly=$WEEKLY --keep-monthly=$MONTHLY

echo
echo "Complete - quota..."
echo

if [ -z "$SSH_ROOT" ]
then
	echo "No SSH_ROOT, quota unavailable"
else
	ssh $SSH_ROOT quota
fi
