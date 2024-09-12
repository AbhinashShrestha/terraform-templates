terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.65.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "uidgen" {
  byte_length = 8
}
resource "aws_s3_bucket" "mero-static" {
  bucket = "website-${random_id.uidgen.dec}"
}
resource "aws_s3_bucket_public_access_block" "public-acl" {
  bucket = aws_s3_bucket.mero-static.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.mero-static.id
  policy = jsonencode(
	{
    	Version = "2012-10-17",
    	Statement = [
        	{
            	Sid = "PublicReadGetObject",
            	Effect = "Allow",
            	Principal = "*",
            	Action = "s3:GetObject",
            	Resource = "arn:aws:s3:::${aws_s3_bucket.mero-static.id}/*"
       		}
    	]
	}
  )
}
resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.mero-static.id
  index_document {
    suffix = "index.html"
  }
}
resource "aws_s3_object" "file" {
  for_each     = fileset(path.module, "content/**/*.{html,css,js}")
  bucket       = aws_s3_bucket.mero-static.id
  key          = replace(each.value, "/^content//", "")
  source       = each.value
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  source_hash  = filemd5(each.value)
}

output "website-url" {
  value = aws_s3_bucket_website_configuration.website-config.website_endpoint
}

