terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.16.2"
    }
  }

  backend "s3" {
    bucket         = "tf-site-state"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "tf-site-state-lock"
    encrypt        = true
  }
}

# Providers
provider "aws" {
  region = var.region
}

# Check if the S3 bucket already exists
data "aws_s3_bucket" "state_existing_bucket" {
  bucket = var.state_name
}

# Conditionally create a new S3 bucket if it doesn't exist
resource "aws_s3_bucket" "state_new_bucket" {
  count = length(data.aws_s3_bucket.state_existing_bucket.id) == 0 ? 1 : 0

  bucket = var.state_name
}

# Check if staticfiles bucket exists
data "aws_s3_bucket" "static_existing_bucket" {
  bucket = var.static_name
}

# Conditionally create staticfiles bucket if it doesn't exist
resource "aws_s3_bucket" "static_new_bucket" {
  count = length(data.aws_s3_bucket.static_existing_bucket.id) == 0 ? 1 : 0

  bucket = var.static_name
}

# state locking
resource "aws_dynamodb_table" "tf_lock" {
  name         = var.lock_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}