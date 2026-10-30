variable "region" {
  description = "AWS Region for all resources"
  type        = string
  default     = "ap-south-1"
}

variable "student_name" {
  description = "Student name used for resource tags"
  type        = string
  default     = "Student"
}

variable "admin_cidr" {
  description = "Your current public IPv4 address with /32, e.g. 203.0.113.7/32"
  type        = string
  validation {
    condition     = can(cidrhost(var.admin_cidr, 0)) && can(regex("/32$", var.admin_cidr))
    error_message = "admin_cidr must be a valid IPv4 CIDR ending in /32."
  }
}

variable "public_key_path" {
  description = "Local path to your SSH public key (not the private key)"
  type        = string
}

variable "instance_type" {
  description = "Small EC2 instance type; check regional pricing and eligibility first"
  type        = string
  default     = "t3.micro"
}
