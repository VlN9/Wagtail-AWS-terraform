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
}

variable "number_of_instances" {
  type    = number
  default = 1
}

variable "sg_ingress_rule" {
  description = "list of parametres for server's security group ingress rules"
  type        = list(any)
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

variable "sg_egress_rule" {
  description = "list of parametres for server's security group egress rules"
  type        = list(any)
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

variable "my_ip" {
  type      = string
  sensitive = true
  default   = "93.175.223.50/32"
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

variable "health_check_sg_protocol" {
  description = "protocol for security group rule for health_check"
  type        = string
  default     = "tcp"
}

variable "data_sg_rule_count" {
  default = 0
}

