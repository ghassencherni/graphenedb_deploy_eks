#-----networking/outputs.tf----

output "mykveks_vpc_id" {
  value = "${aws_vpc.mykveks_vpc.id}"
}

output "mykveks_public_subnets_ids" {
  value = "${aws_subnet.mykveks_public_subnet.*.id}"
}

