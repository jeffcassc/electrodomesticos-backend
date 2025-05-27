# Para las integraciones de API Gateway (usa invoke_arn)
output "user_register_invoke_arn" {
  value = aws_lambda_function.user_register.invoke_arn
}

output "user_login_invoke_arn" {
  value = aws_lambda_function.user_login.invoke_arn
}

output "product_create_invoke_arn" {
  value = aws_lambda_function.product_create.invoke_arn
}

output "product_list_invoke_arn" {
  value = aws_lambda_function.product_list.invoke_arn
}

output "cart_create_invoke_arn" {
  value = aws_lambda_function.cart_create.invoke_arn
}

# Para los permisos Lambda (usa arn normal)
output "user_register_arn" {
  value = aws_lambda_function.user_register.arn
}

output "user_login_arn" {
  value = aws_lambda_function.user_login.arn
}

output "product_create_arn" {
  value = aws_lambda_function.product_create.arn
}

output "product_list_arn" {
  value = aws_lambda_function.product_list.arn
}

output "cart_create_arn" {
  value = aws_lambda_function.cart_create.arn
}

output "user_register_function_name" {
  description = "Nombre de la función Lambda de registro de usuarios"
  value       = aws_lambda_function.user_register.function_name
}

output "user_login_function_name" {
  description = "Nombre de la función Lambda de login de usuarios"
  value       = aws_lambda_function.user_login.function_name
}

output "product_create_function_name" {
  description = "Nombre de la función Lambda de creación de productos"
  value       = aws_lambda_function.product_create.function_name
}

output "product_list_function_name" {
  description = "Nombre de la función Lambda de listado de productos"
  value       = aws_lambda_function.product_list.function_name
}

output "cart_create_function_name" {
  description = "Nombre de la función Lambda de creación de carritos"
  value       = aws_lambda_function.cart_create.function_name
}