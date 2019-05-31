#!/bin/bash

. /root/.borgbackup/borg-settings.sh

DIR="$(dirname "$(test -L "$0" && readlink -f "$0" || echo "$0")")"
$DIR/borg-backup.sh 2>&1 | Mail -s "`hostname -s` Borg backup report" $MAILNAME
