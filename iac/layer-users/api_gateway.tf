
resource "aws_api_gateway_rest_api" "demo" {
  name = "demo"
  description = "demo"
}

resource "aws_api_gateway_resource" "demo_ressource" {
  rest_api_id = "${aws_api_gateway_rest_api.demo.id}"
  parent_id = "${aws_api_gateway_rest_api.demo.root_resource_id}"
  path_part = "demo"
}

resource "aws_api_gateway_resource" "demo_users_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.demo.id}"
  parent_id = "${aws_api_gateway_resource.demo_ressource.id}"
  path_part = "users"
}

resource "aws_api_gateway_resource" "demo_users_userid_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.demo.id}"
  parent_id = "${aws_api_gateway_resource.demo_users_resource.id}"
  path_part = "{userId}"
}

resource "aws_api_gateway_method_settings" "demo_env_settings" {

  rest_api_id = "${aws_api_gateway_rest_api.demo.id}"
  stage_name  = "${aws_api_gateway_deployment.demo_env.stage_name}"
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

