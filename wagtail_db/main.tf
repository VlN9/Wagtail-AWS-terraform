provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "vln-project-terraforrm-state"
    key    = "wagtail/db/terraform.tfstate"
    region = "ca-central-1"
  }
}

resource "aws_db_instance" "wagtail_db" {
  identifier		 = "terraform-wagtail-db"
  allocated_storage      = var.db_storage
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_user
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  apply_immediately      = true
  skip_final_snapshot    = true

  tags = merge(var.common_tags, { Name = "${local.name}-Database" })
}

resource "aws_security_group" "db_sg" {
  name = "SG for db"
  tags = merge(var.common_tags, { Name = "${local.name}-Databse-Security-Group" })
}
