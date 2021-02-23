data "aws_subnet_ids" "default_subnet_ids" {
  vpc_id = aws_default_vpc.default.id
}

data "aws_ami" "aws_ami_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}