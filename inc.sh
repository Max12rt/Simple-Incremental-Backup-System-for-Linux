#!/bin/bash

SRC="/home/test/project_data"
DEST="/mnt/backup_drive"
SNAP="$DEST/metadata/snap.file"
DATE=$(date +%Y-%m-%d)
LOG="/var/log/backup.log"

echo "Starting INCREMENTAL backup: $DATE" >> $LOG

tar -czvpf "$DEST/inc_backup_$DATE.tar.gz" -g $SNAP $SRC

echo "INCREMENTAL backup finished: $DATE" >> $LOG