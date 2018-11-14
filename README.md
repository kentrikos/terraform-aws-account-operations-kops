# A Terraform module to create "operations" type of environment.


This module will create an environment suitable for "operations" type of AWS account.
Most important elements of the environment:

* VPC (not created by this module, must exist apriori as it can be only created with a portal)
* Kubernetes cluster (to be used for CI/CD, monitoring, etc.)
* VPC Endpoint - kinesis-streams service (Interface type)
* kinesis stream (logging)
* elasticsearch domain (logging)
* lambda function (logging - integrates kinesis stream to elasticsearch)


## Usage

```hcl
module "ops" {
  source = "https://github.com/kentrikos/terraform-aws-account-operations.git"

  product_domain_name     = "${var.product_domain_name}"
  environment_type        = "${var.environment_type}"

  k8s_private_subnets     = "${var.k8s_private_subnets}"
  azs                     = "${var.azs}"
  vpc_id                  = "${var.vpc_id}"
  region                  = "${var.region}"
  http_proxy              = "${var.http_proxy}"
  kinesis_role_name       = "${var.kinesis_role_name}"
  kinesis_iam_policy_arn  = "${var.kinesis_iam_policy_arn}"
  kinesis_shard_count     = "${var.kinesis_shard_count}"
  elasticsearch_version   = "${var.elasticsearch_version}"
  lambda_iam_policy_arn   = "${var.kinesis_role_name}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azs | Availability Zones for the cluster (1 master per AZ will be deployed) | list | - | yes |
| elasticsearch_version | - | string | `6.3` | no |
| enable_logging | - | string | `true` | no |
| environment_type | Type of environment (e.g. test, int, e2e, prod) | string | - | yes |
| http_proxy | IP[:PORT] - address and optional port of HTTP proxy to be used to download packages | string | - | yes |
| k8s_master_instance_type | Instance type (size) for master nodes | string | `m4.large` | no |
| k8s_masters_extra_iam_policy_arn | ARN of additional, pre-existing IAM policy with permissions for K8s master instances to be used by kops | string | - | yes |
| k8s_masters_iam_policy_arn | ARN of pre-existing IAM policy with permissions for K8s master instances to be used by kops | string | - | yes |
| k8s_node_count | Number of worker nodes | string | `3` | no |
| k8s_node_instance_type | Instance type (size) for worker nodes | string | `m4.large` | no |
| k8s_nodes_iam_policy_arn | ARN of pre-existing IAM policy with permissions for K8s worker instances to be used by kops | string | - | yes |
| k8s_private_subnets | List of private subnets (matching AZs) where to deploy the cluster) | list | - | yes |
| product_domain_name | Name of product domain (e.g. maps) | string | - | yes |
| region | AWS region | string | - | yes |
| vpc_id | ID of VPC where cluster will be deployed | string | - | yes |

