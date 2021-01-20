resource "null_resource" "install_vpc_controller" {
  provisioner "local-exec" {
    command = "eksctl utils install-vpc-controllers --region ${var.region} --cluster ${var.name} --approve"
  }
}

resource "null_resource" "create_node_group" {
  count      = length(var.worker_groups)
  depends_on = [null_resource.install_vpc_controller]
  provisioner "local-exec" {
    command = <<EOF
eksctl create nodegroup \
--region ${var.region} \
--cluster ${var.name} \
--name ${var.worker_groups[count.index].name} \
--node-type ${var.worker_groups[count.index].instance_type} \
--nodes ${var.worker_groups[count.index].asg_desired_capacity} \
--nodes-min ${var.worker_groups[count.index].asg_min_size} \
--nodes-max ${var.worker_groups[count.index].asg_max_size} \
--node-ami-family WindowsServer2019FullContainer
EOF
  }
  #provisioner "local-exec" {
  #  when    = destroy
  #  command = "eksctl delete nodegroup --cluster=${var.name} --name=${var.worker_groups[count.index].name}"
  #}
}
