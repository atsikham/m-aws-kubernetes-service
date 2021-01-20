variable "name" {
  description = "Prefix for resource names and tags"
  type        = string
}

variable "region" {
  description = "Region for AWS resources"
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
}
