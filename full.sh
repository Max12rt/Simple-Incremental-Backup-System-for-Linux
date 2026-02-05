#!/bin/bash

SRC="/home/test/project_data"
DEST="/mnt/backup_drive"
SNAP="$DEST/metadata/snap.file"
DATE=$(date +%Y-%m-%d)
LOG="/var/log/backup.log"


echo "Starting FULL backup: $DATE" >> $LOG

echo "Removing archives older than 30 days" >> $LOG
find "$DEST" -type f -name "*_backup_*.tar.gz" -mtime +30 -exec rm -f {} \;
find "$DEST" -type f -name "inc_backup_*.tar.gz" -mtime +30 -exec rm -f {} \;

if [ -z "$(find "$DEST" -maxdepth 1 -name 'full_backup_*.tar.gz' -print -quit)" ]; then
    echo "WARNING: No full backup found, but snap file exists. Deleting snap.file to force new full backup." >> $LOG
    rm -f $SNAP
fi

tar -czvpf "$DEST/full_backup_$DATE.tar.gz" -g $SNAP $SRC

echo "FULL backup finished: $DATE" >> $LOG