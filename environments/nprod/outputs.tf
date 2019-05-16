output "this_db_subnet_group_id" {
  description = "The db subnet group name"
  value       = "${element(concat(aws_db_subnet_group.default.*.id, list("")),0)}"
}

output "this_db_option_group_id" {
  description = "The db option group name"
  value       = "${element(concat(aws_db_option_group.default.*.id, list("")),0)}"
}

output "this_db_parameter_group_id" {
  description = "The db option group name"
  value       = "${element(concat(aws_db_parameter_group.default.*.id, list("")),0)}"
}
