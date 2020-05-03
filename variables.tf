terraform {
  experiments = [variable_validation]
}

# common variables
variable "name" {
  type        = string
  description = "Name that will be used in resources names and tags."
  default     = "wordpress-ha"
}

# vpc-public-private module variables
variable "create_vpc" {
  type        = bool
  description = "Create personal VPC."
  default     = true
}
variable "vpc_all_availability_zones" {
  type        = bool
  description = "Use all Availability Zones in the VPC. Will use 2 AZ if \"false\"."
  default     = true
}
variable "vpc_create_nat_gateway" {
  type        = bool
  description = "Create NAT Gateway."
  default     = false
}
variable "vpc_nat_gateway_for_each_subnet" {
  type        = bool
  description = "Create NAT Gateway for each subnet. Will create 1 NAT Gateway if \"false\"."
  default     = false
}
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"

  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/(1[6-9]|2[0-8]))$", var.vpc_cidr_block))
    error_message = "CIDR block parameter must be in the form x.x.x.x/16-28."
  }
}
variable "vpc_flow_log_enable" {
  type        = bool
  description = "Enable Flow log for VPC."
  default     = true
}
variable "vpc_flow_log_destination" {
  type        = string
  description = "Provides a VPC/Subnet/ENI Flow Log to capture IP traffic for a specific network interface, subnet, or VPC."
  default     = "cloudwatch"

  validation {
    condition     = contains(["cloudwatch", "s3"], var.vpc_flow_log_destination)
    error_message = "Logs can be sent only to a CloudWatch Log Group or a S3 Bucket."
  }
}

# ssh-bastion module variables
variable "ssh_bastion_ingress_cidr_block" {
  type        = string
  description = "The CIDR IP range that is permitted to SSH to bastion instance. Note: a value of 0.0.0.0/0 will allow access from ANY IP address."
  default     = "0.0.0.0/0"

  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/(0|[1-9]|1[0-9]|2[0-9]|3[0-2]))$", var.ssh_bastion_ingress_cidr_block))
    error_message = "CIDR parameter must be in the form x.x.x.x/0-32."
  }
}
variable "ssh_bastion_instance_type" {
  type        = string
  description = "The instance type of the EC2 instance."
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium", "t3.large", "t3.xlarge", "t3.2xlarge"], var.ssh_bastion_instance_type)
    error_message = "Must be a valid Amazon EC2 instance type."
  }
}

# route53-hosted-zone module variables
variable "route53_hosted_zone_name" {
  type        = string
  description = "The name of the hosted zone."
}
variable "route53_create_hosted_zone" {
  type        = bool
  description = "Create or use existed Route53 Hosted Zone."
  default     = true
}

