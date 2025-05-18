variable "aws_region" {
  description = "The AWS Region where we want deploy the services"
  type        = string
  default     = "eu-west-3"
  validation {
    condition     = startswith(var.aws_region, "eu-")
    error_message = "The region must in EUROPE"
  }
}

variable "tags" {
  description = "The tags that we apply on services"
  type = object({
    Owner   = string
    Project = string
  })
  default = {
    Owner   = "Michael"
    Project = "TP1"
  }
}