variable "vpc_name" {
  description = "The VPC name"
  type        = string
  default     = "vpc"
}
variable "vpc_cidr" {
  description = "The CIDR for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "The list of the CIDR for the public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "The list of the CIDR for the private subnets"
  type        = list(string)
}

variable "azs" {
  description = "The list of the Availability Zones"
  type        = list(string)
}

variable "enable_nat" {
  description = "Activate the nat gateway"
  type        = bool
  default     = false
}

variable "tags" {
  description = "The tags that we apply on services"
  type = object({
    Owner   = string
    Project = string
  })
}