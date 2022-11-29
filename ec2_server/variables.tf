#==========Vars===========================
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

variable "key_pair_name" {
  description = "name of key pair for ec2 instance"
  type        = string
  default     = "client_key-ca-central-1"
}

variable "instance_type" {
  description = "class of instances"
  type        = string
  default     = "t2.micro"
}

variable "replace_userdata_on_change" {
  description = "force replacement ec2 instances while user data is change"
  type        = bool
  default     = false
}

variable "user_data" {
  default = " "
}

variable "number_of_instances" {
  type    = number
  default = 1
}

variable "sg_cidr_rule" {
  description = "list of parametres for server's security group ingress and egress rules. CIDR only"
  type        = list(any)
  default = [
    {
      type        = "ingress"
      description = " "
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

variable "sg_self_rule" {
  description = "list of parametres for server's security group ingress and egress rules. for group itself"
  type = list(any)
  default = [
    {
      type        = "ingress"
      description = " "
      port        = 80
      protocol    = "tcp"
    }
  ]
}

variable "sg_another_group_rule" {
  description = "list of parametres for server's security group ingress and egress rules. For connection security group to another"
  type    = list(any)
  default = []
}

variable "healthy_threshold" {
  description = "number of checks for healthy state"
  type        = number
  default     = 4
}

variable "unhealthy_threshold" {
  description = "number of checks for unhealthy state"
  type        = number
  default     = 2
}

variable "health_check_timeout" {
  type    = number
  default = 2
}

variable "health_check_interval" {
  type    = number
  default = 5
}

variable "lb_tg_protocol" {
  description = "protocol for target group health_checks"
  default     = "HTTP"
}

variable "lb_tg_port" {
  description = "port for target group health-checks and security gruop rule"
  default     = 80
}

variable "security_group_rule_for_db" {
  description = "if this value is 'true' then terraform find sg for db and connect it to ec2 server sg"
  type    = bool
  default = false
}

variable "data_db_name" {
  description = "name of db for data source"
}
