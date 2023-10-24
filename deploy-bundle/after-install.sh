
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 278607931101.dkr.ecr.eu-north-1.amazonaws.com
docker push 278607931101.dkr.ecr.eu-north-1.amazonaws.com/vprofile:vprofileapp-1.0.5
