variable "handler" {
  type        = string
  default     = "code.handler"
  description = ""
}

variable "role" {
  type        = string
  default     = "arn:aws:iam::781604141791:role/service-role/apigw-test-role-snil20xr"
  description = ""
}

variable "runtime" {
  type        = string
  default     = "nodejs18.x"
  description = ""
}

variable "memory_size" {
  type        = number
  default     = 512
  description = ""
}

variable "timeout" {
  type        = number
  default     = 3
  description = ""
}

variable "publish" {
  type        = bool
  default     = true
  description = ""
}

variable "function_name" {
  type        = string
  default     = "test-apigw-lambda"
  description = ""
}

variable "authorizer_lambdas" {
  type        = list(string)
  default     = ["authorizer-lambda"]
  description = ""
}

variable "filename" {
  type        = string
  default     = ""
  description = ""
}

variable "authorizer_file" {
  type        = string
  default     = ""
  description = ""
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of the REST API "
}

variable "name" {
  type        = string
  default     = "testAPI"
  description = "Name of API Gateway"
}

variable "binary_media_types" {
  type        = list(any)
  default     = ["UTF-8-encoded"]
  description = "List of binary media types supported by the REST API"
}

variable "minimum_compression_size" {
  type        = number
  default     = -1
  description = "Minimum response size to compress for the REST API"
}

variable "api_key_source" {
  type        = string
  default     = "HEADER"
  description = "The source of the API key for requests. Valid values are HEADER (default) and AUTHORIZER."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to create rest api."
}

variable "vpc_endpoint_ids" {
  type        = list(string)
  default     = [""]
  description = "Set of VPC Endpoint identifiers. It is only supported for PRIVATE endpoint type."
}

variable "endpoint_types" {
  type        = list(any)
  default     = ["REGIONAL"]
  description = "List of endpoint types"
}

variable "api_policy" {
  default     = null
  description = "API policy document."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "API tags"
}

variable "path_parts" {
  type        = list(any)
  default     = ["{proxy+}"]
  description = "The last path segment of this API resource."
}

variable "http_methods" {
  type        = list(any)
  default     = ["ANY"]
  description = "The HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)."
}

variable "authorization" {
  type        = list(any)
  default     = []
  description = "The type of authorization used for the method (NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS)."
}

variable "integration_http_methods" {
  type        = list(any)
  default     = ["POST"]
  description = "The integration HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONs, ANY, PATCH) specifying how API Gateway will interact with the back end. Required if type is AWS, AWS_PROXY, HTTP or HTTP_PROXY. Lambda function can only be invoked via POST."
}

variable "integration_types" {
  type        = list(any)
  default     = ["AWS_PROXY"]
  description = "Valid values are HTTP (for HTTP backends), MOCK (not calling any real backend), AWS (for AWS services), AWS_PROXY (for Lambda proxy integration) and HTTP_PROXY (for HTTP proxy integration)."
}

variable "connection_types" {
  type        = list(any)
  default     = ["INTERNET"]
  description = "The integration input's connectionType. Valid values are INTERNET (default for connections through the public routable internet), and VPC_LINK (for private connections between API Gateway and a network load balancer in a VPC)."
  sensitive   = true
}

variable "connection_ids" {
  type        = list(any)
  default     = []
  description = "The id of the VpcLink used for the integration. Required if connection_type is VPC_LINK."
  sensitive   = true
}

variable "uri" {
  type        = list(any)
  default     = []
  description = "The input's URI. Required if type is AWS, AWS_PROXY, HTTP or HTTP_PROXY. For HTTP integrations, the URI must be a fully formed, encoded HTTP(S) URL according to the RFC-3986 specification . For AWS integrations, the URI should be of the form arn:aws:apigateway:{region}:{subdomain.service|service}:{path|action}/{service_api}. region, subdomain and service are used to determine the right endpoint. e.g. arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:012345678901:function:my-func/invocations."
  sensitive   = true
}

variable "credentials" {
  type        = list(any)
  default     = []
  description = "The credentials required for the integration. For AWS integrations, 2 options are available. To specify an IAM Role for Amazon API Gateway to assume, use the role's ARN. To require that the caller's identity be passed through from the request, specify the string arn:aws:iam::*:user/*."
  sensitive   = true
}

variable "request_parameters" {
  type        = list(any)
  default     = []
  description = "A map of request query string parameters and headers that should be passed to the integration. For example: request_parameters = {\"method.request.header.X-Some-Header\" = true \"method.request.querystring.some-query-param\" = true} would define that the header X-Some-Header and the query string some-query-param must be provided in the request."
}

variable "request_templates" {
  type        = list(any)
  default     = []
  description = "A map of the integration's request templates."
  sensitive   = true
}

variable "passthrough_behaviors" {
  type        = list(any)
  default     = []
  description = "The integration passthrough behavior (WHEN_NO_MATCH, WHEN_NO_TEMPLATES, NEVER). Required if request_templates is used."
}

variable "timeout_milliseconds" {
  type        = list(any)
  default     = []
  description = "Custom timeout between 50 and 29,000 milliseconds. The default value is 29,000 milliseconds."
}

variable "deployment_enabled" {
  type        = bool
  default     = true
  description = "Whether to create rest api."
}

variable "stage_descriptions" {
  type        = string
  default     = ""
  description = "The description of the stage."
}

variable "variables" {
  type        = map(any)
  default     = {}
  description = "A map that defines variables for the stage."
}

variable "stage_variables" {
  type        = map(any)
  default     = {}
  description = "A map that defines variables for the stage."
}

variable "stage_name" {
  type        = string
  default     = "test2"
  description = "The name of the stage to deploy"
}

variable "stage_names" {
  type        = list(any)
  default     = ["test2"]
  description = "The name of the stage."
}

variable "client_certificate_ids" {
  type        = list(any)
  default     = []
  description = "The identifier of a client certificate for the stage"
  sensitive   = true
}

variable "cert_enabled" {
  type        = bool
  default     = false
  description = "Whether to create client certificate."
}

variable "cert_description" {
  type        = string
  default     = ""
  description = "The description of the client certificate."
}

variable "stage_enabled" {
  type        = bool
  default     = false
  description = "Should stage for rest api be created?"
}

variable "authorizer_names" {
  type        = list(any)
  default     = ["authorizer1"]
  description = "Authorizer names"
}

variable "authorizer_uri" {
  type        = list(any)
  default     = []
  description = "The authorizer's Uniform Resource Identifier (URI). This must be a well-formed Lambda function URI in the form of arn:aws:apigateway:{region}:lambda:path/{service_api}, e.g. arn:aws:apigateway:us-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-2:012345678912:function:my-function/invocations."
  sensitive   = true
}

variable "authorizer_credentials" {
  type        = list(any)
  default     = []
  description = "The credentials required for the authorizer. To specify an IAM Role for API Gateway to assume, use the IAM Role ARN."
  sensitive   = true
}

variable "authorizer_result_ttl_in_seconds" {
  type        = list(any)
  default     = []
  description = "The TTL of cached authorizer results in seconds. Defaults to 300."
}

variable "identity_sources" {
  type        = list(any)
  default     = []
  description = "The source of the identity in an incoming request. Defaults to method.request.header.Authorization. For REQUEST type, this may be a comma-separated list of values, including headers, query string parameters and stage variables - e.g. \"method.request.header.SomeHeaderName,method.request.querystring.SomeQueryStringName\"."
}

variable "authorizer_types" {
  type        = list(any)
  default     = []
  description = "The type of the authorizer. Possible values are TOKEN for a Lambda function using a single authorization token submitted in a custom header, REQUEST for a Lambda function using incoming request parameters, or COGNITO_USER_POOLS for using an Amazon Cognito user pool. Defaults to TOKEN."
}

variable "identity_validation_expressions" {
  type        = list(any)
  default     = []
  description = "A validation expression for the incoming identity. For TOKEN type, this value should be a regular expression. The incoming token from the client is matched against this expression, and will proceed if the token matches. If the token doesn't match, the client receives a 401 Unauthorized response."
}

variable "provider_arns" {
  type        = list(any)
  default     = []
  description = "required for type COGNITO_USER_POOLS) A list of the Amazon Cognito user pool ARNs. Each element is of this format: arn:aws:cognito-idp:{region}:{account_id}:userpool/{user_pool_id}."
  sensitive   = true
}

variable "api_log_enabled" {
  type        = bool
  default     = false
  description = "should logging be enabled for rest api."
}

variable "cache_cluster_sizes" {
  type        = list(any)
  default     = []
  description = "The size of the cache cluster for the stage, if enabled. Allowed values include 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118 and 237."
}

variable "stage_description" {
  type        = string
  default     = ""
  description = "The description of the Stage "
}

variable "documentation_versions" {
  type        = list(any)
  default     = []
  description = "The version of the associated API documentation."
}

variable "xray_tracing_enabled" {
  type        = list(any)
  default     = []
  description = "Should xray_tracing be enabled for this resource?"
}

variable "destination_arns" {
  type        = list(any)
  default     = []
  description = "ARN of the log group to send the logs to. Automatically removes trailing ':*' if present."
  sensitive   = true
}

variable "formats" {
  type        = list(any)
  default     = []
  description = "The formatting and values recorded in the logs."
}

variable "enabled_cache_clusters" {
  type        = list(any)
  default     = []
  description = "Specifies whether a cache cluster is enabled for the stage."
}

variable "attach_vpc_config" {
  description = "Set this to true if using the vpc_config variable"
  default     = false
  type        = bool
}

variable "vpc_config" {
  description = "VPC configuration for the Lambda function"
  default     = {}
  type        = map(any)
}

variable "environment" {
  description = "Environment configuration for the Lambda function"
  default     = {}
  type        = map(any)
}

variable "status_codes" {
  type        = list(any)
  default     = ["200"]
  description = "The HTTP status code."
}

variable "response_models" {
  type        = list(any)
  default     = []
  description = "A map of the API models used for the response's content type."
}

variable "response_parameters" {
  type        = list(any)
  default     = []
  description = "A map of response parameters that can be sent to the caller. For example: response_parameters = { \"method.response.header.X-Some-Header\" = true } would define that the header X-Some-Header can be provided on the response."
}