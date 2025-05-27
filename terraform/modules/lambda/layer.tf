resource "aws_lambda_layer_version" "jwt_layer" {
  filename            = "${path.module}/../../../layers/jwt_layer.zip"
  layer_name          = "jwt-dependencies-v3" # Cambia el nombre
  compatible_runtimes = ["python3.9"]
  description         = "PyJWT 2.8.0 + cryptography 38.0.4"
}
output "jwt_layer_arn" {
  value = aws_lambda_layer_version.jwt_layer.arn
}