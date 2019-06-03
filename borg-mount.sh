#!/bin/bash

. /root/.borgbackup/borg-settings.sh

DIR="$(dirname "$(test -L "$0" && readlink -f "$0" || echo "$0")")"
. ${DIR}/borg-complete-settings.sh

if [ -n "$1" -a -n "$2" -a -d "$2" ]
then
	/usr/local/sbin/borg mount $BORG_REPO::$1 $2
	echo "$1 mounted on $2"
	echo "Use 'umount $2' when finished"
else
	echo "Usage: $0 archive mountpoint"
	echo
	echo "mountpoint must be a directory"
fi
