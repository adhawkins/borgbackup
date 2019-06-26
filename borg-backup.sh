#!/bin/bash

. /root/.borgbackup/borg-settings.sh

DIR="$(dirname "$(test -L "$0" && readlink -f "$0" || echo "$0")")"
. ${DIR}/borg-complete-settings.sh

/usr/local/sbin/borg --version
echo

echo
echo "Backing up..."
echo

if [ -f /root/.borgbackup/excludes ]
then
	EXCLUDE="--exclude-from /root/.borgbackup/excludes"
fi

if ! retry 5 5 /usr/local/sbin/borg create -v --stats --exclude-caches \
		$EXCLUDE \
    $BORG_REPO::'{now:%Y-%m-%d-%H-%M-%S}' \
		"${DIRECTORIES[@]}" # expand the array, quoting each element
then
	echo "Backup failed"
fi

echo
echo "Pruning..."
echo

if ! retry 5 5 /usr/local/sbin/borg prune -v --list $BORG_REPO \
    --keep-hourly=$HOURLY --keep-daily=$DAILY --keep-weekly=$WEEKLY --keep-monthly=$MONTHLY
then
	echo "Prune failed"
fi

echo
echo "Complete - quota..."
echo

if [ -n "${BORGBASE_REPO_ID}" ]
then
	echo "Using borgbase, quota currently unavailable"
else
	ssh $SSH_ROOT quota
fi
