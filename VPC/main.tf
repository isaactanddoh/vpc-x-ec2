# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = local.name
  }
}

# Create Public Subnets

resource "aws_subnet" "public1" {
  vpc_id                  = aws_ssm_parameter.vpc_id.value
  cidr_block              = var.public_subnet_cidr1
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.resource_name}-public-subnet-1"
  }
  availability_zone = var.azs[0]
  depends_on        = [aws_vpc.main]
}
resource "aws_subnet" "public2" {
  vpc_id                  = aws_ssm_parameter.vpc_id.value
  cidr_block              = var.public_subnet_cidr2
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.resource_name}-public-subnet-2"
  }
  availability_zone = var.azs[1]
  depends_on        = [aws_vpc.main]
}


# Create Private Subnets

resource "aws_subnet" "private1" {
  vpc_id     = aws_ssm_parameter.vpc_id.value
  cidr_block = var.private_subnet_cidr1
  tags = {
    Name = "${local.resource_name}-private-subnet-1"
  }
  availability_zone = var.azs[0]
  depends_on        = [aws_vpc.main]
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_ssm_parameter.vpc_id.value
  cidr_block = var.private_subnet_cidr2
  tags = {
    Name = "${local.resource_name}-private-subnet-2"
  }
  availability_zone = var.azs[1]
  depends_on        = [aws_vpc.main]
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_ssm_parameter.vpc_id.value
  tags = {
    Name = "${local.resource_name}-IGW"
  }
  depends_on = [ aws_vpc.main ]
}


# Create EIP and NAT Gateway for private subnet #

# EIP for NGW
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${local.resource_name}-EIP"
  }
}

# Associate the Elastic IP with the NAT gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_ssm_parameter.eip_id.value
  subnet_id     = aws_subnet.public1.id
  tags = {
    Name = "${local.resource_name}-NAT-GW"
  }
  depends_on = [aws_internet_gateway.igw, aws_subnet.public1, aws_subnet.public2]
}

# Route Table Association for the private subnet

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_ssm_parameter.vpc_id.value
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_ssm_parameter.ngw_id.value
  }
  tags = {
    Name = "${local.resource_name}-Private-RTB"
  }
  depends_on = [ aws_nat_gateway.ngw, aws_vpc.main, aws_subnet.private1, aws_subnet.private2 ]
}

# Route Table Association for the private subnet1
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_ssm_parameter.private_rtb_id.value
  depends_on = [ aws_route_table.private_rtb, aws_subnet.private1,]
}

# Route Table Association for the private subnet2
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_ssm_parameter.private_rtb_id.value
  depends_on = [ aws_route_table.private_rtb, aws_subnet.private2 ]
}


# Route Routes for Public RTB

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_ssm_parameter.vpc_id.value
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_ssm_parameter.igw_id.value
  }
  tags = {
    Name = "${local.resource_name}-Public-RTB"
  }
  depends_on = [ aws_internet_gateway.igw, aws_vpc.main, aws_subnet.public1, aws_subnet.public2 ]
}

# Route Table Association for the public subnet1

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_ssm_parameter.public_rtb_id.value
  depends_on = [ aws_route_table.public_rtb, aws_subnet.public1 ]
}

# Route Table Association for the public subnet2
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_ssm_parameter.public_rtb_id.value
  depends_on = [ aws_route_table.public_rtb, aws_subnet.public1 ]
}

# Create an Application Load Balancer Security Group
resource "aws_security_group" "load_balancer_sg" {
  name        = "${local.resource_name}-alb-sg"
  description = "Security group for load balancer"
  vpc_id      = aws_ssm_parameter.vpc_id.value
  depends_on = [ aws_vpc.main ]
  tags = {
      Name = "${local.resource_name}-ALB-SG"
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  } 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Autoscaling Security Group
resource "aws_security_group" "autoscaling_sg" {
  name        = "${local.resource_name}-asg-sg"
  description = "Security group for autoscaling group instances"
  vpc_id      = aws_ssm_parameter.vpc_id.value
  depends_on = [ aws_vpc.main ]

  tags = {
    Name = "${local.resource_name}-ASG-SG"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_ssm_parameter.alb_sg_id.value]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_ssm_parameter.alb_sg_id.value]

        }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
}