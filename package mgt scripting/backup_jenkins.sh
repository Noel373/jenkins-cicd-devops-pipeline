#!/bin/bash

# -------- CONFIGURATION --------
JENKINS_HOME="/var/lib/jenkins"             # Jenkins home directory
BACKUP_DIR="/tmp/jenkins_backup"             # Temporary backup directory
TIMESTAMP=$(date +%Y%m%d%H%M%S)              # Timestamp for unique backup filename
BACKUP_FILE="jenkins_backup_${TIMESTAMP}.tar.gz"
S3_BUCKET="s3://noel007-backup-bucket" 
LOG_FILE="/var/log/jenkins_backup.log"       # Optional: log file path

# -------- SCRIPT --------
echo "[$(date)] Starting Jenkins backup..." | tee -a $LOG_FILE

# Create temporary backup directory
mkdir -p $BACKUP_DIR

# Archive Jenkins home directory
tar -czf $BACKUP_DIR/$BACKUP_FILE -C $JENKINS_HOME .

if [ $? -ne 0 ]; then
  echo "[$(date)] ERROR: Failed to create backup archive!" | tee -a $LOG_FILE
  exit 1
fi

echo "[$(date)] Created backup archive $BACKUP_FILE" | tee -a $LOG_FILE

# Upload backup to S3
aws s3 cp $BACKUP_DIR/$BACKUP_FILE $S3_BUCKET

if [ $? -ne 0 ]; then
  echo "[$(date)] ERROR: Failed to upload backup to S3!" | tee -a $LOG_FILE
  exit 1
fi

echo "[$(date)] Backup uploaded to $S3_BUCKET" | tee -a $LOG_FILE

# Cleanup temporary backup directory
rm -rf $BACKUP_DIR

echo "[$(date)] Jenkins backup completed successfully." | tee -a $LOG_FILE
