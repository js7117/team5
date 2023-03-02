# Define variables to be called in main.tf

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
}

variable "destination_cidr_block" {
  type        = string
  description = "Destination CIDR Block"
}

variable "tags" {
  type        = map(string)
  description = "Byte Squad Signature Tag"
}

