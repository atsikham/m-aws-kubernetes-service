locals {
  worker_groups = [
    for wg in var.worker_groups:
    merge(
      wg,
      {
        tags = [
          {
            key                 = "k8s.io/cluster-autoscaler/enabled"
            propagate_at_launch = "false"
            value               = "true"
          },
          {
            key                 = "k8s.io/cluster-autoscaler/${var.name}-eks"
            propagate_at_launch = "false"
            value               = "true"
          }
        ]
      }
    )
  ]
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "12.2.0"
  cluster_name    = "${var.name}-eks"
  cluster_version = var.k8s_version
  subnets         = var.subnets
  vpc_id          = var.vpc_id
  worker_groups   = local.worker_groups
  tags = {
    cluster_name = var.name
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
