#----root/outputs.tf----
resource "local_file" "kubeconfig" {
  content = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${module.eks-graphenedb.cluster-endpoint}
    certificate-authority-data: ${module.eks-graphenedb.cert-auth}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "graphenedb-cluster"
KUBECONFIG

  filename = "config"
}


