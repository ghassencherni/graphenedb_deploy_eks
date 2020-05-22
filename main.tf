#----root/main.tf----

provider "aws" {
  region = "${var.aws_region}"
}

# Deploy Networking: VPC, Subnets, Internet gateway,...
module "networking" {
  source              = "./networking"
  aws_region          = "${var.aws_region}"
  vpc_cidr            = "${var.vpc_cidr}"
  public_cidr_subnet  = "${var.public_cidr_subnet}"
}

# Deploy Security Groups
module "security" {
  source              = "./security"
  aws_region          = "${var.aws_region}"
  graphenedb_vpc_id    = "${module.networking.graphenedb_vpc_id}"
  public_cidr_subnet  = "${var.public_cidr_subnet}"
}

# Deploy the EKS cluster  
module "eks-graphenedb" {
  source                       = "./eks-graphenedb"
  aws_region                   = "${var.aws_region}"
  graphenedb_public_subnets_ids = "${module.networking.graphenedb_public_subnets_ids}"
  graphenedb_public_sg_id       = "${module.security.graphenedb_public_sg_id}"
}
