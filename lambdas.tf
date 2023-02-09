resource "aws_lambda_function" "default_without_vpc" {
  count            = var.attach_vpc_config ? 0 : 1
  filename         = var.filename
  description      = var.description
  source_code_hash = filebase64sha256(var.filename)
  function_name    = var.function_name
  role             = var.role
  handler          = var.handler
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  publish          = var.publish

  # environment variables for the lambda function
  # environment {
  #   variables = var.environment
  # }
}

resource "aws_lambda_function" "default_with_vpc" {
  count            = var.attach_vpc_config ? 1 : 0
  filename         = var.filename
  description      = var.description
  source_code_hash = filebase64sha256(var.filename)
  function_name    = var.function_name
  role             = var.role
  handler          = var.handler
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  publish          = var.publish

  # environment variables for the lambda function
  environment {
    variables = var.environment
  }

  vpc_config {
    security_group_ids = var.vpc_config["security_group_ids"]
    subnet_ids         = var.vpc_config["subnet_ids"]
  }
}

resource "aws_lambda_function" "authorizer_without_vpc" {
  count            = length(var.authorizer_names) > 0 ? length(var.authorizer_names) : 0
  filename         = var.filename
  description      = var.description
  source_code_hash = filebase64sha256(var.filename)
  function_name    = "authorizer-lambda"
  role             = var.role
  handler          = var.handler
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  publish          = var.publish

  # environment variables for the lambda function
  # environment {
  #   variables = var.environment
  # }
}

resource "aws_lambda_function" "authorizer_with_vpc" {
  count            = length(var.authorizer_names) > 0 && var.attach_vpc_config ? length(var.authorizer_names) : 0
  filename         = var.filename
  description      = var.description
  source_code_hash = filebase64sha256(var.filename)
  function_name    = "authorizer-lambda"
  role             = var.role
  handler          = var.handler
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  publish          = var.publish

  # environment variables for the lambda function
  # environment {
  #   variables = var.environment
  # }

  vpc_config {
    security_group_ids = var.vpc_config["security_group_ids"]
    subnet_ids         = var.vpc_config["subnet_ids"]
  }
}

resource "aws_lambda_permission" "execute_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.attach_vpc_config ? aws_lambda_function.default_with_vpc[0].id : aws_lambda_function.default_without_vpc[0].id
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.default[0].execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "authorizer" {
  count         = length(var.authorizer_names)
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.attach_vpc_config ? aws_lambda_function.authorizer_with_vpc[count.index].id : aws_lambda_function.authorizer_without_vpc[count.index].id
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.default[0].execution_arn}/*/*/*"
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "authorizer" {
  count = length(var.authorizer_names)
  name              = "/aws/lambda/${element(var.authorizer_lambdas, count.index)}"
  retention_in_days = 14
}
