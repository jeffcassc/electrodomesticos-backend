import json
import uuid
import time
import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('User')

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        
        # Validar campos requeridos
        required_fields = ['name', 'email', 'password', 'phone']
        if not all(field in body for field in required_fields):
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'Faltan campos requeridos'})
            }
        
         # Validar formato de email
        if '@' not in body['email'] or '.' not in body['email'].split('@')[1]:
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'Email inválido'})
            }
        
        # Verificar si el usuario ya existe
        response = table.query(
            IndexName='email-index',
            KeyConditionExpression='email = :email',
            ExpressionAttributeValues={':email': body['email']}
        )
        
        if response['Count'] > 0:
            return {
                'statusCode': 409,
                'body': json.dumps({'message': 'El usuario ya existe'})
            }
        
        # Crear usuario
        user_id = str(uuid.uuid4())
        created_at = int(time.time())
        
        item = {
            'uuid': user_id,
            'email': body['email'],
            'name': body['name'],
            'password': body['password'],  
            'phone': body['phone'],
            'createdAt': created_at
        }
        
        table.put_item(Item=item)
        
        # No devolver la contraseña en la respuesta
        response_data = {
            'uuid': user_id,
            'email': body['email'],
            'name': body['name'],
            'phone': body['phone'],
            'createdAt': created_at
        }
        
        return {
            'statusCode': 201,
            'body': json.dumps({
                'message': 'Usuario registrado exitosamente',
                'data': response_data
            })
        }
        
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)})
        }