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

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}