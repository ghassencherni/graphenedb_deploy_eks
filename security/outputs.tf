#----security/output.tf----

output "mykveks_public_sg_id" {
  value = "${aws_security_group.mykveks_public_sg.id}"
}

#output "aws_iam_server_certificate_id" {
#  value = "${aws_iam_server_certificate.mykveks_server_cert.arn}"
#}

