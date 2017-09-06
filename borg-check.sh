#!/bin/sh

. /root/.borgbackup/borg-settings.sh

borg check $BORG_REPO

