#! /usr/bin/env bash

server_dir="/srv/minecraft_liberty_friends"
backup_file="$server_dir/daily_backups/minecraft-data-$(date -I).tar.gz"

# make backup directories
mkdir -p "$server_dir/daily_backups"
mkdir -p "$server_dir/weekly_backups"
mkdir -p "$server_dir/monthly_backups"
mkdir -p "$server_dir/yearly_backups"

# Create the backup
tar -czf $backup_file "$server_dir/minecraft-data"

# Copy to weekly backups
if [ -z "$(find "$server_dir/weekly_backups" -newermt $(date +%Y-%m-%d -d '1 week ago') -type f -print)" ]; then
	cp "$backup_file" "$server_dir/weekly_backups" 
fi

# Copy to monthly backups
if [ -z "$(find "$server_dir/monthly_backups" -newermt $(date +%Y-%m-%d -d '1 month ago') -type f -print)" ]; then
	cp "$backup_file" "$server_dir/monthly_backups" 
fi

# Copy to yearly backups
if [ -z "$(find "$server_dir/yearly_backups" -newermt $(date +%Y-%m-%d -d '1 year ago') -type f -print)" ]; then
	cp "$backup_file" "$server_dir/yearly_backups" 
fi

# Clean up old backups
find "$server_dir/daily_backups" -mtime +7 -type f -delete
find "$server_dir/weekly_backups" -mtime +30 -type f -delete
find "$server_dir/monthly_backups" -mtime +365 -type f -delete
