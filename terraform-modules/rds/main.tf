terraform {
  backend "s3" {}
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.1"

  identifier = "${var.env}-rds"

  engine            = "postgres"
  engine_version    = "15.3"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "eksdb"
  username = "admin"
  password = var.db_password

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  db_subnet_group_name   = module.vpc.database_subnet_group

  publicly_accessible = false

  tags = {
    Environment = var.env
  }
}