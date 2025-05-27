import json
import time
import jwt
import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('User')
SECRET_KEY = "tu_clave_secreta_super_segura"  # debo cambiarlo para producion mmgv

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        
        if 'email' not in body or 'password' not in body:
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'Email y contraseña son requeridos'})
            }
        
        # Buscar usuario por email
        response = table.query(
            IndexName='email-index',
            KeyConditionExpression='email = :email',
            ExpressionAttributeValues={':email': body['email']}
        )
        
        if response['Count'] == 0:
            return {
                'statusCode': 401,
                'body': json.dumps({'message': 'Credenciales inválidas'})
            }
        
        user = response['Items'][0]
        
        # Verificar contraseña (asegúrate que sea string)
        if user['password'] != str(body['password']):  # Conversión explícita a string
            return {
                'statusCode': 401,
                'body': json.dumps({'message': 'Credenciales inválidas'})
            }
        
        # Generar token JWT (asegura que los datos sean serializables)
        token_payload = {
            'sub': str(user['uuid']),  # Asegura que sea string
            'email': str(user['email']),
            'exp': int(time.time()) + 3600
        }
        
        token = jwt.encode(token_payload, SECRET_KEY, algorithm='HS256')
        
        # Asegúrate que el token sea string (no bytes)
        if isinstance(token, bytes):
            token = token.decode('utf-8')
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': json.dumps({
                'message': 'Login exitoso',
                'token': token  # Ya es string
            })
        }
        
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': f"Error inesperado: {str(e)}"})
        }