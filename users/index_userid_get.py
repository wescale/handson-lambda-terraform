#!python
"""
GET /users/{userId}
"""
import os
import json
import redis
from redis.exceptions import ConnectionError

def handler(event, context):
    """
    GET /users/{userId}
    """
    ret = {}

    userid = event['pathParameters']['userId']

    try:
        redis_conn = redis.StrictRedis(host=str(os.environ['REDIS_DNS']),
                                       port=os.environ['REDIS_PORT'],
                                       db=0,
                                       decode_responses=True
                                      )

        user = redis_conn.get("user_"+userid)
        if not user:
            ret['statusCode'] = 404
        else:
            ret['statusCode'] = 200
            ret['body'] = user

    except ConnectionError as inst:
        ret['statusCode'] = 500
        ret['body'] = json.dumps({
            "error": inst.args
        })

    ret['headers'] = {}
    ret['headers']['Content-Type'] = "application/json"

    return ret
