#----security/output.tf----

output "graphenedb_public_sg_id" {
  value = "${aws_security_group.graphenedb_public_sg.id}"
}

#output "aws_iam_server_certificate_id" {
#  value = "${aws_iam_server_certificate.graphenedb_server_cert.arn}"
#}

