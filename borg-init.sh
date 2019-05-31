#!/bin/bash

. /root/.borgbackup/borg-settings.sh

/usr/local/sbin/borg init -e repokey $BORG_REPO
