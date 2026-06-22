terraform {
  backend "s3" {
    bucket         = "mirrorsoul-terraform-state"
    key            = "infra/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "mirrorsoul-terraform-lock"
    encrypt        = true
  }
}