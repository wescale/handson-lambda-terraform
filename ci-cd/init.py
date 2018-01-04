#!python

from python_terraform import Terraform, IsFlagged

tf_base = Terraform(working_dir='iac/layer-base')
tf_users = Terraform(working_dir='iac/layer-users')

tf_base.init(capture_output=False)
tf_users.init(capture_output=False)
