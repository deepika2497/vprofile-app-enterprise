#!/bin/bash

# Start Tomcat
sudo systemctl start tomcat9

# Wait for Tomcat to start up
sleep 5

# Verify if Tomcat is running
if systemctl is-active --quiet tomcat9; then
    echo "Tomcat is running"
else
    echo " tomcat is failed to start"
fi