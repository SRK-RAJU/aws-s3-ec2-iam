resource "aws_iam_role" "SSMRoleForEC2" {
  name = "SSMRoleForEC2"
  assume_role_policy = jsonencode(
  {
    Version = "2012-10-17"
    "Statement": [
      {
        "Effect": "Allow"
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_policy_attachment" "role-policy-attachment" {
  name       = "ec2_attachment"
  for_each = toset([
  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ])
  roles      = [aws_iam_role.SSMRoleForEC2.name]
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.SSMRoleForEC2.name
#  instance_profile_arn=aws_iam_instance_profile.ec2_profile.arn

}
#resource "aws_iam_instance_profile" "this" {
#  name = "${var.prefix}-first-profile"
#  role = aws_iam_role.data_role.name
#}
#resource "databricks_instance_profile" "ds" {
#  instance_profile_arn = aws_iam_instance_profile.ec2_profile.arn
#  }

#resource "databricks_aws_s3_mount" "this" {
##  instance_profile=aws_iam_instance_profile.ec2_profile.arn
# instance_profile = aws_instance.web-pub.arn
#  s3_bucket_name = aws_s3_bucket.blog.bucket
#mount_name = "experiments"
#}
