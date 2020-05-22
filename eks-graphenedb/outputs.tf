#----eks-graphenedb/outputs.tf----

output "cluster-endpoint" {
  value = "${aws_eks_cluster.graphenedb-cluster.endpoint}"
}

output "cert-auth" {
  value = "${aws_eks_cluster.graphenedb-cluster.certificate_authority.0.data}"
}
