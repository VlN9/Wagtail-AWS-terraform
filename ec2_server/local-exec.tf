resource "null_resource" "add_hosts" {
  provisioner "local-exec" {
    command = "echo \"[prod_servers]\n${module.ec2_server.aws_instance_public_ip[0]}\" > ./hosts.txt"
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
