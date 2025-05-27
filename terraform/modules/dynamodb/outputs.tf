output "user_table_arn" {
  description = "ARN de la tabla de usuarios"
  value       = aws_dynamodb_table.user.arn
}

output "user_table_name" {
  description = "Nombre de la tabla de usuarios"
  value       = aws_dynamodb_table.user.name
}

output "product_table_arn" {
  description = "ARN de la tabla de productos"
  value       = aws_dynamodb_table.product.arn
}

output "product_table_name" {
  description = "Nombre de la tabla de productos"
  value       = aws_dynamodb_table.product.name
}

output "cart_table_arn" {
  description = "ARN de la tabla de carritos"
  value       = aws_dynamodb_table.cart.arn
}

output "cart_table_name" {
  description = "Nombre de la tabla de carritos"
  value       = aws_dynamodb_table.cart.name
}