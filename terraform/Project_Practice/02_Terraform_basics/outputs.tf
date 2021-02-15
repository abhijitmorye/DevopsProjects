output "aws_s3_bucket_ouput"{
    value=aws_s3_bucket.my_s3_devopsbucket
}


output "my_aws_iam_user_output" {
    value = aws_iam_user.my_devops_iam_user
}