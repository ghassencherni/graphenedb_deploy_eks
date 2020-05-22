#----networking/variables.tf----

variable "aws_region" {}

variable "graphenedb_vpc_id" {}

variable "public_cidr_subnet" {
  type = "list"
}
