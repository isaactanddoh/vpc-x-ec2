variable "instance_type" {
  description = "Preferred AWS instance type"
  type        = string
  default     = "t2.micro"

}


variable "asg_name" {
  description = "asg for  the app server"
  type        = string
  default     = "app-asg"
}

variable "alb_name" {
  description = "alb for the app server"
  type        = string
  default     = "app-alb"
}

variable "ec2_tag" {
  description = "ec2 name tag"
  type        = string
  default     = "web-server"
}

# Configure Default name for Aplication resources
variable "resource_name" {
  description = "Default name for resources"
  type        = string
  default     = "isaac-jomacs-ce"
}

variable "tg-protocol" {
  type    = string
  default = "HTTP"
}

variable "tg-port" {
  type    = number
  default = 80
}

variable "asg-size" {
  type    = number
  default = 2
}

variable "user_data_script" {
  type    = string
  default = "user_data.sh"
}