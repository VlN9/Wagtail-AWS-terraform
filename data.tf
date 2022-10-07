data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

data "terraform_remote_state" "server" {
  backend = "s3"
  config = {
    bucket = "vln-project-terraforrm-state"
    key    = "wagtail/prod/terraform.tfstate"
    region = "ca-central-1"
  }
}

data "aws_key_pair" "my_key" {}

data "aws_subnets" "default" {}

data "aws_vpc" "default" {}

data "aws_route53_zone" "vln" {
  name         = "vln.ink"
  private_zone = false
} 