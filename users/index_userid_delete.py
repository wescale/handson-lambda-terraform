#!python
"""
DELETE /users/{userId}
"""
import os
import json
import redis
from redis.exceptions import ConnectionError

def handler(event, context):
    """
    DELETE /users/{userId}
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
        if user:
            redis_conn.delete("user_"+userid)
            redis_conn.srem("users", userid)
            ret['statusCode'] = 200
            ret['body'] = user
        else:
            ret['statusCode'] = 404

    except ConnectionError as inst:
        ret['statusCode'] = 500
        ret['body'] = json.dumps({
            "error": inst.args
        })


    ret['headers'] = {"Content-Type": "application/json"}
    return ret
