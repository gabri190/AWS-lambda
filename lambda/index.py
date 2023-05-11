#!/usr/bin/env python3 

## This is a lambda function to get the object from s3 pass to SQS and put it into dynamodb and amazon RDS
import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event,context):
    try:
        logger.info("Event: " + str(event))
        for event in event['Records']:
            s3_event=json.loads(event['body'])
            logger.info("S3 Event: " + str(s3_event))
            #skip the test event
            if 'Event' in s3_event.keys() and s3_event['Event'] == 's3:TestEvent':
                break
            #get the bucket name and object key
            for event in s3_event['Records']:
                logger.info('Bucket name: %s', event['s3']['bucket']['name'])
                logger.info('Object key: %s', event['s3']['object']['key'])
                bucket_name = event['s3']['bucket']['name']
                object_key = event['s3']['object']['key']
                #get the object from s3
                s3 = boto3.resource('s3')
                s3_object = s3.Object(bucket_name, object_key)
                s3_response = s3_object.get()
                #get the object content
                object_content = s3_response['Body'].read().decode('utf-8')
                logger.info('Object content: %s', object_content)
                #get the dynamodb table
                dynamodb = boto3.resource('dynamodb')
                table = dynamodb.Table('test')
                #put the object content into dynamodb
                table.put_item(
                    Item={
                        'object_key': object_key,
                        'object_content': object_content
                    }
                )
                #get the RDS table
                rds = boto3.client('rds')
                #put the object content into RDS
                rds_response = rds.execute_statement(
                    resourceArn='arn:aws:rds:us-east-1:123456789012:cluster:my-cluster',
                    secretArn='arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret',
                    database='database_lambda_test',
                    sql='INSERT INTO test (object_key, object_content) VALUES (:object_key, :object_content)',
                    parameters=[
                        {
                            'name': 'object_key',
                            'value': {
                                'stringValue': object_key
                            }
                        },
                        {
                            'name': 'object_content',
                            'value': {
                                'stringValue': object_content
                            }
                        }
                    ]
                )
                logger.info('RDS    response: %s', rds_response)
                #get the SQS queue
                sqs = boto3.client('sqs')
                #put the object content into SQS
                sqs_response = sqs.send_message(
                    QueueUrl='https://sqs.us-east-1.amazonaws.com/123456789012/test',
                    MessageBody=object_content
                )
                logger.info('SQS    response: %s', sqs_response)
    except Exception as e:
        logger.error("Exception: %s",e)
        raise e
    


# import json
# import boto3
# import logging

# logger = logging.getLogger()
# logger.setLevel(logging.INFO)

# #s3 and dynamodb in here
# def handler(event,context):
#     try:
#         logger.info("Event: " + str(event))
#         for event in event['Records']:
#             s3_event=json.loads(event['body'])
#             logger.info("S3 Event: " + str(s3_event))
#             #skip the test event
#             if 'Event' in s3_event.keys() and s3_event['Event'] == 's3:TestEvent':
#                 break
#             #get the bucket name and object key
#             for event in s3_event['Records']:
#                 logger.info('Bucket name: %s', event['s3']['bucket']['name'])
#                 logger.info('Object key: %s', event['s3']['object']['key'])
#                 bucket_name = event['s3']['bucket']['name']
#                 object_key = event['s3']['object']['key']
#                 #get the object from s3
#                 s3 = boto3.resource('s3')
#                 s3_object = s3.Object(bucket_name, object_key)
#                 s3_response = s3_object.get()
#                 #get the object content
#                 object_content = s3_response['Body'].read().decode('utf-8')
#                 logger.info('Object content: %s', object_content)
#                 #get the dynamodb table
#                 dynamodb = boto3.resource('dynamodb')
#                 table = dynamodb.Table('test')
#                 #put the object content into dynamodb
#                 table.put_item(
#                     Item={
#                         'object_key': object_key,
#                         'object_content': object_content
#                     }
#                 )
#     except Exception as e:
#         logger.error("Exception: %s",e)
#         raise e 








# def handler(event,context):
#     try:
#         logger.info("Event: " + str(event))
#         for event in event['Records']:
#             s3_event=json.loads(event['body'])
#             logger.info("S3 Event: " + str(s3_event))
#             #skip the test event
#             if 'Event' in s3_event.keys() and s3_event['Event'] == 's3:TestEvent':
#                 break
#             #get the bucket name and object key
#             for event in s3_event['Records']:
#                 logger.info('Bucket name: %s', event['s3']['bucket']['name'])
#                 logger.info('Object key: %s', event['s3']['object']['key'])
#     except Exception as e:
#         logger.error("Exception: %s",e)
#         raise e

    