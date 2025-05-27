output "api_gateway_url" {
  value = aws_api_gateway_stage.prod.invoke_url
}

output "api_gateway_id" {
  description = "ID de la API Gateway"
  value       = aws_api_gateway_rest_api.electrodomesticos_api.id
}

output "api_gateway_execution_arn" {
  description = "ARN de ejecución de la API Gateway"
  value       = aws_api_gateway_rest_api.electrodomesticos_api.execution_arn
}