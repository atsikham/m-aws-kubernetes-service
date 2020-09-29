variable "name" {
  description = "Prefix for resource names"
  type        = string
  default     = "default"
}

variable "k8s_version" {
  description = "Kubernetes version to install"
  type        = string
  default     = "1.17"
}

variable "vpc_id" {
  description = "VPC id to join to"
  type        = string
}

variable "worker_groups" {
  description = "Worker groups definition list"
  type        = list(object({
    name                 = string
    instance_type        = string
    asg_desired_capacity = number
    asg_min_size         = number
    asg_max_size         = number
  }))
  default     = [
    {
      name                 = "default_wg"
      instance_type        = "t2.small"
      asg_desired_capacity = 1
      asg_min_size         = 1
      asg_max_size         = 1
    }
  ]
}

variable "region" {
  description = "Region for AWS resources"
  type        = string
}

# The cluster autoscaler major and minor versions must match your cluster.
# For example if you are running a 1.16 EKS cluster set version to v1.16.5
# See https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/autoscaling.md#notes
variable "autoscaler_version" {
  description = "EKS autoscaler image tag"
  type        = string
  default     = "v1.17.3"
}

variable "autoscaler_name" {
  description = "EKS Autoscaler name"
  type        = string
  default     = "eks-autoscaler"
}

variable "autoscaler_chart_version" {
  description = "EKS chart version"
  type        = string
  default     = "7.3.4"
}

# https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#how-does-scale-down-work
variable "autoscaler_scale_down_utilization_threshold" {
  description = "Node utilization level, defined as sum of requested resources divided by capacity"
  type        = string
  default     = "0.65"
}
