variable "aws_key_pair" {
  default = "D:\\Udemy\\TerraForm AWS IAM Access Key\\aws\\aws_keys\\default_ec2.pem"
}


provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}


#fetch default vpc from AWS for whoch region is specified
resource "aws_default_vpc" "default" {
}


#data provider for aws_subnet_ids
data "aws_subnet_ids" "default_subnet_ids" {
  vpc_id = aws_default_vpc.default.id
}



# data provider for amazon ami
data "aws_ami" "aws_ami_linux_2" {
  most_recent = true       # fetch most recent one
  owners      = ["amazon"] # which type of machine we want

  filter {
    name   = "name" #to which field we want to apply filter
    values = ["amzn2-ami-hvm-*"]
  }
}



#aws ami ids data provider
data "aws_ami_ids" "aws_ami_linux_2_ids" {
  # most_recent = true   # fetch most recent one
  owners = ["amazon"] # which type of machine we want

  # filter {
  #   name = "name" #to which field we want to apply filter
  #   values = ["amzn2-ami-hbm-*"]
  # }
}




#HTTP server --> SG
#Security Group (SG) --> HTTP Port 80, SSH 22, CIDR [0.0.0.0/0]
resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"

  #to which vpc id , this security group should be part of
  # vpc_id = "vpc-eef45893"
  vpc_id = aws_default_vpc.default.id

  #igress rule .. rule for incoming traffic
  #for  http server/access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #for ssh server
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  #egress rule.. rule for outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1 # for kind of protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }

}


resource "aws_instance" "http_server" {

  #ami image name i.e. which os should be used
  ami = data.aws_ami.aws_ami_linux_2.id

  #key that should be associated with this EC2 instance
  key_name = "default_ec2"

  #security_groups associated with this EC2 instance.. in form array
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  #instance type for this EC2 instance .. hardware basically
  instance_type = "t2.micro"

  #subnet to which this EC2 should be attached to
  subnet_id = tolist(data.aws_subnet_ids.default_subnet_ids.ids)[1]


  #will establish the connection with newly created instance
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)

  }

  #after connection, this will provide bash screen to execute all command
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


