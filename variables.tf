variable "product_domain_name" {
  description = "Name of product domain (e.g. maps)"
}

variable "environment_type" {
  description = "Type of environment (e.g. test, int, e2e, prod)"
}

variable "vpc_id" {
  description = "ID of VPC where cluster will be deployed"
}

variable "region" {
  description = "AWS region"
}

variable "azs" {
  description = "Availability Zones for the cluster (1 master per AZ will be deployed)"
  type        = "list"
}

variable "k8s_private_subnets" {
  description = "List of private subnets (matching AZs) where to deploy the cluster)"
  type        = "list"
}

variable "k8s_node_count" {
  description = "Number of worker nodes"
  default     = "3"
}

variable "k8s_master_instance_type" {
  description = "Instance type (size) for master nodes"
  default     = "m4.large"
}

variable "k8s_node_instance_type" {
  description = "Instance type (size) for worker nodes"
  default     = "m4.large"
}

variable "http_proxy" {
  description = "IP[:PORT] - address and optional port of HTTP proxy to be used to download packages"
}

variable "enable_logging" {
  default = true
}

variable "elasticsearch_version" {
  default = "6.3"
}

variable "k8s_masters_iam_policy_arn" {
  description = "ARN of pre-existing IAM policy with permissions for K8s master instances to be used by kops"
}

variable "k8s_masters_extra_iam_policy_arn" {
  description = "ARN of additional, pre-existing IAM policy with permissions for K8s master instances to be used by kops"
}

variable "k8s_nodes_iam_policy_arn" {
  description = "ARN of pre-existing IAM policy with permissions for K8s worker instances to be used by kops"
}
