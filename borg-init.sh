#!/bin/sh

. /root/.borgbackup/borg-settings.sh

borg init -e repokey $BORG_REPO
