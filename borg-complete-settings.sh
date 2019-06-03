if [ -n "${BORGBASE_REPO_ID}" ]
then
	export SSH_ROOT="${BORGBASE_REPO_ID}@${BORGBASE_REPO_ID}.repo.borgbase.com"
	export BORG_REPO="${SSH_ROOT}:repo"
	export BORG_REMOTE_PATH="borg"
fi
