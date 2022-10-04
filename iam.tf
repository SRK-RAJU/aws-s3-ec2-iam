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
}
