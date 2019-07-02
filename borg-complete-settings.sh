retry()
{
	success=1

	if [ "$#" -ge "4" ]
	then
		retries=$1
		delay=$2
		command=$3

		shift 3

		tries=0

		while [ "$tries" -lt "$retries" ]
		do
			$command "$@"

			ret=$?
			echo "$command returns $ret"

			if [ "$ret" -ge "2" ]
			then
				tries=$((tries+1))
				echo "Failed - $ret, $tries attempt(s)"

				if [ "$tries" -lt "$retries" ]
				then
					sleep $delay
				fi
			else
				success=0
				break
			fi

		done
	else
		echo "Usage: func retries delay command args"
	fi

	return $success
}

if [ -n "${BORGBASE_REPO_ID}" ]
then
	export SSH_ROOT="${BORGBASE_REPO_ID}@${BORGBASE_REPO_ID}.repo.borgbase.com"
	export BORG_REPO="${SSH_ROOT}:repo"
	export BORG_REMOTE_PATH="borg"
fi
