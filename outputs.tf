output "db_name" {
  value = aws_db_instance.wagtail_db.db_name
}

output "db_user" {
  value = aws_db_instance.wagtail_db.username
}

output "db_endpoint" {
  value = aws_db_instance.wagtail_db.endpoint
}

output "db_id" {
  value = aws_db_instance.wagtail_db.id
}

output "lb_target_group_id" {
  value = aws_lb_target_group.wagtail_tg.id
}

output "lb_id" {
  value = aws_lb.wagtail_lb.id
}

output "lb_dns" {
  value = aws_lb.wagtail_lb.dns_name
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "wdb_sg_id" {
  value = aws_security_group.db_sg.id
}

output "route53_record" {
  value = aws_route53_record.wagtail.records
}

output "ec2_server_outputs" {
  value = module.ec2_server.aws_instance_id
}