#!/bin/bash

. /root/.borgbackup/borg-settings.sh

DIR="$(dirname "$(test -L "$0" && readlink -f "$0" || echo "$0")")"
. ${DIR}/borg-complete-settings.sh

if /usr/local/sbin/borg list $BORG_REPO 2>/dev/null >/dev/null
then
	LASTDATE=`/usr/local/sbin/borg list $BORG_REPO 2>/dev/null | tail -1 | awk '{print $1'}`

	YEAR=${LASTDATE:0:4}
	MONTH=${LASTDATE:5:2}
	DAY=${LASTDATE:8:2}
	HOUR=${LASTDATE:11:2}
	MIN=${LASTDATE:14:2}
	SEC=${LASTDATE:17:2}

	EPOCH=`date --date="$YEAR-$MONTH-$DAY $HOUR:$MIN:$SEC" +%s`
	EPOCHNOW=`date +%s`

	DIFF=`expr $EPOCHNOW - $EPOCH`

	if [ $DIFF -gt $MONITOR_THRESHOLD ]
	then
		echo "Last backup on `hostname` was at $YEAR-$MONTH-$DAY $HOUR:$MIN:$SEC" | Mail -r "root@$(hostname -f)" -s "*** Backup warning for `hostname` ***" $MAILNAME
	fi
else
	echo "Error retrieving borg backups on `hostname`" | Mail -r "root@$(hostname -f)" -s "*** Backup warning for `hostname` ***" $MAILNAME
fi
