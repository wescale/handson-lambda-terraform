#!python
"""
file for /demo/users POST
"""
import os
import json
import uuid
import redis
from redis.exceptions import ConnectionError

def handler(event, _):
    """
    handler for /demo/users POST
    """
    user = json.loads(event['body'])
    ret = {}

    try:
        redis_conn = redis.StrictRedis(host=str(os.environ['REDIS_DNS']),
                                       port=os.environ['REDIS_PORT'],
                                       db=0,
                                       decode_responses=True
                                      )

        userid = str(uuid.uuid4())
        user['id'] = userid

        redis_conn.set("user_"+userid, json.dumps(user))
        redis_conn.expire("user_"+userid, 15552000) # expire dans 6 mois

        # on ajoute le user dans la liste des users
        redis_conn.sadd("users", userid)
        redis_conn.expire("users", 15552000)

        ret['statusCode'] = 201
        ret['body'] = json.dumps(user)

    except ConnectionError as inst:
        ret['statusCode'] = 500
        ret['body'] = json.dumps({
            "error": inst.args
        })

    ret['headers'] = {"Content-Type": "application/json"}
    return ret
