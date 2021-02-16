variable "users" {
  default = {
    abhi : {
      country : "Canada",
      department : "IT"
    },
    naruto : {
      country : "Village hiddenn in leaf",
      department : "Hokage Team"
    },
    obito : {
      country : "Village hidden in rain",
      department : "Akatsuki"
    }
  }
}


provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_iam_user" "my_aws_iam_user" {

  #using map
  for_each = var.users
  name     = each.key
  tags = {
    country : each.value.country
    department : each.value.department
  }


  #list using set and for_each
  # for_each= toset(var.my_aws_iam_user_variables)
  # name= each.value

  #simple list
  # count = length(var.my_aws_iam_user_variables)
  # name = var.my_aws_iam_user_variables[count.index]

  #basic
  # count = 4
  # name = "${var.my_aws_iam_user_variables}_${count.index}"
}