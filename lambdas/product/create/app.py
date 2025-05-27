import json
import uuid
import time
import boto3
import jwt
from decimal import Decimal
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Product')
SECRET_KEY = "tu_clave_secreta_super_segura"

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super(DecimalEncoder, self).default(obj)

def lambda_handler(event, context):
    try:
        # Verificar token JWT
        token = event['headers'].get('Authorization', '').split(' ')[1]
        decoded = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        user_id = decoded['sub']
        
        body = json.loads(event['body'])
        
        # Validar campos requeridos
        required_fields = ['name', 'brand', 'categories', 'price']
        if not all(field in body for field in required_fields):
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'Faltan campos requeridos'}, cls=DecimalEncoder)
            }
        
        # Validar que el precio sea numérico
        try:
            price = Decimal(str(body['price']))
        except:
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'El precio debe ser un número válido'}, cls=DecimalEncoder)
            }
        
        # Crear producto
        product_id = str(uuid.uuid4())
        created_at = int(time.time())
        
        item = {
            'uuid': product_id,
            'name': body['name'],
            'brand': body['brand'],
            'categories': body['categories'],
            'price': price,  # Usamos el Decimal ya convertido
            'userId': user_id,
            'createdAt': created_at
        }
        
        table.put_item(Item=item)
        
        # Preparar respuesta sin el campo userId
        response_data = {
            'uuid': product_id,
            'name': body['name'],
            'brand': body['brand'],
            'categories': body['categories'],
            'price': float(price),  # Convertimos a float para la respuesta
            'createdAt': created_at
        }
        
        return {
            'statusCode': 201,
            'body': json.dumps({
                'message': 'Producto registrado exitosamente',
                'data': response_data
            }, cls=DecimalEncoder)
        }
        
    except jwt.ExpiredSignatureError:
        return {
            'statusCode': 401,
            'body': json.dumps({'message': 'Token expirado'}, cls=DecimalEncoder)
        }
    except jwt.InvalidTokenError:
        return {
            'statusCode': 401,
            'body': json.dumps({'message': 'Token inválido'}, cls=DecimalEncoder)
        }
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)}, cls=DecimalEncoder)
        }