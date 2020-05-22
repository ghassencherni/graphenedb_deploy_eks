#----eks-graphenedb/variables.tf----

variable "aws_region" {}

variable "graphenedb_public_subnets_ids" {
  type = "list"
}

variable "graphenedb_public_sg_id" {}
