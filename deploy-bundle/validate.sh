#!/bin/bash

# Verify if Tomcat is running
if systemctl is-active --quiet tomcat9; then
    echo "Tomcat is running"
else
    echo " tomcat is failed to start"
fi