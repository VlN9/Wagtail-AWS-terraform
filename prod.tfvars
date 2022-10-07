aws_region = "ca-central-1"

common_tags = {
  Owner       = "Nechay Vladimir"
  Project     = "WagtailWebApp"
  Environment = "prod"
}

replace_userdata_on_change = false

number_of_instances = 1

db_storage = 15

sg_ingress_rule = [
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["93.175.223.50/32"]
  }
]