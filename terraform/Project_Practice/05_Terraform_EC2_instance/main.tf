provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}


#HTTP server --> SG
#Security Group (SG) --> HTTP Port 80, SSH 22, CIDR [0.0.0.0/0]

resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"

  #to which vpc id , this security group should be part of
  vpc_id = ""

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
  ami = "ami-047a51fa27710816e"

  #key that should be associated with this EC2 instance
  key_name = "default_ec2"

  #security_groups associated with this EC2 instance.. in form array
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  #instance type for this EC2 instance .. hardware basically
  instance_type = "t2.micro"

  #subnet to which this EC2 should be attached to
  subnet_id = ""

}


