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

resource "aws_instance" "http_server" {
  ami = data.aws_ami.aws_ami_linux.id

  instance_type = "t2.micro"

  key_name = "default_ec2"

  vpc_security_group_ids = [aws_security_group.http_sg.id]

  subnet_id = tolist(data.aws_subnet_ids.default_subnet_ids.ids)[0]

  connection {
    host = self.public_ip

    user = "ec2-user"

    private_key = file(var.key_filepath)

    type = "ssh"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",

      "sudo service httpd start",

      "echo ABHIJIT | sudo tee /var/www/html/index.html"
    ]
  }



}
