output "aws_http_server_sg_details" {
  value = aws_security_group.http_server_sg
}

output "aws_ec2_instance_details" {
  value = aws_instance.http_server
}

output "aws_public_dns" {
  value = aws_instance.http_server.public_dns
}

output "default_vpc" {
  value = aws_default_vpc.default.id
}

output "default_subnet_id" {
  value = data.aws_subnet_ids.default_subnet_ids.ids
}


output "aws_ami_linux_2_id" {
  value = data.aws_ami.aws_ami_linux_2.id
}