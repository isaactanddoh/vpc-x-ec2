#Select existing VPC with filter word jomacs
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["*jomacs*"]
  }
}


# Filter out Private subnets in az1a
data "aws_subnet" "private1" {
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

# Filter out Private subnets in az1b
data "aws_subnet" "private2" {
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1b"]
  }
}

# Filter out Public subnets in az1a
data "aws_subnet" "public1" {
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

# Filter out Public subnets in az1b
data "aws_subnet" "public2" {
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1b"]
  }
}

# Select latest  available version of Ubuntu for use as a base image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Select existing ALB SG
data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:Name"
    values = ["*ALB-SG*"]
  }
}

# Select existing ASG SG
data "aws_security_group" "asg_sg" {
  filter {
    name   = "tag:Name"
    values = ["*ASG-SG*"]
  }
}


#  Select EC2 User_data in from local machine for use in Launch Template
data "template_file" "user_data_script" {
  template = filebase64("${path.module}/userdata.sh")
}


# Existing IAM instance profile for EC2
data "aws_iam_role" "EC2Role" {
  name = "EC2Role"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/isaac-jomacs-ce/ue1/subnets/private_subnet_ids"
}