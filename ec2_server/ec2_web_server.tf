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
  key_pair_name              = var.key_pair_name
}

resource "aws_security_group" "web_sg" {
  name = "Web Security Group"

  tags = merge(var.common_tags, { Name = "${local.name}-Security-Group" })
}

resource "aws_security_group_rule" "cidr_rule_for_web_sg" {
  count             = length(var.sg_cidr_rule) 
  description       = element(var.sg_cidr_rule, count.index)["description"]
  type              = element(var.sg_cidr_rule, count.index)["type"]
  from_port         = element(var.sg_cidr_rule, count.index)["from_port"]
  to_port           = element(var.sg_cidr_rule, count.index)["to_port"]
  protocol          = element(var.sg_cidr_rule, count.index)["protocol"]
  cidr_blocks       = element(var.sg_cidr_rule, count.index)["cidr_blocks"]
  security_group_id = aws_security_group.web_sg.id

  depends_on = [
    aws_security_group.web_sg
  ]
}


resource "aws_security_group_rule" "self_rule_for_web_sg" {
  count                    = length(var.sg_self_rule)
  description              = element(var.sg_self_rule, count.index)["description"]
  type                     = element(var.sg_self_rule, count.index)["type"]
  from_port                = element(var.sg_self_rule, count.index)["port"]
  to_port                  = element(var.sg_self_rule, count.index)["port"]
  protocol                 = element(var.sg_self_rule, count.index)["protocol"]
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = aws_security_group.web_sg.id

  depends_on = [
    aws_security_group.web_sg
  ]
}


resource "aws_security_group_rule" "another_sg_rule_for_web_sg" {
  count                    = length(var.sg_another_group_rule)
  description              = element(var.sg_another_group_rule, count.index)["description"]
  type                     = element(var.sg_another_group_rule, count.index)["type"]
  from_port                = element(var.sg_another_group_rule, count.index)["from_port"]
  to_port                  = element(var.sg_another_group_rule, count.index)["to_port"]
  protocol                 = element(var.sg_another_group_rule, count.index)["protocol"]
  source_security_group_id = element(var.sg_another_group_rule, count.index)["source_security_group_id"]
  security_group_id        = aws_security_group.web_sg.id

  depends_on = [
    aws_security_group.web_sg
  ]
}

#==========Special=Rule===================================================
resource "aws_security_group_rule" "db_connect_rule" {
  count                    = var.security_group_rule_for_db == true ? 1 : 0
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = data.aws_security_group.db_sg[0].id

  depends_on = [
    aws_security_group.web_sg
  ]
}