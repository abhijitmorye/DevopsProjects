variable "names" {
  default = ["abhijit", "naruto", "kakashi"]
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIASADG2SWDQDCFOWZQ"
  secret_key = "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"
}

resource "aws_iam_user" "my_aws_iam_user" {
  # count=length(var.names)
  # name=var.names[count.index]
  for_each = toset(var.names)
  name     = each.value
}
