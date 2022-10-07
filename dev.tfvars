aws_region = "ca-central-1"

common_tags = {
  Owner       = "Nechay Vladimir"
  Project     = "WagtailWebApp"
  Environment = "dev"
}

replace_userdata_on_change = true

instance_type = "t2.micro"

number_of_instances = 1

db_instance_class = "db.t3.micro"

db_storage = 10

sg_ingress_rule = [
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["93.175.223.50/32"]
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["93.175.223.50/32"]
  }
]