data "aws_availability_zones" "available" {}

module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  cidr               = var.vpc_cidr
  azs                = data.aws_availability_zones.available.names
  private_subnets    = var.vpc_private_subnets
  public_subnets     = var.vpc_public_subnets
  enable_nat_gateway = false
  vpc_tags = merge(
    { environment : var.environment },
    var.vpc_tags
  )
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.environment}-${var.kubernetes_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                                         = 1
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.environment}-${var.kubernetes_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                                                  = 1
  }
}

resource "aws_security_group" "port_80" {
  name_prefix = "port_80"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [module.vpc]
}

resource "aws_security_group" "port_443" {
  name_prefix = "port_443"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [module.vpc]
}
