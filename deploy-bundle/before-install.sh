#!/bin/bash

# Stop Tomcat
# echo "Stopping Tomcat..."
# CATALINA_PID=$(pgrep -f "catalina")
# if [ -n "$CATALINA_PID" ]; then
#     kill "$CATALINA_PID"
#     echo "Tomcat stopped successfully."
# else
#     echo "Tomcat is already stopped."
# fi
# rm -rf /var/lib/tomcat9/webapps/*.war

#if [ "$(docker inspect -f '{{.State.Running}}' vprofile_app)" == "true" ]; then
 #   docker stop vprofile_app
  #  docker rm vprofile_app
#fi

if [ "$(docker inspect -f '{{.State.Running}}' vprofile_app)" == "true" ]; then
    docker stop vprofile_app
    docker rm vprofile_app
fi
