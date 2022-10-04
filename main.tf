provider "aws" {
  region =var.region
}
resource "aws_s3_bucket" "blog" {
  bucket = var.bucket_name
  acl="private"
}

resource "aws_s3_bucket_object" "object1" {
  for_each = fileset("html/","*")
  bucket = aws_s3_bucket.blog.id
  key    = each.value
  source = "html/${each.value}"
  etag=filemd5("html/${each.value}")
  content_type = "text/html"
}