resource "aws_s3_bucket" "my_s3_devopsbucket" {
    bucket="my-devops-s3-bucket-001"
    versioning {
        enabled=true
    }
}

resource "aws_iam_user" "my_devops_iam_user"{
    name="my_devops_iam_user"
}