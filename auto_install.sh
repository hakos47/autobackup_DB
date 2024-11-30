#!/bin/bash

# Check if the database name is provided
if [ -z "$1" ]; then
  echo ""
  echo "Usage: $0 <database_name> <user_name> [password]"
  exit 1
fi

# Assign the database name, user, and password
DB_NAME=$1
DB_USER=$2
DB_PASS=$3

echo "$DB_NAME"

echo ""
echo "Creating directories..."

# Create necessary directories
mkdir -p /etc/scripts
mkdir -p /backups/db

# Copy the original script to the target directory
ORIGINAL_SCRIPT="autobackup_DB.sh"
COPIED_SCRIPT="/etc/scripts/autobackup_DB.sh"

if [ -f "$ORIGINAL_SCRIPT" ]; then
  echo "Copying the original script to $COPIED_SCRIPT ..."
  cp "$ORIGINAL_SCRIPT" "$COPIED_SCRIPT"
else
  echo "Error: Original script $ORIGINAL_SCRIPT not found."
  exit 1
fi

# Modify the copied script
if [ -f "$COPIED_SCRIPT" ]; then
  echo "Updating database name, user, and password in the copied script ..."
  sed -i "s/^DB_NAME=.*/DB_NAME=\"$DB_NAME\"/" "$COPIED_SCRIPT"
  sed -i "s/^DB_USER=.*/DB_USER=\"$DB_USER\"/" "$COPIED_SCRIPT"
  sed -i "s/^DB_PASS=.*/DB_PASS=\"$DB_PASS\"/" "$COPIED_SCRIPT"
  sudo chmod +x "$COPIED_SCRIPT"
  echo "Database name updated to $DB_NAME in the copied script."
else
  echo "Error: Copied script $COPIED_SCRIPT not found."
  exit 1
fi

echo "Backup script configured and ready at $COPIED_SCRIPT"


cp db_backup.service /etc/systemd/system/db_backup.service
cp db_backup.timer /etc/systemd/system/db_backup.timer

#time out for 2 seconds
sleep 2

systemctl enable db_backup.timer
systemctl start db_backup.timer

echo "Service and timer enabled and started."

# Mensaje en verde
echo -e "\033[0;32m Auto install script completed successfully. \033[0m"