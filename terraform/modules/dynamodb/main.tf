resource "aws_dynamodb_table" "user" {
  name         = "User"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "uuid"
  range_key    = "email"

  attribute {
    name = "uuid"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

   # Índice secundario global para búsquedas por email
  global_secondary_index {
    name               = "email-index"
    hash_key           = "email"
    projection_type    = "ALL"  # Incluye todos los atributos en el índice
    read_capacity      = 5      # Ajusta según necesidades
    write_capacity     = 5      # Ajusta según necesidades
  }

  tags = {
    Environment = "production"
  }
}



resource "aws_dynamodb_table" "product" {
  name         = "Product"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "uuid"
  range_key    = "name"

  attribute {
    name = "uuid"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }
}

resource "aws_dynamodb_table" "cart" {
  name         = "Cart"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "uuid"
  range_key    = "UserId"

  attribute {
    name = "uuid"
    type = "S"
  }

  attribute {
    name = "UserId"
    type = "S"
  }
}


