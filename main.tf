module "vpc-public-private" {
  source  = "yurymkomarov/vpc-public-private/aws"
  version = "1.0.5"

  name                        = var.name
  create_vpc                  = var.create_vpc
  all_availability_zones      = var.vpc_all_availability_zones
  create_nat_gateway          = var.vpc_create_nat_gateway
  nat_gateway_for_each_subnet = var.vpc_nat_gateway_for_each_subnet
  cidr_block                  = var.vpc_cidr_block
  flow_log_enable             = var.vpc_flow_log_enable
  flow_log_destination        = var.vpc_flow_log_destination
}

module "ssh-bastion" {
  source  = "yurymkomarov/ssh-bastion/aws"
  version = "1.0.2"

  name               = var.name
  vpc_id             = module.vpc-public-private.vpc["id"]
  vpc_subnets        = module.vpc-public-private.subnets["public"][*]["id"]
  ingress_cidr_block = var.ssh_bastion_ingress_cidr_block
  instance_type      = var.ssh_bastion_instance_type
}

module "route53-hosted-zone" {
  source  = "yurymkomarov/route53-hosted-zone/aws"
  version = "1.1.1"

  name               = var.name
  create_hosted_zone = var.route53_create_hosted_zone
  hosted_zone_name   = var.route53_hosted_zone_name
}

module "acm" {
  source  = "yurymkomarov/acm/aws"
  version = "1.0.2"

  name        = var.name
  domain_name = module.route53-hosted-zone.route53_zone["name"]
}
