#!/bin/sh

. ~/.borgbackup/borg-settings.sh

borg init $BORG_REPO
