#!/bin/sh

. /root/.borgbackup/borg-settings.sh

borg init $BORG_REPO
