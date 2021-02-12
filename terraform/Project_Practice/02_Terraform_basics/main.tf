provider "aws"{
    region="us-east-1"
    access_key="AKIASADG2SWDUKVMZYNY"
    secret_key="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"
}

resource "aws_s3_bucket" "my_s3_devopsbucket" {
    bucket="my-devops-s3-bucket-001"
    versioning {
        enabled=true
    }
}

resource "aws_iam_user" "my_devops_iam_user"{
    name="my_devops_iam_user"
}


output "my_aws_iam_user_output" {
    value = aws_iam_user.my_devops_iam_user
}