

resource "aws_lambda_function" "demo_users_userid_get_function" {

  depends_on = [
    "aws_elasticache_cluster.demo_redis"
  ]

  runtime = "python3.6"
  role = "${data.terraform_remote_state.layer_base.iam_lambda_role}"
  function_name = "demo_users_userid_get_function"
  publish = true
  handler = "index_userid_get.handler"
  timeout = 120

  s3_bucket = "${var.s3_bucket_package}"
  s3_key = "users/users-lambda-${var.version_users}.zip"

  vpc_config = {
    subnet_ids = [
      "${data.terraform_remote_state.layer_base.sn_private_a_id}", 
      "${data.terraform_remote_state.layer_base.sn_private_b_id}", 
      "${data.terraform_remote_state.layer_base.sn_private_c_id}", 
    ]
    security_group_ids = [
      "${data.terraform_remote_state.layer_base.sg_sn_lambda_id}", 
    ]
  }

  environment = {
    variables = {
      "REDIS_DNS" = "${aws_elasticache_cluster.demo_redis.cache_nodes.0.address}"
      "REDIS_PORT" = "${aws_elasticache_cluster.demo_redis.port}"
    }
  }

  tags {
    Name = "demo_users_userid_get_function"
  }
}

resource "aws_api_gateway_method" "demo_users_userid_get_method" {
  rest_api_id = "${aws_api_gateway_rest_api.demo.id}"
  resource_id = "${aws_api_gateway_resource.demo_users_userid_resource.id}"
  http_method = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.userId" = true
  }
}

resource "aws_lambda_permission" "demo_users_userid_get_function_allow_api_gateway" {

  depends_on = [
    "aws_lambda_function.demo_users_userid_get_function",
    "aws_api_gateway_rest_api.demo",
    "aws_api_gateway_method.demo_users_userid_get_method"
  ]

  function_name = "${aws_lambda_function.demo_users_userid_get_function.function_name}"
  statement_id = "AllowExecutionFromApiGateway_users_userid_get"
  action = "lambda:InvokeFunction"
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.demo.id}/${aws_api_gateway_deployment.demo_env.stage_name}/${aws_api_gateway_method.demo_users_userid_get_method.http_method}${aws_api_gateway_resource.demo_users_userid_resource.path}"
}

resource "aws_api_gateway_integration" "demo_users_userid_get_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.demo.id}"
  resource_id = "${aws_api_gateway_resource.demo_users_userid_resource.id}"
  http_method = "${aws_api_gateway_method.demo_users_userid_get_method.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.account_id}:function:${aws_lambda_function.demo_users_userid_get_function.function_name}/invocations"
  integration_http_method = "POST"

  request_templates = {                  
    "application/json" =  <<REQUEST_TEMPLATE
      {
        "userId": "$input.params('userId')"
      }
    REQUEST_TEMPLATE
  }
}
