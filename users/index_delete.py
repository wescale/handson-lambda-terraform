#!python
"""
file for /demo/users DELETE
"""
import os
import json
import uuid
import redis
from redis.exceptions import ConnectionError

def handler(event, _):
    """
    handler for /demo/users DELETE
    """
    ret = {}

    try:
        redis_conn = redis.StrictRedis(host=str(os.environ['REDIS_DNS']),
                                       port=os.environ['REDIS_PORT'],
                                       db=0,
                                       decode_responses=True
                                      )

        users = []
        usersid = redis_conn.smembers("users")
        if usersid:
            for userid in list(usersid):
                redis_conn.delete("user_"+userid)
        redis_conn.delete("users")

        ret['statusCode'] = 200
        ret['body'] = json.dumps(users)

    except ConnectionError as inst:
        ret['statusCode'] = 500
        ret['body'] = json.dumps({
            "error": inst.args
        })

    ret['headers'] = {"Content-Type": "application/json"}
    return ret
