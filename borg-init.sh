#!/bin/bash

. /root/.borgbackup/borg-settings.sh

DIR="$(dirname "$(test -L "$0" && readlink -f "$0" || echo "$0")")"
. ${DIR}/borg-complete-settings.sh

/usr/local/sbin/borg init --encryption=repokey-blake2 $BORG_REPO
