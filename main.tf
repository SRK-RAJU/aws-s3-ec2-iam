provider "aws" {
  region =var.region
}

terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.4.0"
    }
  }
}
resource "aws_s3_bucket" "blog" {
  bucket = var.bucket_name
  acl="private"
  lifecycle_rule{
    id= "archive"
    enabled =true
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days=60
      storage_class = "GLACIER"
    }

  }
  versioning {
    enabled = true
  }
  force_destroy = true
  tags = {
    Environment:"QA"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_object" "object1" {
  for_each = fileset("html/","*")
  bucket = aws_s3_bucket.blog.id
  key    = each.value
  source = "html/${each.value}"
  etag=filemd5("html/${each.value}")
  content_type = "text/html"
}
#resource "aws_s3_bucket_versioning" "s3-version" {
#  bucket = aws_s3_bucket.blog.id
#  versioning_configuration {
#    status = "Enabled"
#  }
#}

resource "aws_s3_bucket_metric" "enable-metrics-block" {
  bucket = var.bucket_name
  name   = "EntireBucket"
}
