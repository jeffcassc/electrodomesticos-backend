terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"

}

# Módulo para DynamoDB
module "dynamodb" {
  source = "./modules/dynamodb"
}

# Módulo para Lambdas
module "lambdas" {
  source = "./modules/lambda"

  dynamodb_user_arn    = module.dynamodb.user_table_arn
  dynamodb_product_arn = module.dynamodb.product_table_arn
  dynamodb_cart_arn    = module.dynamodb.cart_table_arn
}

# Módulo para API Gateway
module "api_gateway" {
  source = "./modules/api_gateway"

  # Para integraciones
  user_register_lambda_invoke_arn  = module.lambdas.user_register_invoke_arn
  user_login_lambda_invoke_arn     = module.lambdas.user_login_invoke_arn
  product_create_lambda_invoke_arn = module.lambdas.product_create_invoke_arn
  product_list_lambda_invoke_arn   = module.lambdas.product_list_invoke_arn
  cart_create_lambda_invoke_arn    = module.lambdas.cart_create_invoke_arn

  # Para permisos
  user_register_lambda_arn  = module.lambdas.user_register_arn
  user_login_lambda_arn     = module.lambdas.user_login_arn
  product_create_lambda_arn = module.lambdas.product_create_arn
  product_list_lambda_arn   = module.lambdas.product_list_arn
  cart_create_lambda_arn    = module.lambdas.cart_create_arn

}

# Crear usuarios IAM para los miembros del equipo
resource "aws_iam_user" "team_members" {
  for_each = toset(["usuario1", "usuario2", "usuario3", "usuario4"])

  name = each.key
}

resource "aws_iam_user_policy_attachment" "lambda_viewer" {
  for_each = aws_iam_user.team_members

  user       = each.value.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "dynamodb_viewer" {
  for_each = aws_iam_user.team_members

  user       = each.value.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}