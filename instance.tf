resource "aws_instance" "web-pub" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
#  key_name = var.generated_key_name
#  security_groups = [ aws_security_group.allow-sg-pub.id ]
  vpc_security_group_ids = [aws_security_group.web-sg.id]
#  subnet_id = aws_subnet.public-sub.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  user_data = <<-EOF
#! /bin/bash
sudo su
yum update -y
yum install httpd -y
aws s3 cp s3://${aws_s3_bucket.blog.id}/index.html /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF


  tags = {
      Name="web-pub-raju"

    }
}
