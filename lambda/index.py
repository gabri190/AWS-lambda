#!/usr/bin/env python3

import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#s3 in here
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
    except Exception as e:
        logger.error("Exception: %s",e)
        raise e

    