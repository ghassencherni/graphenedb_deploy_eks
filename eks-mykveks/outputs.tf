#----eks-mykveks/outputs.tf----

output "cluster-endpoint" {
  value = "${aws_eks_cluster.mykveks-cluster.endpoint}"
}

output "cert-auth" {
  value = "${aws_eks_cluster.mykveks-cluster.certificate_authority.0.data}"
}
