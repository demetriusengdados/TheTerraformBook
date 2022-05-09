provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "examplecom-remote-state-consul"
    key    = "terraform.tfstate"
  }
}

module "vpc_basic" {
  source        = "github.com/turnbullpress/tf_vpc_basic.git?ref=v0.0.1"
  name          = "consul"
  cidr          = var.vpc_cidr
  public_subnet = var.public_subnet
}

module "consul" {
  source           = "github.com/turnbullpress/tf_consul.git"
  environment      = var.environment
  token            = var.token
  encryption_key   = var.encryption_key
  vpc_id           = module.vpc_basic.vpc_id
  public_subnet_id = module.vpc_basic.public_subnet_id
  region           = var.region
  key_name         = var.key_name
  private_key_path = var.private_key_path
}

