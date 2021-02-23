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
