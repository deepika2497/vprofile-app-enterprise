resource "aws_instance" "vprofileapp_instance" {
  ami           = "ami-0eeca1225b745d958"  
  instance_type = "t2.micro"              
  subnet_id     = aws_subnet.public_subnets[0].id
  key_name      = "devops-keypair"             
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "VprofileApp_Prod"
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> b3f2237abed8c5f666dae05944f66067bd167568
