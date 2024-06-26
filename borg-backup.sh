#!/bin/bash

. /root/.borgbackup/borg-settings.sh

DIR="$(dirname "$(test -L "$0" && readlink -f "$0" || echo "$0")")"
. ${DIR}/borg-complete-settings.sh

/usr/local/sbin/borg --version
echo

if which xe > /dev/null 2>/dev/null
then
	echo
	echo "Exporting XCP metadata"
	echo

	rm -f /root/pool-database.bak; xe pool-dump-database file-name=/root/pool-database.bak
fi

if which apt-mark >/dev/null 2>/dev/null
then
	echo
	echo "Exporting manual package list"
	echo

	apt-mark showmanual > ~/apt-mark-show-manual.txt
fi

if which dpkg >/dev/null 2>/dev/null
then
	echo
	echo "Exporting dpkg package list"
	echo

	dpkg --get-selections > ~/dpkg-get-selections.txt
fi

echo
echo "Backing up..."
echo

if [ -f /root/.borgbackup/excludes ]
then
	EXCLUDE="--exclude-from /root/.borgbackup/excludes"
fi

if [ -n "$HEALTHCHECKS_BASEURL" -a -n "$HEALTHCHECKS_ID" ]
then
	curl -s "$HEALTHCHECKS_BASEURL/$HEALTHCHECKS_ID/start" >/dev/null
fi

if retry 5 5 /usr/local/sbin/borg create -v --show-rc --stats --exclude-caches \
		--remote-ratelimit $RATELIMIT \
		$EXCLUDE \
		$BORG_REPO::'{now:%Y-%m-%d-%H-%M-%S}' \
		"${DIRECTORIES[@]}" # expand the array, quoting each element
then
	if [ -n "$HEALTHCHECKS_BASEURL" -a -n "$HEALTHCHECKS_ID" ]
	then
		curl -s "$HEALTHCHECKS_BASEURL/$HEALTHCHECKS_ID" > /dev/null
	fi
else
	if [ -n "$HEALTHCHECKS_BASEURL" -a -n "$HEALTHCHECKS_ID" ]
	then
		curl -s "$HEALTHCHECKS_BASEURL/$HEALTHCHECKS_ID/fail" > /dev/null
	fi

	echo "Backup failed"
fi

echo
echo "Pruning..."
echo

if ! retry 5 5 /usr/local/sbin/borg prune -v --show-rc --list $BORG_REPO \
		--keep-hourly=$HOURLY --keep-daily=$DAILY --keep-weekly=$WEEKLY --keep-monthly=$MONTHLY
then
	echo "Prune failed"
fi

echo
echo "Compacting..."
echo

if ! retry 5 5 /usr/local/sbin/borg compact --threshold 1 -v --show-rc $BORG_REPO
then
	echo "Compact failed"
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
