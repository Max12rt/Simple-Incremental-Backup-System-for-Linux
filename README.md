# Automated Incremental Backup System

This project provides a robust solution for automated backups on Linux using `tar` with incremental snapshot tracking. It includes scripts for full and incremental backups, automated cleanup, and a point-in-time restoration tool.

---

## 📂 Project Structure

* **`full.sh`**: Performs a full system backup and rotates old archives.
* **`inc.sh`**: Performs incremental backups based on the last snapshot.
* **`restore_backup.sh`**: Restores data to a specific date by reassembling the backup chain.
* **`startConfiguration.sh`**: Initializes the environment, project directories, and mock git repositories.
* **`cron.sh`**: Contains the schedule configuration for automated execution.

---

## 🛠 Setup & Installation

### 1. Initialize Environment
Run the configuration script to create the necessary directory structure and sample data:

chmod +x *.sh
./startConfiguration.sh
The script creates source directories in /home/test/project_data and metadata folders in /mnt/backup_drive/metadata.

2. Configure Automation (Cron)
To automate the backups, add the contents of cron.sh to your crontab (crontab -e):

Bash

# Full backup every Sunday at 02:00
0 2 * * 0 /home/test/backup_scripts/full.sh

# Incremental backup Monday through Saturday at 02:00
0 2 * * 1-6 /home/test/backup_scripts/inc.sh
**

📉 Backup Logic
Full Backup (full.sh)
Creates a complete archive of the source directory.

Resets the snap.file to ensure a fresh baseline.

Retention: Automatically deletes any backup archives (full or incremental) older than 30 days to save space.

Incremental Backup (inc.sh)
Only archives files that have changed or been created since the last backup.

Uses the snap.file metadata to track file system changes.

⏪ Restoration Process
The restore_backup.sh script automates the complex task of manual restoration. It identifies the correct "Base Full Backup" and then sequentially applies all "Incremental Patches" up to your desired date.

Usage:

Bash

sudo ./restore_backup.sh YYYY-MM-DD
Example:

Bash

sudo ./restore_backup.sh 2026-02-05
Note: The script restores files to the root level while preserving original permissions.

📋 Monitoring
All backup activities, warnings, and completion timestamps are logged for auditing:

Log Path: /var/log/backup.log

⚠️ Requirements
Permissions: Scripts must be executable (chmod +x).

Storage: The backup drive must be mounted at /mnt/backup_drive.

User: Root or sudo privileges are recommended for restoration to maintain file ownership.
