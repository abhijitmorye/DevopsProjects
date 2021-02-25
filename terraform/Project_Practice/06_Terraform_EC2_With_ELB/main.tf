provider "aws" {
  region = "us-east-1"
  access_key  = ""
  secret_key  = ""
}


resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "http_sg" {
  name   = "http_security_group"
  vpc_id = aws_default_vpc.default.id

  ingress {
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "http_servers" {
  ami = data.aws_ami.aws_ami_linux.id

  instance_type = "t2.micro"

  key_name = "default_ec2"

  vpc_security_group_ids = [aws_security_group.http_sg.id]

  #creating ec2 instances in different subnet of particular vpc_id

  for_each = data.aws_subnet_ids.default_subnet_ids.ids

  subnet_id = each.value

  tags = {

    name = "Http_server_${each.value}"
  }

  connection {
    host = self.public_ip

    user = "ec2-user"

    private_key = file(var.key_filepath)

    type = "ssh"
  }


  provisioner "remote-exec" {
    inline = [

      #install http server
      "sudo yum install httpd -y",

      #start http server
      "sudo service httpd start",

      #write message and save it into index.html file in /var/www/html/index
      "echo Public DNS - ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }



}
