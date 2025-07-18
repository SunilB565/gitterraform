provider "aws" { region = "us-east-1" }

resource "aws_s3_bucket" "state" {
  bucket = "my-terraform-state-bucket"
  versioning { enabled = true }
}

resource "aws_dynamodb_table" "locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute { 
    name = "LockID"
    type = "S" 
  }
}

