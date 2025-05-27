resource "aws_lambda_function" "user_register" {
  filename      = "${path.module}/../../../lambdas/user/register/lambda.zip"
  function_name = "user_register"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  layers        = [aws_lambda_layer_version.jwt_layer.arn]
  
  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }
}

resource "aws_lambda_function" "user_login" {
  filename      = "${path.module}/../../../lambdas/user/login/lambda.zip"
  function_name = "user_login"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = filebase64sha256("${path.module}/../../../lambdas/user/login/lambda.zip")
  layers = [aws_lambda_layer_version.jwt_layer.arn]
  depends_on = [aws_lambda_layer_version.jwt_layer]
}

# Repetir para las otras lambdas (product_create, product_list, cart_create)

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_dynamodb" {
  name = "lambda_dynamodb_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = [
          var.dynamodb_user_arn,
          "${var.dynamodb_user_arn}/index/email-index",
          var.dynamodb_product_arn,
          var.dynamodb_cart_arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}



# Agregar outputs para las otras lambdas

variable "dynamodb_user_arn" {
  description = "ARN de la tabla DynamoDB de usuarios"
  type        = string
}

variable "dynamodb_product_arn" {
  description = "ARN de la tabla DynamoDB de productos"
  type        = string
}

variable "dynamodb_cart_arn" {
  description = "ARN de la tabla DynamoDB de carritos"
  type        = string
}

resource "aws_lambda_function" "product_create" {
  filename      = "${path.module}/../../../lambdas/product/create/lambda.zip"
  function_name = "product_create"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  layers        = [aws_lambda_layer_version.jwt_layer.arn]
}

resource "aws_lambda_function" "product_list" {
  filename      = "${path.module}/../../../lambdas/product/list/lambda.zip"
  function_name = "product_list"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  layers        = [aws_lambda_layer_version.jwt_layer.arn]
}

resource "aws_lambda_function" "cart_create" {
  filename      = "${path.module}/../../../lambdas/cart/create/lambda.zip"
  function_name = "cart_create"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  layers        = [aws_lambda_layer_version.jwt_layer.arn]
}