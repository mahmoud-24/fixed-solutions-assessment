module "vpc" {
source = "./vpc"
vpc_cidr = "10.0.0.0/16"
}
module "public_us_east_1a" {
  source = "./subnet"
  vpc-id = module.vpc.vpc_id
  subnet_cidr = "10.0.0.0/24"
  zone = "us-east-1a"
  subtype = "true"
}
module "public_us_east_1b" {
  source = "./subnet"
  vpc-id = module.vpc.vpc_id
  subnet_cidr = "10.0.1.0/24"
  zone = "us-east-1b"
  subtype = "true"
}
module "networkconf" {
  source = "./gateway"
  aws_vpc_id = module.vpc.vpc_id
  #aws_subnet-public-1 = module.public_us_east_1b.subnet_id
}
module "network-z1" {
  source = "./route"
  aws_vpc_id = module.vpc.vpc_id
  aws_internet_gateway = module.networkconf.aws_internet_gateway_id
  #aws_nat_gateway = module.networkconf.aws_nat_gateway_id
  aws_subnet-public-1 = module.public_us_east_1a.subnet_id
  destination_cidr_block = "0.0.0.0/0"
  #aws_subnet-private-1 = module.private-subnet-z1.subnet_id
}
module "network-z2" {
  source = "./route"
  aws_vpc_id = module.vpc.vpc_id
  aws_internet_gateway = module.networkconf.aws_internet_gateway_id
  #aws_nat_gateway = module.networkconf.aws_nat_gateway_id
  aws_subnet-public-1 = module.public_us_east_1b.subnet_id
  destination_cidr_block = "0.0.0.0/0"
  #aws_subnet-private-1 = module.private-subnet-z2.subnet_id
}
module "cluster_module" {
  source = "./cluster"
  public_us_east_1a_id = module.public_us_east_1a.subnet_id
  public_us_east_1b_id = module.public_us_east_1b.subnet_id
  vpc_id = module.vpc.vpc_id
}
module "pub-ec2" {
  source    = "./ec2"
  subnet_id = module.public_us_east_1a.subnet_id
}