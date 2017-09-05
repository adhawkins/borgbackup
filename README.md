# borgbackup

A set of scripts to manage borg backups

Copy borg-settings.sh-example to ~/.borgbackup/borg-settings.sh and make appropriate modifications

Included utilities
------------------

* borg-init.sh - Initialise an empty borg repository
* borg-backup.sh - Run a borg backup
* borg-backup-cron.sh - Cron job to run a borg backup and email the results
* borg-lists.sh - List the contents of a borg repository or archive
* borg-mount.sh - Mount a borg archive in a local directory
