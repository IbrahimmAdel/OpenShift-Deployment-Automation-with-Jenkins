#Create s3 bucket to store the Terraform state file
resource "aws_s3_bucket" "terraform_state" {
  bucket = "ivolve-remote-state-bucket"
  #lifecycle {
    #prevent_destroy = true    #Ensures that the S3 bucket cannot be destroyed accidentally, preventing data loss
  #} 
}


#Enable versioning for the S3 bucket to help tracking changes to objects in the bucket over time
resource "aws_s3_bucket_versioning" "enable" {
  bucket   = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}


#Create a DynamoDB table that will be used for locking when multiple users are running Terraform concurrently
resource "aws_dynamodb_table" "terraform_lock" {
  name 	       = "iVolve-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
    }
}

#Configuration for Terraform backend
#terraform {
# backend "s3" {
#   bucket         = "ivolve-remote-state-bucket"
#   key            = "terraform.tfstate"
#   region         = "us-east-1"
#   dynamodb_table = "iVolve-lock"
#   encrypt        = true
#  }
#}
