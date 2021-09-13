data "aws_eks_cluster" "cluster" {
  name = module.aws_eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.aws_eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "aws_eks" {

  source          = "terraform-aws-modules/eks/aws"
  version         = "17.18.0"
  cluster_name    = "${var.environment}-${var.kubernetes_cluster_name}"
  cluster_version = var.kubernetes_cluster_version
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id
  worker_groups = [
    {
      name                 = "worker-group-1"
      instance_type        = "t3.medium"
      asg_desired_capacity = 1
    }
  ]
  worker_additional_security_group_ids = [aws_security_group.port_80.id, aws_security_group.port_443.id]
  cluster_enabled_log_types            = var.kubernetes_cluster_enabled_log_types
  tags = merge(
    { environment : var.environment },
    var.eks_tags
  )
  depends_on = [module.vpc]
}

