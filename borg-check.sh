#!/bin/bash

. /root/.borgbackup/borg-settings.sh

/usr/local/sbin/borg check -v $BORG_REPO
