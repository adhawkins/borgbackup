#!/bin/bash

. /root/.borgbackup/borg-settings.sh

/usr/local/sbin/borg check --repair -v $BORG_REPO
