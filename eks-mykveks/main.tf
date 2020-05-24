#----eks-mykveks/main.tf----
#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EKS Cluster and Node group
#

###### POLICIES
# Create the IAM role for our EKS Cluster
resource "aws_iam_role" "mykveks-cluster" {
  name = "mykveks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Create the IAM role for our worker nodes
resource "aws_iam_role" "mykveks-nodes" {
  name = "mykveks-nodes-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

###### ATTACH POLICIES TO OUR CLUSTER AND WORKER NODES IAM ROLES
# Attach the EKS Cluster Policy to our Cluster IAM role
resource "aws_iam_role_policy_attachment" "mykveks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.mykveks-cluster.name}"
}

# Attach the EKS Service Policy to our Cluster IAM role
resource "aws_iam_role_policy_attachment" "mykveks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.mykveks-cluster.name}"
}

# Attach the EKS Worker Policy to our worker nodes IAM role
resource "aws_iam_role_policy_attachment" "mykveks-nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.mykveks-nodes.name}"
}

# Attach the EKS CNI Policy to our worker nodes IAM role
resource "aws_iam_role_policy_attachment" "mykveks-nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.mykveks-nodes.name}"
}

# Attach the EC2 Container Registry ReadOnly Policy to our worker nodes IAM role ( Future need ) 
# Will not be used, in our case we will pull etcd , prometheus and grafana images form docker registry
resource "aws_iam_role_policy_attachment" "mykveks-nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.mykveks-nodes.name}"
}

# BUILDING EKS 
# Create the EKS Cluster
resource "aws_eks_cluster" "mykveks-cluster" {
  name     = "mykveks-cluster"
  role_arn = "${aws_iam_role.mykveks-cluster.arn}"

  vpc_config {
    security_group_ids = ["${var.mykveks_public_sg_id}"]
    subnet_ids         = ["${var.mykveks_public_subnets_ids}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.mykveks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.mykveks-cluster-AmazonEKSServicePolicy",
  ]
}

# Create the Node Group 
resource "aws_eks_node_group" "mykveks-nodes" {
  cluster_name    = "${aws_eks_cluster.mykveks-cluster.name}"
  node_group_name = "mynodegroup"
  node_role_arn   = "${aws_iam_role.mykveks-nodes.arn}"
  subnet_ids      = ["${var.mykveks_public_subnets_ids}"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  
  ## Optional: Allow external changes without Terraform plan difference
  ##Ignores any changes to that count caused externally (e.g. Application Autoscaling). ( terraform doc ) 
  #lifecycle {
  #  ignore_changes = [scaling_config[0].desired_size]
  #}
  
  depends_on = [
    "aws_iam_role_policy_attachment.mykveks-nodes-AmazonEKSWorkerNodePolicy",
    "aws_iam_role_policy_attachment.mykveks-nodes-AmazonEKS_CNI_Policy",
    "aws_iam_role_policy_attachment.mykveks-nodes-AmazonEC2ContainerRegistryReadOnly",
  ]
}
