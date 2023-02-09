resource "aws_api_gateway_rest_api" "default" {
  count = var.enabled ? 1 : 0

  name        = var.name
  description = var.description
  # binary_media_types       = var.binary_media_types
  minimum_compression_size = var.minimum_compression_size
  api_key_source           = var.api_key_source

  endpoint_configuration {
    types            = var.endpoint_types
    vpc_endpoint_ids = length(var.vpc_endpoint_ids) > 0 && var.vpc_endpoint_ids[0] != "" ? var.vpc_endpoint_ids : null
  }
  policy = var.api_policy
  tags   = var.tags
}

resource "aws_api_gateway_resource" "default" {
  count       = length(var.path_parts) > 0 ? length(var.path_parts) : 0
  rest_api_id = aws_api_gateway_rest_api.default[0].id
  parent_id   = aws_api_gateway_rest_api.default[0].root_resource_id
  path_part   = element(var.path_parts, count.index)
}

resource "aws_api_gateway_method" "default" {
  count = length(var.path_parts) > 0 ? length(var.path_parts) : 0

  rest_api_id   = aws_api_gateway_rest_api.default[0].id
  resource_id   = aws_api_gateway_resource.default[count.index].id
  http_method   = element(var.http_methods, count.index)
  authorization = length(var.authorization) > 0 ? element(var.authorization, count.index) : "NONE"
}

resource "aws_api_gateway_method_response" "default" {
  count       = length(aws_api_gateway_method.default.*.id)
  rest_api_id = aws_api_gateway_rest_api.default[0].id
  resource_id = aws_api_gateway_resource.default[count.index].id
  http_method = aws_api_gateway_method.default[count.index].http_method
  status_code = 200
  status_codes         = element(var.status_codes, count.index)
  response_models     = length(var.response_models) > 0 ? element(var.response_models, count.index) : {}
  response_parameters = length(var.response_parameters) > 0 ? element(var.response_parameters, count.index) : {}
}

resource "aws_api_gateway_integration" "default" {
  count                   = length(aws_api_gateway_method.default.*.id)
  rest_api_id             = aws_api_gateway_rest_api.default[0].id
  resource_id             = aws_api_gateway_resource.default[count.index].id
  http_method             = aws_api_gateway_method.default.*.http_method[count.index]
  integration_http_method = length(var.integration_http_methods) > 0 ? element(var.integration_http_methods, count.index) : null
  type                    = length(var.integration_types) > 0 ? element(var.integration_types, count.index) : "AWS_PROXY"
  connection_type         = length(var.connection_types) > 0 ? element(var.connection_types, count.index) : "INTERNET"
  connection_id           = length(var.connection_ids) > 0 ? element(var.connection_ids, count.index) : ""
  uri                     = length(var.uri) > 0 ? element(var.uri, count.index) : aws_lambda_function.default_without_vpc[0].invoke_arn
  credentials             = length(var.credentials) > 0 ? element(var.credentials, count.index) : ""
  request_parameters      = length(var.request_parameters) > 0 ? element(var.request_parameters, count.index) : {}
  request_templates       = length(var.request_templates) > 0 ? element(var.request_templates, count.index) : {}
  passthrough_behavior    = length(var.passthrough_behaviors) > 0 ? element(var.passthrough_behaviors, count.index) : null
  timeout_milliseconds    = length(var.timeout_milliseconds) > 0 ? element(var.timeout_milliseconds, count.index) : 29000
  depends_on              = [aws_api_gateway_method.default]
}

resource "aws_api_gateway_deployment" "default" {
  count = var.deployment_enabled ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.default[0].id
  stage_name  = var.stage_name
  variables   = var.variables
  depends_on  = [aws_api_gateway_method.default, aws_api_gateway_integration.default]
}

resource "aws_api_gateway_stage" "without_logs" {
  count = var.deployment_enabled && var.stage_enabled && length(var.stage_names) > 0 ? length(var.stage_names) : 0 

  rest_api_id           = aws_api_gateway_rest_api.default[0].id
  deployment_id         = aws_api_gateway_deployment.default[0].id
  stage_name            = element(var.stage_names, count.index)
  client_certificate_id = length(var.client_certificate_ids) > 0 ? element(var.client_certificate_ids, count.index) : (var.cert_enabled ? aws_api_gateway_client_certificate.default[0].id : "")
  variables             = length(var.stage_variables) > 0 ? element(var.stage_variables, count.index) : {}
}

resource "aws_api_gateway_stage" "with_logs" {
  count = var.deployment_enabled && var.stage_enabled && var.api_log_enabled && length(var.stage_names) > 0 ? length(var.stage_names) : 0

  rest_api_id           = aws_api_gateway_rest_api.default[0].id
  deployment_id         = aws_api_gateway_deployment.default[0].id
  stage_name            = element(var.stage_names, count.index)
  cache_cluster_enabled = length(var.enabled_cache_clusters) > 0 ? element(var.enabled_cache_clusters, count.index) : false
  cache_cluster_size    = length(var.cache_cluster_sizes) > 0 ? element(var.cache_cluster_sizes, count.index) : null
  client_certificate_id = length(var.client_certificate_ids) > 0 ? element(var.client_certificate_ids, count.index) : (var.cert_enabled ? aws_api_gateway_client_certificate.default[0].id : "")
  description           = length(var.stage_description) > 0 ? element(var.stage_description, count.index) : ""
  documentation_version = length(var.documentation_versions) > 0 ? element(var.documentation_versions, count.index) : null
  variables             = length(var.stage_variables) > 0 ? element(var.stage_variables, count.index) : {}
  xray_tracing_enabled  = length(var.xray_tracing_enabled) > 0 ? element(var.xray_tracing_enabled, count.index) : false
  access_log_settings {
    destination_arn = element(var.destination_arns, count.index)
    format          = element(var.formats, count.index)
  }
}

resource "aws_api_gateway_client_certificate" "default" {
  count       = var.cert_enabled ? 1 : 0
  description = var.cert_description
}

resource "aws_api_gateway_authorizer" "default" {
  count                            = var.authorizer_count > 0 ? var.authorizer_count : 0
  rest_api_id                      = aws_api_gateway_rest_api.default[0].id
  name                             = element(var.authorizer_names, count.index)
  authorizer_uri                   = length(var.authorizer_uri) > 0 ? element(var.authorizer_uri, count.index) : aws_lambda_function.authorizer_without_vpc[count.index].invoke_arn
  authorizer_credentials           = length(var.authorizer_credentials) > 0 ? element(var.authorizer_credentials, count.index) : ""
  authorizer_result_ttl_in_seconds = length(var.authorizer_result_ttl_in_seconds) > 0 ? element(var.authorizer_result_ttl_in_seconds, count.index) : 300
  identity_source                  = length(var.identity_sources) > 0 ? element(var.identity_sources, count.index) : "method.request.header.Authorization"
  type                             = length(var.authorizer_types) > 0 ? element(var.authorizer_types, count.index) : "TOKEN"
  identity_validation_expression   = length(var.identity_validation_expressions) > 0 ? element(var.identity_validation_expressions, count.index) : ""
  provider_arns                    = length(var.provider_arns) > 0 ? element(var.provider_arns, count.index) : null
}