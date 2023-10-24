#!/bin/bash

# Start Tomcat using systemctl
# sudo systemctl start tomcat9

# # Wait for Tomcat to start
# sleep 5

# # Check if Tomcat is running
# if systemctl is-active --quiet tomcat9; then
#     echo "Tomcat is running."
# else
#     echo "Tomcat failed to start."
# fi

#docker run -d  --name vprofile_app -p 8080:8080 851481789693.dkr.ecr.ap-south-1.amazonaws.com/vprofile-qa:vprofileapp-%version%

#!/bin/bash

# Start Tomcat using systemctl
# sudo systemctl start tomcat9

# Wait for Tomcat to start
# sleep 5

# Check if Tomcat is running
# if systemctl is-active --quiet tomcat9; then
 #   echo "Tomcat is running."
# else
  #  echo "Tomcat failed to start."
# fi
#!/bin/bash

docker run -d  --name vprofile_app -p 8080:8080 278607931101.dkr.ecr.eu-north-1.amazonaws.com/vprofile:vprofileapp-%version%
