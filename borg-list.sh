#!/bin/sh

. ~/.borgbackup/borg-settings.sh

if [ -z "$1" ]
then
	borg list $BORG_REPO
else
	borg list $BORG_REPO::$1
fi

