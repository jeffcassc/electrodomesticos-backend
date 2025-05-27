import json
import boto3
from decimal import Decimal
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Product')

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super(DecimalEncoder, self).default(obj)

def lambda_handler(event, context):
    try:
        # Escanear todos los productos (en producción usar paginación)
        response = table.scan()
        
        # Formatear respuesta convirtiendo Decimal a float
        products = []
        for item in response['Items']:
            product = {
                'uuid': item['uuid'],
                'name': item['name'],
                'brand': item['brand'],
                'categories': item['categories'],
                'price': float(item['price']) if isinstance(item['price'], Decimal) else item['price']
            }
            products.append(product)
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'data': products
            }, cls=DecimalEncoder)
        }
        
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)}, cls=DecimalEncoder)
        }