output "dynamo_table_name" {
  description = "Dynamo table name"
  value       = aws_dynamodb_table.configs_table.name
}
