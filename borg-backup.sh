#!/bin/sh

. /root/.borgbackup/borg-settings.sh

borg --version
echo

echo
echo "Backing up..."
echo

if [ -f /root/.borgbackup/excludes ]
then
	EXCLUDE="--exclude-from /root/.borgbackup/excludes"
fi

borg create -v --stats --exclude-caches \
		$EXCLUDE \
    $BORG_REPO::'{now:%Y-%m-%d-%H-%M-%S}' \
		$DIRECTORIES

echo
echo "Pruning..."
echo

borg prune -v --list $BORG_REPO \
    --keep-hourly=$HOURLY --keep-daily=$DAILY --keep-weekly=$WEEKLY --keep-monthly=$MONTHLY

echo
echo "Complete - quota..."
echo

ssh $SSH_ROOT quota
