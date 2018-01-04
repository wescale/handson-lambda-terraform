#!python
"""
file for /demo/users GET
"""
import os
import json
import uuid
import redis
from redis.exceptions import ConnectionError

def handler(event, _):
    """
    handler for /demo/users GET
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
                user = redis_conn.get("user_"+userid)
                if user:
                    users.append(json.loads(user))

        ret['statusCode'] = 200
        ret['body'] = json.dumps(users)

    except ConnectionError as inst:
        ret['statusCode'] = 500
        ret['body'] = json.dumps({
            "error": inst.args
        })

    ret['headers'] = {"Content-Type": "application/json"}
    return ret
