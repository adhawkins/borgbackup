#!/bin/bash

. /root/.borgbackup/borg-settings.sh

DIR="$(dirname "$(test -L "$0" && readlink -f "$0" || echo "$0")")"
. "${DIR}/borg-complete-settings.sh"

STAMPFILE="${HOME}/borg-check.timestamp"

OUTPUT=$(
if [ -e "$STAMPFILE" ]
then
	if [ $(find "$STAMPFILE" -mtime +10 2>/dev/null) ]
	then
		echo
		echo "Checking"
		echo

		if "${DIR}/borg-check.sh" 2>&1
		then
			echo
			echo "Repository check successful"
			echo

			touch "$STAMPFILE"
		else
			echo
			echo "*** Repository check failed ***"
			echo
		fi
	fi
else
	touch -d @"$(echo "$(date +%s) - $(shuf -i1-10 -n1) * 86400" | bc)" "$STAMPFILE"

	echo
	echo "Check stamp initialized"
	echo
fi
) 2>&1

if [ -n "$OUTPUT" ]
then
	echo "$OUTPUT" | Mail -s "$(hostname -s) Borg check report" "$MAILNAME"
fi
