variable "vpc_cidr" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(string)
}

variable "vpc_public_subnets" {
  type = list(string)
}

variable "vpc_tags" {
  type = map(string)
}

variable "environment" {
  type = string
}
