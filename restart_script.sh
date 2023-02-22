#!/bin/bash

# Log file location
LOG_FILE="/var/log/collector_restart.log"

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
}

# Function to handle errors
handle_error() {
    log "Error: $1"
    exit 1
}

# Function to cleanly exit upon success
clean_escape() {
	log " "
	log "Successfully executed: $0"
	exit 0
}

log "Stoping the datacollector service"
systemctl stop datacollector.service
sleep 10

log "Restarting the datacollector service"
systemctl restart datacollector.service
sleep 1
#systemctl status datacollector.service | log

STATUS="$(systemctl is-active datacollector.service)"
if [ "${STATUS}" = "active" ]; then
    log "datacollector.service is running."
    log "exiting script..."
    clean_escape
else
    echo " Service not running.... so exiting with Fail "
    handle_error
fi

exit 0
