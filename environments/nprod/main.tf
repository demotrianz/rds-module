provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

terraform {
    backend "s3" {
        bucket = "terra001bucket"
        key = "terraform.tfstate"
        region = "us-east-1"
        // profile = "nprod"
        access_key = "AKIAZGBKAQECPDWRAY7S"
        secret_key = "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"
    }
}

module "rds_instance" {
  source = "../../modules/rds_db_instance"

  rds_instance_identifier   = "${var.rds_instance_identifier}"
  storage_type              = "${var.storage_type}"
  storage_encrypted         = "${var.storage_encrypted}"
  allocated_storage         = "${var.allocated_storage}"
  engine                    = "${var.engine}"
  engine_version            = "${var.engine_version}"
  instance_class            = "${var.instance_class}"
  database_name             = "${var.database_name}"
  database_user             = "${var.database_user}"
  database_password         = "${var.database_password}"
  family                    = "${var.family}"
  parameter_group_name      = "${module.rds_instance.this_db_parameter_group_id}"
  db_subnet_group_name      = "${module.rds_instance.this_db_subnet_group_id}"
  #vpc_security_group_ids    = ["${module.rds_instance.aws_security_group.rds.id}"]
  option_group_name         = "${module.rds_instance.this_db_option_group_id}"
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  multi_az                  = "${var.multi_az}"
  final_snapshot_identifier = "${var.final_snapshot_identifier}"
  azs                       = ["${var.azs}"]
  db_subnets                = ["${var.db_subnets}"]
  existing_vpc              = "${var.existing_vpc}"
  from_port                 = "${var.from_port}"
  to_port                   = "${var.to_port}"
  major_engine_version      = "${var.major_engine_version}"
}
