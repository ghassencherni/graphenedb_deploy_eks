#----eks-mykveks/variables.tf----

variable "aws_region" {}

variable "mykveks_public_subnets_ids" {
  type = "list"
}

variable "mykveks_public_sg_id" {}
