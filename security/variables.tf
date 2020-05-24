#----networking/variables.tf----

variable "aws_region" {}

variable "mykveks_vpc_id" {}

variable "public_cidr_subnet" {
  type = "list"
}
