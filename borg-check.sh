#!/bin/sh

. /root/.borgbackup/borg-settings.sh

borg check -v $BORG_REPO

