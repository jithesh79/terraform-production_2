variable "region" { type = string }
variable "project_name" { type = string }
variable "vpc_cidr" { type = string, default = "10.10.0.0/16" }

variable "public_subnet_a_cidr" { type = string }
variable "public_subnet_b_cidr" { type = string }
variable "private_subnet_a_cidr" { type = string }
variable "private_subnet_b_cidr" { type = string }

variable "availability_zones" { type = list(string) }

variable "instance_type" { type = string, default = "t3.medium" }
variable "ami_name_filter" { type = string, default = "amzn2-ami-hvm-*-x86_64-gp2" }
variable "key_name" { type = string }

variable "backend_s3_bucket" { type = string }
variable "backend_dynamodb_table" { type = string }

variable "asg_min" { type = number, default = 2 }
variable "asg_max" { type = number, default = 4 }
variable "asg_desired" { type = number, default = 2 }
