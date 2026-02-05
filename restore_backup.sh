#!/bin/bash

BACKUP_DIR="/mnt/backup_drive" 
DATE_RESTORE=$1 

if [ -z "$DATE_RESTORE" ]; then
    echo "Error: Please specify the date in YYYY-MM-DD format."
    exit 1
fi

echo "Searching for backup chain for $DATE_RESTORE"

TEMP_FULL_DATES="/tmp/full_dates.txt"
> "$TEMP_FULL_DATES" 

for file_path in $BACKUP_DIR/full_backup_*.tar.gz; do
    if [ -f "$file_path" ]; then
        
        FILENAME=$(basename "$file_path")
        DATE_PART=${FILENAME:12:10} 
        
        if [[ "$DATE_PART" < "$DATE_RESTORE" ]] || [[ "$DATE_PART" == "$DATE_RESTORE" ]]; then
            echo "$DATE_PART" >> "$TEMP_FULL_DATES"
        fi
    fi
done


LAST_FULL_DATE=$(cat "$TEMP_FULL_DATES" | sort | tail -n 1)
rm -f "$TEMP_FULL_DATES" 

if [ -z "$LAST_FULL_DATE" ]; then
    echo "FATAL: No full base backup found before or on $DATE_RESTORE."
    exit 1
fi

FULL_ARCHIVE="$BACKUP_DIR/full_backup_${LAST_FULL_DATE}.tar.gz"
echo "Found base full backup: $LAST_FULL_DATE"

INCREMENTAL_LIST=""
for inc_path in $BACKUP_DIR/inc_backup_*.tar.gz; do
    if [ -f "$inc_path" ]; then
        INC_FILENAME=$(basename "$inc_path")
        INC_DATE_PART=${INC_FILENAME:11:10} # inc_backup_YYYY-MM-DD.tar.gz

        # INC_DATE > LAST_FULL_DATE І INC_DATE <= DATE_RESTORE
        if [[ "$INC_DATE_PART" > "$LAST_FULL_DATE" ]] && [[ "$INC_DATE_PART" < "$DATE_RESTORE" ]] || [[ "$INC_DATE_PART" == "$DATE_RESTORE" ]]; then
            INCREMENTAL_LIST="$INCREMENTAL_LIST $inc_path"
        fi
    fi
done

SORTED_INCREMENTALS=$(echo "$INCREMENTAL_LIST" | tr ' ' '\n' | sort)

cd /

echo "Restoring base: $LAST_FULL_DATE"
tar -xzvpf "$FULL_ARCHIVE" -G -P

echo "Applying increments..."
if [ -n "$SORTED_INCREMENTALS" ]; then
    for INC_FILE in $SORTED_INCREMENTALS; do
        INC_DATE_APPLY=$(basename "$INC_FILE" | cut -d '_' -f 3 | cut -d '.' -f 1)
        echo "   -> Applying $INC_DATE_APPLY"
        tar -xzvpf "$INC_FILE" -G -P
    done
else
    echo "No increments to apply."
fi

echo "Restore to $DATE_RESTORE finished!"
