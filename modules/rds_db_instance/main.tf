resource "aws_subnet" "rds" {
  count                   = "${length(var.azs)}"
  vpc_id                  = "${var.existing_vpc}"
  #cidr_block              = "10.2.${length(var.azs) + count.index}.0/24"
  cidr_block              = "${element(var.db_subnets, count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"

    tags {
    Name = "rds-${element(var.azs, count.index)}"
  }
}

resource "aws_db_subnet_group" "default" {
  name        = "${var.rds_instance_identifier}-subnet-group"
  description = "Terraform example RDS subnet group"
  subnet_ids  = ["${aws_subnet.rds.*.id}"]
}

resource "aws_security_group" "rds" {
  name        = "${var.rds_instance_identifier}-subnet-group"
  description = "Terraform example RDS MySQL server"
  vpc_id      = "${var.existing_vpc}"
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    from_port       = "${var.from_port}"
    to_port         = "${var.to_port}"
    protocol        = "tcp"
    #security_groups = ["${aws_security_group.default.id}"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.rds_instance_identifier}-security-group"
  }
}

resource "aws_db_instance" "default" {
  identifier                = "${var.rds_instance_identifier}"
  storage_type              = "${var.storage_type}"
  storage_encrypted         = "${var.storage_encrypted}"
  allocated_storage         = "${var.allocated_storage}"
  engine                    = "${var.engine}"
  engine_version            = "${var.engine_version}"
  instance_class            = "${var.instance_class}"
  name                      = "${var.database_name}"
  username                  = "${var.database_user}"
  password                  = "${var.database_password}"
  db_subnet_group_name      = "${aws_db_subnet_group.default.id}"
  #vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  parameter_group_name      = "${var.parameter_group_name}"
  option_group_name         = "${var.option_group_name}"
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  multi_az                  = "${var.multi_az}"
  final_snapshot_identifier = "${var.final_snapshot_identifier}"

  tags {
    Name = "terraform-${var.rds_instance_identifier}"
  }
}

resource "aws_db_parameter_group" "default" {
  name        = "${var.rds_instance_identifier}-param-group"
  description = "Terraform example parameter group for ${var.major_engine_version}"
  family      = "${var.family}"
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
  lifecycle {
      create_before_destroy = true
    }
}

resource "aws_db_option_group" "default" {
  name                     = "${var.rds_instance_identifier}-option-group"
  option_group_description = "${var.rds_instance_identifier} option group"
  engine_name              = "${var.engine}"
  major_engine_version     = "${var.major_engine_version}"


lifecycle {
    create_before_destroy = true
  }
}
