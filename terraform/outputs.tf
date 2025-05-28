output "api_url" {
  description = "URL base de la API"
  value       = module.api_gateway.api_gateway_url
}

output "user_table_name" {
  description = "Nombre de la tabla de usuarios"
  value       = module.dynamodb.user_table_name
}

output "product_table_name" {
  description = "Nombre de la tabla de productos"
  value       = module.dynamodb.product_table_name
}

output "cart_table_name" {
  description = "Nombre de la tabla de carritos"
  value       = module.dynamodb.cart_table_name
}

output "lambda_functions" {
  description = "Nombres de las funciones Lambda creadas"
  value = {
    user_register = module.lambdas.user_register_function_name
    user_login    = module.lambdas.user_login_function_name
    product_create = module.lambdas.product_create_function_name
    product_list = module.lambdas.product_list_function_name
    cart_create = module.lambdas.cart_create_function_name
  }
}