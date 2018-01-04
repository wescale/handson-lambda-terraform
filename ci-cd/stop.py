#!python

import base64
import uuid
import hashlib
import requests
from python_terraform import Terraform, IsFlagged

tf_base = Terraform(working_dir='iac/layer-base')
tf_users = Terraform(working_dir='iac/layer-users')

tf_users.destroy(force=IsFlagged, capture_output=False)
tf_base.destroy(force=IsFlagged, capture_output=False)
