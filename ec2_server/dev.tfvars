aws_region = "ca-central-1"

common_tags = {
  Owner       = "Nechay Vladimir"
  Project     = "WagtailWebApp"
  Environment = "dev"
}

replace_userdata_on_change = true

instance_type = "t2.micro"

number_of_instances = 1

user_data = <<EOF
#!/bin/bash

sudo yum -y upgrade
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user

sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose 

sudo yum -y install git

echo "# .env.dev

DEBUG=True
SECRET_KEY=[django-insecure-zamqnhl^5gb6af3ef$w(r2%4l%1w@2x=t_*71^r5_moa8cg*xg]
DJANGO_ALLOWED_HOSTS=localhost 127.0.0.1 wagtail-dev.vln.ink

SQL_ENGINE=django.db.backends.postgresql_psycopg2
SQL_DATABASE=demo_wagtail
SQL_USER=demouser
SQL_PASSWORD=DemoPass
SQL_HOST=terraform-20221009083555012200000001.cstxddea1prn.ca-central-1.rds.amazonaws.com
SQL_PORT=5432
DATABASE=postgres" > /var/.env 
EOF


sg_cidr_rule = [
  {
    description = "HTTP ingress rule for me"
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["93.175.223.50/32"]
  },
  {
    description = "SSH ingress rule for me"
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["93.175.223.50/32"]
  },
  {
    description = "egress rule for all"
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

sg_self_rule = [
  {
    description = "rule for target group health_check"
    port        = 80
    protocol    = "tcp"
    type        = "ingress"
  }
]

security_group_rule_for_db = false