variable "aws_region" {
  description = "region for terraform infra"
  type        = string
  default     = "ca-central-1"
}

variable "common_tags" {
  description = "common tags for all resources"
  type        = map(any)
  default = {
    Owner       = "Nechay Vladimir"
    Project     = "WagtailWebApp"
    Environment = "prod"
  }
}

variable "db_instance_class" {
  description = "class of db instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine" {
  description = "engine of db"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "version of db engine"
  type        = string
  default     = "12.7"
}

variable "db_storage" {
  description = "amount storage of db instance"
  type        = number
  default     = 8
}

variable "db_name" {
  description = "name of database"
  type = string
  default = "demo_wagtail"
}

variable "db_user" {
  description = "name of user for db"
  type = string
  default = "demouser"
}

variable "db_password" {
  description = "password for db"
  type = string
  default = "DemoPass"
}