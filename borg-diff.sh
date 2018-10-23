#!/bin/sh

. /root/.borgbackup/borg-settings.sh

if [ -n "$1" -a -n "$2" ]
then
	/usr/local/sbin/borg diff $BORG_REPO::$1 $2
else
	echo "Usage: $0 archive1 archive2"
fi

