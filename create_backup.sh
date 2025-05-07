#!/bin/bash

# Select a source directory using Zenity
SOURCE_DIR=$(zenity --file-selection --directory --title="Select Source Directory")
if [ $? -ne 0 ]; then
    zenity --error --text="Backup canceled by user."
    exit 1
fi

# Select the destination folder using Zenity
DEST_DIR=$(zenity --file-selection --directory --title="Select Destination Directory")
if [ $? -ne 0 ]; then
    zenity --error --text="Backup canceled by user."
    exit 1
fi

# Create a tarball of the source folder and backup
BACKUP_FILE="$DEST_DIR/backup_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

# Check if the backup was successful and display the result using Zenity
if [ $? -eq 0 ]; then
    zenity --info --text="Backup successful! File saved to: $BACKUP_FILE"
else
    zenity --error --text="Backup failed!"
fi
