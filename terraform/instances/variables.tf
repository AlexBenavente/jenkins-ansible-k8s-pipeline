variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = "ami-04cb4ca688797756f"
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "JenkinsServer"
}

variable "key_name" {
  description = "value of the key name"
  type        = string
  default     = "Jenkins_key"
}
