variable "access_key"{
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "region" {
  default = ""
}

variable "existing_vpc" {
  default = ""
}

variable "db_subnets" {
    #type = list
    default = []
}
variable "azs" {
  default = []
}

variable "rds_instance_identifier" {
  default = ""
}

variable "database_name" {
  default = ""
}

variable "database_user" {
  default = ""
}

variable "database_password" {
  default = ""
}

variable "from_port" {
  default = ""
}

variable "to_port" {
  default = ""
}
variable "storage_type" {
  default = ""
}

variable "storage_encrypted" {
  default = ""
}

variable "allocated_storage" {
  default = ""
}

variable "engine" {
  default = ""
}

variable "engine_version" {
  default = ""
}

variable "instance_class" {
  default = ""
}

variable "skip_final_snapshot" {
  default = ""
}

variable "final_snapshot_identifier" {
  default = ""
}

variable "multi_az" {
  default = ""
}

variable "major_engine_version" {
  default = ""
}

variable "option_group_name" {
  default = ""
}

variable "family" {
  default = ""
}

variable "parameter_group_name" {
  default = ""
}
