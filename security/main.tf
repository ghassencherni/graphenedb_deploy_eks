#----security/main.tf----

# Creation of the public security group 
resource "aws_security_group" "mykveks_public_sg" {
  name        = "mykveks_public_sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.mykveks_vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "mykveks-cluster-ingress-workstation-https" {
  # it's highly recommended to set IP of our jenkins instance in order to interract with you cluster (ex: kubctl, helm, ..) , for this assement I will allow all IPs
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.mykveks_public_sg.id}"
  to_port           = 443
  type              = "ingress"
}

