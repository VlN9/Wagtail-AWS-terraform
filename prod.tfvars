aws_region = "ca-central-1"

common_tags = {
  Owner       = "Nechay Vladimir"
  Project     = "WagtailWebApp"
  Environment = "prod"
}

replace_userdata_on_change = false

number_of_instances = 1

user_data =<<EOF
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

DEBUG=False
SECRET_KEY=[django-insecure-zamqnhl^5gb6af3ef$w(r2%4l%1w@2x=t_*71^r5_moa8cg*xg]
DJANGO_ALLOWED_HOSTS=localhost 127.0.0.1 wagtail.vln.ink

SQL_ENGINE=django.db.backends.postgresql_psycopg2
SQL_DATABASE=demo_wagtail
SQL_USER=demouser
SQL_PASSWORD=DemoPass
SQL_HOST=terraform-20221009081259908400000001.cstxddea1prn.ca-central-1.rds.amazonaws.com
SQL_PORT=5432
DATABASE=postgres" > /var/.env 
EOF

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

data_sg_rule_count = 1