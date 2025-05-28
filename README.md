# Backend para Tienda de Electrodomésticos

Este proyecto implementa un backend serverless para administrar una tienda de electrodomésticos usando AWS Lambda, DynamoDB y API Gateway. 

## Requisitos

- Terraform >= 1.5.0
- AWS CLI configurado
- Cuenta de AWS con permisos adecuados

## Estructura

- `terraform/`: Configuración de infraestructura como código
- `lambdas/`: Código fuente de las funciones Lambda
- `.github/workflows/`: CI/CD con GitHub Actions

## Despliegue

1. Configura tus credenciales de AWS como secrets en GitHub
2. Haz push a la rama main para desplegar automáticamente
3. O ejecuta manualmente el workflow desde GitHub Actions

## Endpoints

- POST /user - Registrar usuario
- POST /user/login - Iniciar sesión
- POST /product - Crear producto (requiere autenticación)
- GET /product - Listar productos
- POST /cart - Crear carrito (requiere autenticación)



