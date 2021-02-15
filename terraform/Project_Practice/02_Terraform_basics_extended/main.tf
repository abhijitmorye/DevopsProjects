variable "aws_iam_users_name_variable" {
  type    = string
  default = "my_aws_iam_user"
}


provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}


# resource "aws_s3_bucket" "my_s3_devopsbucket" {
#     bucket="my-devops-s3-bucket-001"
#     versioning {
#         enabled=true
#     }
# }


#multiple users
resource "aws_iam_user" "my_aws_iam_users" {
  count = 2
  name  = "${var.aws_iam_users_name_variable}_${count.index}"
}