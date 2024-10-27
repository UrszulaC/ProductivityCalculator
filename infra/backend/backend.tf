terraform {
  backend "s3" {
    bucket         = "my-terraform-states"
    key            = "env/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock-table"
  }
}