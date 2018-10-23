#!/bin/sh

. /root/.borgbackup/borg-settings.sh

if [ -z "$1" ]
then
	/usr/local/sbin/borg list $BORG_REPO
else
	/usr/local/sbin/borg list $BORG_REPO::$1
fi

