provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "vln-project-terraforrm-state"
    key    = "wagtail/prod/terraform.tfstate"
    region = "ca-central-1"
  }
}