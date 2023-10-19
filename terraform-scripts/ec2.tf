resource "aws_instance" "vprofileapp_instance" {
  ami           = "ami-085536f333a279f41"  
  instance_type = "t3.micro"              
  subnet_id     = aws_subnet.public_subnets[0].id
  key_name      = "vprofile-keypair"             
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "VprofileApp_Prod"
  }
}
