#----networking/main.tf----

# Allows access to the list of AWS Availability within the region configured in the provider
data "aws_availability_zones" "available" {}

# Creation of the Custom VPC
resource "aws_vpc" "graphenedb_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "graphenedb_vpc"
  }
}

# Creation of Internet gateway and attach it to our new VPC
resource "aws_internet_gateway" "graphenedb_netgate" {
  vpc_id = "${aws_vpc.graphenedb_vpc.id}"

  tags {
    Name = "graphenedb_netgate"
  }
}

# Creation  of the public route table ( associated with the internet gateway ) and defining the route to the internet
resource "aws_route_table" "graphenedb_pub_rt" {
  vpc_id = "${aws_vpc.graphenedb_vpc.id}"

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.graphenedb_netgate.id}"
  }

  tags {
    Name = "graphenedb_pub_rt"
  }
}


# Creation of the public subnest reserved for our EKS: at least EKS needs two subnets
resource "aws_subnet" "graphenedb_public_subnet" {
  count                   = 2
  vpc_id                  = "${aws_vpc.graphenedb_vpc.id}"
  cidr_block              = "${var.public_cidr_subnet[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "graphenedb_public_subnet_${count.index + 1}"
    
    # The Cloud Controller Manager and ALB Ingress Controller both require the following tag set to 1
    "kubernetes.io/role/elb" = "1"

    "KubernetesCluster" = "graphenedb-cluster"
  }
}

# Associate our public subnets to the public route table 
resource "aws_route_table_association" "public_rt_assoc" {
  count          = 2
  subnet_id      = "${aws_subnet.graphenedb_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.graphenedb_pub_rt.id}"
}


