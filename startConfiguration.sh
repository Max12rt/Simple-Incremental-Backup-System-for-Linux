#!/bin/bash
mkdir -p /home/test/project_data

mkdir -p /home/test/project_data/backend_repo
cd /home/test/project_data/backend_repo
git init
echo "print('Server running')" > server.py
git add .
git commit -m "Initial backend commit"

mkdir -p /home/test/project_data/frontend_repo
cd /home/test/project_data/frontend_repo
git init
echo "<html>Hello</html>" > index.html
git add .
git commit -m "Initial frontend commit"

mkdir -p /home/test/project_data/docs
echo "Project requirements 2024" > /home/test/project_data/docs/info.txt
mkdir -p /mnt/backup_drive/metadata



#sudo nano /etc/fstab
#/dev/sdb1    /mnt/backup_drive    ext4    defaults    0    0
#chmod +x /home/test/backup_scripts/full.sh
#chmod +x /home/test/backup_scripts/inc.sh
#chmod +x /home/test/backup_scripts/restore.sh