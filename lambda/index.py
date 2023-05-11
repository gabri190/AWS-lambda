#!/usr/bin/env python3 
import sys
import logging
import pymysql
import json
import boto3
from botocore.exceptions import ClientError

# rds settings
rds_host = "database_lambda.cdipnbm2csku.us-west-2.rds.amazonaws.com"
user_name = "admin"
password = "password"
db_name = "database_lambda"

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# create the database connection outside of the handler to allow connections to be
# re-used by subsequent function invocations.
try:
    conn = pymysql.connect(host=rds_host, user=user_name, passwd=password, db=db_name, connect_timeout=5)
except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()

logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")


def upload_to_s3(file_name, bucket, object_name):
    s3_client = boto3.client('s3')
    try:
        response = s3_client.upload_file(file_name, bucket, object_name)
    except ClientError as e:
        logging.error(e)
        return False
    return True


def put_item_to_dynamodb(table_name, item):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)
    try:
        response = table.put_item(Item=item)
    except ClientError as e:
        logging.error(e)
        return False
    return True


def lambda_handler(event, context):
    """
    This function creates a new RDS database table and writes records to it
    """
    message = event['Records'][0]['body']
    data = json.loads(message)
    CustID = data['CustID']
    Name = data['Name']

    item_count = 0

    # Upload file to S3
    bucket_name = 'my-bucket-name'
    file_name = '/tmp/my-file.txt'
    object_name = 'my-object-name'
    with open(file_name, 'w') as f:
        f.write('Hello, World!')
    if upload_to_s3(file_name, bucket_name, object_name):
        logger.info(f'{file_name} uploaded to S3 bucket {bucket_name} with object key {object_name}')
    else:
        logger.error(f'Failed to upload {file_name} to S3 bucket {bucket_name} with object key {object_name}')

    # Write data to DynamoDB
    table_name = 'my-table-name'
    item = {'CustID': CustID, 'Name': Name}
    if put_item_to_dynamodb(table_name, item):
        logger.info(f'Data {item} written to DynamoDB table {table_name}')
    else:
        logger.error(f'Failed to write data {item} to DynamoDB table {table_name}')

    # Write data to RDS MySQL
    sql_string = f"insert into Customer (CustID, Name) values({CustID}, '{Name}')"
    with conn.cursor() as cur:
        cur.execute(
            "create table if not exists Customer ( CustID  int NOT NULL, Name varchar(255) NOT NULL, PRIMARY KEY (CustID))"
        )
        cur.execute(sql_string)
        conn.commit()
        cur.execute("select * from Customer")
        logger.info("The following items have been added to the database:")
        for row in cur:
            item_count += 1
            logger.info(row)
    conn.commit()

    return "Added %d items to RDS MySQL table and wrote data to DynamoDB table and S3 bucket" % item_count
