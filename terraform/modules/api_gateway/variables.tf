# Para integraciones
variable "user_register_lambda_invoke_arn" {
  type = string
}

variable "user_login_lambda_invoke_arn" {
  type = string
}

variable "product_create_lambda_invoke_arn" {
  type = string
}

variable "product_list_lambda_invoke_arn" {
  type = string
}

variable "cart_create_lambda_invoke_arn" {
  type = string
}

# Para permisos
variable "user_register_lambda_arn" {
  type = string
}

variable "user_login_lambda_arn" {
  type = string
}

variable "product_create_lambda_arn" {
  type = string
}

variable "product_list_lambda_arn" {
  type = string
}

variable "cart_create_lambda_arn" {
  type = string
}