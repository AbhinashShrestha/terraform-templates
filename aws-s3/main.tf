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

resource "aws_s3_bucket" "mero-bucket-ho" {
  bucket = "mero-afanai-${random_id.uidgen.dec}"
}

resource "aws_s3_object" "upload-files" {
  bucket = aws_s3_bucket.mero-bucket-ho.bucket
  key    = "mero.txt"
  source = "./a.txt"
}

output "random-id-output" {
  value = random_id.uidgen.dec
}
