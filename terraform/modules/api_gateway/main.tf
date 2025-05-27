resource "aws_api_gateway_rest_api" "electrodomesticos_api" {
  name        = "ElectrodomesticosAPI"
  description = "API para tienda de electrodomésticos"
}

# User Resources
resource "aws_api_gateway_resource" "user" {
  rest_api_id = aws_api_gateway_rest_api.electrodomesticos_api.id
  parent_id   = aws_api_gateway_rest_api.electrodomesticos_api.root_resource_id
  path_part   = "user"
}

resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.electrodomesticos_api.id
  parent_id   = aws_api_gateway_resource.user.id
  path_part   = "login"
}

# Product Resources
resource "aws_api_gateway_resource" "product" {
  rest_api_id = aws_api_gateway_rest_api.electrodomesticos_api.id
  parent_id   = aws_api_gateway_rest_api.electrodomesticos_api.root_resource_id
  path_part   = "product"
}

resource "aws_api_gateway_resource" "list" {
  rest_api_id = aws_api_gateway_rest_api.electrodomesticos_api.id
  parent_id   = aws_api_gateway_resource.product.id
  path_part   = "list"
}

# Cart Resources
resource "aws_api_gateway_resource" "cart" {
  rest_api_id = aws_api_gateway_rest_api.electrodomesticos_api.id
  parent_id   = aws_api_gateway_rest_api.electrodomesticos_api.root_resource_id
  path_part   = "cart"
}

# User Register Method
resource "aws_api_gateway_method" "user_register" {
  rest_api_id   = aws_api_gateway_rest_api.electrodomesticos_api.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user_register" {
  rest_api_id             = aws_api_gateway_rest_api.electrodomesticos_api.id
  resource_id             = aws_api_gateway_resource.user.id
  http_method             = aws_api_gateway_method.user_register.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.user_register_lambda_invoke_arn
}

# User Login Method
resource "aws_api_gateway_method" "user_login" {
  rest_api_id   = aws_api_gateway_rest_api.electrodomesticos_api.id
  resource_id   = aws_api_gateway_resource.login.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user_login" {
  rest_api_id             = aws_api_gateway_rest_api.electrodomesticos_api.id
  resource_id             = aws_api_gateway_resource.login.id
  http_method             = aws_api_gateway_method.user_login.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.user_login_lambda_invoke_arn
}

# Product Create Method
resource "aws_api_gateway_method" "product_create" {
  rest_api_id   = aws_api_gateway_rest_api.electrodomesticos_api.id
  resource_id   = aws_api_gateway_resource.product.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "product_create" {
  rest_api_id             = aws_api_gateway_rest_api.electrodomesticos_api.id
  resource_id             = aws_api_gateway_resource.product.id
  http_method             = aws_api_gateway_method.product_create.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.product_create_lambda_invoke_arn
}

# Product List Method
resource "aws_api_gateway_method" "product_list" {
  rest_api_id   = aws_api_gateway_rest_api.electrodomesticos_api.id
  resource_id   = aws_api_gateway_resource.list.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "product_list" {
  rest_api_id             = aws_api_gateway_rest_api.electrodomesticos_api.id
  resource_id             = aws_api_gateway_resource.list.id
  http_method             = aws_api_gateway_method.product_list.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.product_list_lambda_invoke_arn
}

# Cart Create Method
resource "aws_api_gateway_method" "cart_create" {
  rest_api_id   = aws_api_gateway_rest_api.electrodomesticos_api.id
  resource_id   = aws_api_gateway_resource.cart.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cart_create" {
  rest_api_id             = aws_api_gateway_rest_api.electrodomesticos_api.id
  resource_id             = aws_api_gateway_resource.cart.id
  http_method             = aws_api_gateway_method.cart_create.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.cart_create_lambda_invoke_arn
}

# Deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.user_register,
    aws_api_gateway_integration.user_login,
    aws_api_gateway_integration.product_create,
    aws_api_gateway_integration.product_list,
    aws_api_gateway_integration.cart_create
  ]

  rest_api_id = aws_api_gateway_rest_api.electrodomesticos_api.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.electrodomesticos_api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}

# Lambda Permissions
resource "aws_lambda_permission" "api_gateway_user_register" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.user_register_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.electrodomesticos_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "api_gateway_user_login" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.user_login_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.electrodomesticos_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "api_gateway_product_create" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.product_create_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.electrodomesticos_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "api_gateway_product_list" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.product_list_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.electrodomesticos_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "api_gateway_cart_create" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.cart_create_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.electrodomesticos_api.execution_arn}/*/*/*"
}

