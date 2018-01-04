
resource "aws_api_gateway_deployment" "demo_env" {
  depends_on = [
    # users get
    "aws_api_gateway_method.demo_users_get_method",
    "aws_api_gateway_integration.demo_users_get_integration",

    # users get
    "aws_api_gateway_method.demo_users_post_method",
    "aws_api_gateway_integration.demo_users_post_integration",

    # users get
    "aws_api_gateway_method.demo_users_userid_get_method",
    "aws_api_gateway_integration.demo_users_userid_get_integration",

    # users get
    "aws_api_gateway_method.demo_users_userid_delete_method",
    "aws_api_gateway_integration.demo_users_userid_delete_integration",

    # users get
    "aws_api_gateway_method.demo_users_userid_patch_method",
    "aws_api_gateway_integration.demo_users_userid_patch_integration",
  ]
  rest_api_id = "${aws_api_gateway_rest_api.demo.id}"
  stage_name = "dev"
}

output "env_url" {
  value = "https://${aws_api_gateway_deployment.demo_env.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.demo_env.stage_name}"
}

