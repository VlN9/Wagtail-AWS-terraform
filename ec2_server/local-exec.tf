resource "null_resource" "add_hosts" {
  provisioner "local-exec" {
    command = "echo [prod_servers]\n${module.ec2_server.aws_instance_public_ip} >> ./ansible/hosts.txt"
  }
  depends_on = [
    module.ec2_server
  ]
}

resource "null_resource" "ansible_activate" {
  provisioner "local-exec" {
    command = "sleep 2 && ansible-playbook ./ansible/playbook-main.yaml"
  }
  depends_on = [
    module.ec2_server
  ]
}

resource "null_resource" "echo_endpoint" {
  provisioner "local-exec" {
    command = "ansible prod_servers -m shell \"echo SQL_HOST=${data.aws_db_instance.main_db.endpoint} >> /var/.env \""
  }
 depends_on = [
    module.ec2_server,
    null_resource.ansible_activate
  ] 
}
