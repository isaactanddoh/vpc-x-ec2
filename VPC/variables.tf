# Declare Default Region
variable "region" {
  description = "Region for my resources"
  type        = string
  default = "us-east-1"
}


# Declare VPC CIDR
variable "vpc_cidr" {
  description = "The VPC cidr to use for network"
  type        = string
  default     = "7.0.0.0/16"
}

# Configure Public Subnet1 CIDR
variable "public_subnet_cidr1" {
  description = "The private subnet of cider"
  type        = string
  default     = "7.0.0.0/24"
}

# Configure Public Subnet2 CIDR
variable "public_subnet_cidr2" {
  description = "The private subnet of cider"
  type        = string
  default     = "7.0.1.0/24"
}

# Configure Private Subnet1 CIDR
variable "private_subnet_cidr1" {
  description = "The private subnet of cider"
  type        = string
  default     = "7.0.2.0/24"
}

# Declare Private Subnet2 CIDR
variable "private_subnet_cidr2" {
  description = "The private subnet of cider"
  type        = string
  default     = "7.0.3.0/24"
}

# Declare Default name for Network resources
variable "resource_name" {
  description = "Default name for resources"
  type        = string
  default     = "isaac-jomacs-ce"
}

# Declare Default AZ
variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
