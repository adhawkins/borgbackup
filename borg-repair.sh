#!/bin/sh

. /root/.borgbackup/borg-settings.sh

borg check --repair -v $BORG_REPO

