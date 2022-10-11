data "terraform_remote_state" "server" {
  backend = "s3"
  config = {
    bucket = "vln-project-terraforrm-state"
    key    = "wagtail/prod/terraform.tfstate"
    region = "ca-central-1"
  }
}

data "aws_subnets" "default" {}

data "aws_vpc" "default" {}

data "aws_route53_zone" "vln" {
  name         = "vln.ink"
  private_zone = false
}

data "aws_security_group" "db_sg" {
  count = var.security_group_rule_for_db == true ? 1 : 0
  name  = "SG for db"
}