#!/bin/bash

# Log file location
LOG_FILE="/var/log/collector_restart_installer.log"

timer_File="collector_interval.timer"
timer_Path="/etc/systemd/system/$timer_File"

service_File="data_restart_script.service"
service_Path="/etc/systemd/system/$service_File"

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
	log " All components installed Successfully!!!"
	log "Successfully executed: $0"
	exit 0
}

# Function to setup services
initial_install() {
    log "Starting timer installation"
    cp collector_interval.timer /etc/systemd/system/

    log "Starting service installation"
    cp data_restart_script.service /etc/systemd/system/
    # Reload daemons
    systemctl daemon-reload
    sleep 1
    # Enable timer service
    systemctl enable collector_interval.timer
    sleep 1
    # Enable restart_script service
    systemctl enable data_restart_script.service
    sleep 1
    # Start the services
    systemctl restart collector_interval.timer
    sleep 1
    systemctl restart data_restart_script.service
    sleep 1
    log "Services have been Successfully installed and setup"
}

log "Setup is starting."

# Check the services are installed correctly
if [ -e "$service_Path" ] && [ -e "$timer_Path" ]; then
    log "Files $timer_File and $service_File exists in /etc/systemd/system/ folder."
else
    log "Setting up services_ "
    initial_install
fi

# Check the timer is running
timer_STATUS="$(systemctl is-active collector_interval.timer)"
if [ "${timer_STATUS}" = "active" ]; then
    log "Timer is running."
else
    echo " Service not running.... so exiting with Fail "
    log " Service not running.... so exiting with Fail "
    log " Try manually running the timer "
    handle_error
fi

# Check the service is running
service_STATUS="$(systemctl is-active data_restart_script.service)"
if [ "${service_STATUS}" = "active" ]; then
    log "Service is running."
else
    echo " Service not running.... so exiting with Fail "
    handle_error
fi

exit 0