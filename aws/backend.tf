terraform {
  backend "s3" {
    bucket         = "org-manage-terraform-state"
    key            = "global/aws/org/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-wellness"
    encrypt        = true
  }
}

