#-----networking/outputs.tf----

output "graphenedb_vpc_id" {
  value = "${aws_vpc.graphenedb_vpc.id}"
}

output "graphenedb_public_subnets_ids" {
  value = "${aws_subnet.graphenedb_public_subnet.*.id}"
}

