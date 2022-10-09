#==========EC2=Server========================================
module "ec2_server" {
  source                     = "git@github.com:VlN9/Terraform-modules.git//server_module"
  count_instances            = var.number_of_instances
  instance_type              = var.instance_type
  replace_userdata_on_change = var.replace_userdata_on_change
  env                        = var.common_tags["Environment"]
  owner                      = var.common_tags["Owner"]
  project                    = var.common_tags["Project"]
  user_data                  = var.user_data
  security_groups            = [aws_security_group.web_sg.id]
}

resource "aws_security_group" "web_sg" {
  name = "Web Security Group"

  dynamic "ingress" {
    for_each = var.sg_ingress_rule
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_rule
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }


  tags = merge(var.common_tags, { Name = "${local.name}-Security-Group" })
}

resource "aws_security_group_rule" "healthcheck_rule" {
  type                     = "ingress"
  from_port                = var.lb_tg_port
  to_port                  = var.lb_tg_port
  protocol                 = var.health_check_sg_protocol
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = aws_security_group.web_sg.id

  depends_on = [
    aws_security_group.web_sg
  ]
}

#==========Database=for=Wagtail==============================
resource "aws_security_group_rule" "db_connect_rule" {
  count                    = var.data_sg_rule_count
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = data.aws_security_group.db_sg.id

  depends_on = [
    aws_security_group.web_sg
  ]
}