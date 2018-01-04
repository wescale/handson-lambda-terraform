#!python

from python_terraform import Terraform, IsFlagged

tf_base = Terraform(working_dir='iac/layer-base')
tf_users = Terraform(working_dir='iac/layer-users')

tf_base.apply(auto_approve=IsFlagged, capture_output=False)
tf_users.apply(auto_approve=IsFlagged, capture_output=False)

url_pf = tf_users.output('env_url')

print("Test with: " + url_pf)
