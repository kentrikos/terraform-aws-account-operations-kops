locals {
  cluster_name = "${var.product_domain_name}-${var.environment_type}-ops.k8s.local"

  common_tags = {
    ProjectName = "${var.product_domain_name}"
    Environment = "${var.environment_type}"
    Cluster     = "${local.cluster_name}"
  }
}

# Kubernetes cluster:
module "kubernetes_cluster_operations" {
  source = "github.com/kentrikos/terraform-aws-kops"

  cluster_name_prefix = "${var.product_domain_name}-${var.environment_type}-ops"
  region              = "${var.region}"
  vpc_id              = "${var.vpc_id}"
  azs                 = "${join(",", var.azs)}"
  subnets             = "${join(",", var.k8s_private_subnets)}"
  http_proxy          = "${var.http_proxy}"
  disable_natgw       = "true"

  node_count           = "${var.k8s_node_count}"
  master_instance_type = "${var.k8s_master_instance_type}"
  node_instance_type   = "${var.k8s_node_instance_type}"

  masters_iam_policies_arns = "${var.k8s_masters_iam_policies_arns}"
  nodes_iam_policies_arns   = "${var.k8s_nodes_iam_policies_arns}"
}

module "logging_core_operations" {
  source = "github.com/kentrikos/terraform-aws-logging-core?ref=v0.1-alpha"

  vpc_id                      = "${var.vpc_id}"
  region                      = "${var.region}"
  create_kinesis_vpc_endpoint = "${var.create_kinesis_vpc_endpoint}"
  subnet_ids                  = "${var.k8s_private_subnets}"
  kinesis_stream_name         = "logging.${local.cluster_name}"
  kinesis_role_name           = "logging.${local.cluster_name}"
  kinesis_iam_policy_arns     = "${var.logging_kinesis_iam_policy_arns}"
  kinesis_trusted_role_arns   = "${var.logging_kinesis_trusted_role_arns}"
  lambda_iam_policy_arns      = "${var.logging_lambda_iam_policy_arns}"
  elasticsearch_domain_name   = "${var.product_domain_name}-${var.environment_type}-ops"

  tags = "${local.common_tags}"
}
