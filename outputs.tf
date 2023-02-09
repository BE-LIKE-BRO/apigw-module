output "id" {
  value       = aws_api_gateway_rest_api.default[0].id
  description = "The ID of the REST API."
}

output "execution_arn" {
  value       = aws_api_gateway_rest_api.default[0].execution_arn
  description = "The Execution ARN of the REST API."
}

# output "tags" {
#   value       = module.labels.tags
#   description = "A mapping of tags to assign to the resource."
# }