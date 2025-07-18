terraform {
  backend "s3" {
    bucket         = "zptfstate001"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "aws" { region = "us-east-1" }

module "vpc" { 
  source = "../../modules/vpc"
  env = "dev" 
}
module "iam" { source = "../../modules/iam" }
module "ecs" {
  source              = "../../modules/ecs"
  env                 = "dev"
  execution_role_arn  = module.iam.ecs_exec_role_arn
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  lb_sg_id            = module.vpc.lb_sg_id
  service_sg_id       = module.vpc.service_sg_id
  app1_image          = "147997138755.dkr.ecr.us-east-1.amazonaws.com/appointment"
  app2_image          = "147997138755.dkr.ecr.us-east-1.amazonaws.com/patient"
}

