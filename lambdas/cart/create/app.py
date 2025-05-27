import json
import uuid
import time
import boto3
import jwt
from decimal import Decimal
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb')
cart_table = dynamodb.Table('Cart')
product_table = dynamodb.Table('Product')
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
        if 'products' not in body or 'total' not in body:
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'Faltan campos requeridos'}, cls=DecimalEncoder)
            }
        
        # Verificar que los productos existan
        for product in body['products']:
            if 'uuid' not in product:
                return {
                    'statusCode': 400,
                    'body': json.dumps({'message': 'Cada producto debe tener un UUID'}, cls=DecimalEncoder)
                }
            
            # Asegúrate de usar la clave correcta para la tabla Product
            response = product_table.get_item(
                Key={
                    'uuid': product['uuid'],  # Clave de partición
                    'name': product.get('name', '')  # Clave de ordenación
                }
            )
            
            if 'Item' not in response:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': f'Producto {product["uuid"]} no encontrado'}, cls=DecimalEncoder)
                }
        
        # Crear carrito
        cart_id = str(uuid.uuid4())
        created_at = int(time.time())
        
        item = {
            'uuid': cart_id,
            'UserId': user_id,
            'products': body['products'],
            'total': Decimal(str(body['total'])),
            'createdAt': created_at,
            'status': 'pending'
        }
        
        cart_table.put_item(Item=item)
        
        return {
            'statusCode': 201,
            'body': json.dumps({
                'message': 'Carrito creado exitosamente',
                'data': item
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