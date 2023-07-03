#!/bin/bash

# Stop Tomcat 9
sudo systemctl stop tomcat9

# Wait for Tomcat to stop
sleep 5

# Verify status
is_running=$(sudo systemctl is-active tomcat9)

if [ "$is_running" = "inactive" ]; then
    echo "Tomcat 9 has been successfully stopped."
else
    echo "Failed to stop Tomcat 9."
fi
