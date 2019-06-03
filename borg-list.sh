#!/bin/bash

. /root/.borgbackup/borg-settings.sh

DIR="$(dirname "$(test -L "$0" && readlink -f "$0" || echo "$0")")"
. ${DIR}/borg-complete-settings.sh

if [ -z "$1" ]
then
	/usr/local/sbin/borg list $BORG_REPO
else
	/usr/local/sbin/borg list $BORG_REPO::$1
fi
