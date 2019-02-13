locals {
  cluster_name = "${var.product_domain_name}-${var.environment_type}-ops.k8s.local"

  common_tags = {
    ProjectName = "${var.product_domain_name}"
    Environment = "${var.environment_type}"
    Cluster     = "${local.cluster_name}"
  }

  local_master_policies_arns_list = "${list(
  "arn:aws:iam::${var.operations_aws_account_number}:policy/masters.${var.region}-${var.product_domain_name}-${var.environment_type}-ops.k8s.local",
  "arn:aws:iam::${var.operations_aws_account_number}:policy/masters_extra.${var.region}-${var.product_domain_name}-${var.environment_type}-ops.k8s.local"
  )}"

  local_nodes_policies_arns_list = "${list(
  "arn:aws:iam::${var.operations_aws_account_number}:policy/nodes.${var.region}-${var.product_domain_name}-${var.environment_type}-ops.k8s.local",
  "arn:aws:iam::${var.operations_aws_account_number}:policy/KENTRIKOS_${var.region}.${var.product_domain_name}-${var.environment_type}_AssumeCrossAccount"
  )}"

  masters_iam_policies_arns = "${length(element(concat(var.k8s_masters_iam_policies_arns,list("")),0)) != 0 ? var.k8s_masters_iam_policies_arns : local.local_nodes_policies_arns_list}"
  nodes_iam_policies_arns   = "${length(element(concat(var.k8s_masters_iam_policies_arns,list("")),0)) != 0 ? var.k8s_masters_iam_policies_arns : local.local_nodes_policies_arns_list}"

  //  masters_iam_policies_arns = "${length(var.k8s_masters_iam_policies_arns) != 0 ? var.k8s_masters_iam_policies_arns : data.terraform_remote_state.iam.master_policies}"
  //  nodes_iam_policies_arns = "${length(var.k8s_masters_iam_policies_arns) != 0 ? var.k8s_masters_iam_policies_arns : data.terraform_remote_state.iam.master_policies}"
}

//data "terraform_remote_state" "iam" {
//  backend = "s3"
//  config {
//    bucket = "tf-${var.application_aws_account_number}-ops-${var.region}-${var.product_domain_name}-${var.environment_type}"
//    key    = "tf/tf-aws-product-domain-${var.product_domain_name}-env-${var.environment_type}/iam/terraform.tfstate"
//    region = "${var.region}"
//  }
//
//}

# Kubernetes cluster:
module "kubernetes_cluster_operations" {
  source = "github.com/kentrikos/terraform-aws-kops?ref=multi_deployment"

  cluster_name_prefix = "${var.region}-${var.product_domain_name}-${var.environment_type}-ops"
  region              = "${var.region}"
  vpc_id              = "${var.vpc_id}"
  azs                 = "${join(",", var.azs)}"
  subnets             = "${join(",", var.k8s_private_subnets)}"
  http_proxy          = "${var.http_proxy}"
  disable_natgw       = "true"

  node_count           = "${var.k8s_node_count}"
  master_instance_type = "${var.k8s_master_instance_type}"
  node_instance_type   = "${var.k8s_node_instance_type}"
  aws_ssh_keypair_name = "${var.k8s_aws_ssh_keypair_name}"
  linux_distro         = "${var.k8s_linux_distro}"

  masters_iam_policies_arns = "${local.masters_iam_policies_arns}"
  nodes_iam_policies_arns   = "${local.nodes_iam_policies_arns}"
}

# ECR registry for customized JenkinsX image:
resource "aws_ecr_repository" "jenkins-x-image" {
  name = "${var.product_domain_name}-${var.environment_type}-jenkins-x-image"
}
