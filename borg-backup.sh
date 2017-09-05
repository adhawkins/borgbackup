#!/bin/sh

. ~/.borgbackup/borg-settings.sh

echo "Backing up..."
echo

# Backup all of /home and /var/www except a few
# excluded directories
borg create --remote-path borg1 -v --stats \
    $BORG_REPO::'{now:%Y-%m-%d-%H-%M-%S}' \
		$EXCLUDE \
		$DIRECTORIES

echo "Pruning..."
echo

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machine's archives also.
borg prune --remote-path borg1 -v --list $BORG_REPO \
    --keep-hourly=$HOURLY --keep-daily=$DAILY --keep-weekly=$WEEKLY --keep-monthly=$MONTHLY

echo "Complete - quota..."
echo

ssh $SSH_ROOT quota
