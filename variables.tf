#### PROVIDERS ####

variable "kafka_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

#### VPC ####

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  default     = "10.0.2.0/24"
}

#### INSTANCES ####

variable "key_name" {
  description = "Key Pair"
  default     = "kafka_keypair"
}

variable "aws_instance_type" {
  description = "The AWS Instance Type."
  default     = "t2.small"
}

variable "aws_ami" {
  description = "The AWS AMI."
  default     = "ami-040ba9174949f6de4"
}

variable "instance_prefix" {
  default     = "prod"
}

variable "pub_instance_count" {
  type = number
  default = 2
}

variable "pri_instance_count" {
  type = number
  default = 2
}





