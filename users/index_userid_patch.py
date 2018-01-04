#!python
"""
/users/{userId} PATCH
"""
import os
import json
import redis
from redis.exceptions import ConnectionError

def handler(event, _):
    """
    /users/{userId} PATCH
    """
    ret = {}
    user = json.loads(event['body'])
    userid = event['pathParameters']['userId']

    try:
        redis_conn = redis.StrictRedis(host=str(os.environ['REDIS_DNS']),
                                       port=os.environ['REDIS_PORT'],
                                       db=0,
                                       decode_responses=True
                                      )

        user_test = redis_conn.get("user_"+userid)
        if user_test:
            user['id'] = userid
            redis_conn.set("user_"+userid, json.dumps(user))
            ret['statusCode'] = 200
            ret['body'] = json.dumps(user)
        else:
            ret['statusCode'] = 404

    except ConnectionError as inst:
        ret['statusCode'] = 500
        ret['body'] = json.dumps({
            "error": inst.args
        })

    ret['headers'] = {"Content-Type": "application/json"}
    return ret