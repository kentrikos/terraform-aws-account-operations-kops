variable "product_domain_name" {
  description = "Name of product domain (e.g. maps)"
}

variable "environment_type" {
  description = "Type of environment (e.g. test, int, e2e, prod)"
}

variable "vpc_id" {
  description = "ID of existing VPC where cluster will be deployed"
}

variable "region" {
  description = "AWS region"
}

variable "azs" {
  description = "Availability Zones for the cluster (1 master per AZ will be deployed)"
  type        = "list"
}

variable "k8s_private_subnets" {
  description = "List of private subnets (matching AZs) where to deploy the cluster (required if existing VPC is used)"
  type        = "list"
}

variable "k8s_node_count" {
  description = "Number of worker nodes in Kubernetes cluster"
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

variable "k8s_masters_iam_policies_arns" {
  description = "List of existing IAM policies that will be attached to instance profile for master nodes (EC2 instances)"
  type        = "list"
}

variable "k8s_nodes_iam_policies_arns" {
  description = "List of existing IAM policies that will be attached to instance profile for worker nodes (EC2 instances)"
  type        = "list"
}

variable "http_proxy" {
  description = "IP[:PORT] - address and optional port of HTTP proxy to be used to download packages"
}

variable "logging_lambda_iam_policy_arns" {
  description = "List of existing IAM policies that will be attached to lambda function for shipping cluster logs"
  type        = "list"
}

variable "logging_kinesis_iam_policy_arns" {
  description = "List of existing IAM policies that will allow access to the Kinesis stream for logging"
  type        = "list"
}

variable "logging_kinesis_trusted_role_arns" {
  description = "List of existing IAM roles that will be trusted by the Kinesis IAM role for logging"
  type        = "list"
}

#variable "enable_logging" {
#  default = true
#}
#
#variable "elasticsearch_version" {
#  default = "6.3"
#}

