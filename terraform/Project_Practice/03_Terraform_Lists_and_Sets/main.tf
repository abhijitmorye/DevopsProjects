variable "names" {
  default = ["abhijit", "naruto"]
}

provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_iam_user" "my_aws_iam_user" {
  # count=length(var.names)
  # name=var.names[count.index]
  for_each = toset(var.names)
  name     = each.value
}
