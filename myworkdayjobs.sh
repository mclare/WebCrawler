#!/bin/bash
# Shell cript wrapper for https://github.com/chuchro3/WebCrawler python script -- thanks!
# Pyton needs at least urlopen, so,    pip install urlopen
date=`date +%Y%m%d%H%M`
backup_dir="brocku"
backup_dir_working="${backup_dir}/brocku-${date}"
logfile="workday-job-export.log"
backup_age=360

# echo a string to screen and log
function echo_and_log {
   logstring="[ `date` ] : $*"
   echo $logstring
   echo $logstring >> $logfile
}

# print error to screen and exit
function exit_with_error {
   echo_and_log "Error: $*"
   echo_and_log "Exiting with code 1"
   exit 1
}

# funtion to delete old backups
function clean_backups {
   find $backup_dir -type f -mtime +${backup_age} -exec rm -f {} \;
   [ "$?" == "0" ] || echo_and_log "Error encountered when cleaning old backups from $backup_dir"
}
   
###################################

echo_and_log "Start Workday job board backup"

# set umask
umask 0077

echo_and_log "Creating directory ${backup_dir_working}"
mkdir -p $backup_dir
mkdir -p $backup_dir_working

# Run https://github.com/chuchro3/WebCrawler python script
echo_and_log "Starting python script"
python3 crawler.py -v -u https://brocku.wd3.myworkdayjobs.com/brocku_careers/ -d $backup_dir_working > $backup_dir_working/jobs.txt

# call funtion to clean backup directory
echo_and_log "Cleaning backup directory ${backup_dir}"
clean_backups

echo_and_log "Backup complete"

