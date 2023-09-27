variable "vpc_name" {
  description = "The name for the VPC"
  type        = string
  default     = "lab-vpc"
}

variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "value of the availability zones"
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "public_subnet_cidr" {
  description = "value of the public subnet cidr blocks"
  type        = list(string)
  default     = ["10.0.0.0/17"]
}

variable "private_subnet_cidr" {
  description = "value of the private subnet cidr blocks"
  type        = list(string)
  default     = ["10.0.128.0/17"]
}
