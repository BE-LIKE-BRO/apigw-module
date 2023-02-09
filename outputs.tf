output "id" {
  value       = aws_api_gateway_rest_api.default[0].id
  description = "The ID of the REST API."
}

output "execution_arn" {
  value       = aws_api_gateway_rest_api.default[0].execution_arn
  description = "The Execution ARN of the REST API."
}

output "lambda_default_invoke_arn" {
  value       = var.attach_vpc_config ? aws_lambda_function.default_with_vpc[0].invoke_arn : aws_lambda_function.default_without_vpc[0].invoke_arn
  description = "The Execution ARN of the REST API."
}


output "authorizer_invoke_arn" {
  value       = var.attach_vpc_config ? aws_lambda_function.authorizer_with_vpc[0].invoke_arn : aws_lambda_function.authorizer_without_vpc[0].invoke_arn
  description = "The Execution ARN of the REST API."
}

# output "tags" {
#   value       = module.labels.tags
#   description = "A mapping of tags to assign to the resource."
# }



