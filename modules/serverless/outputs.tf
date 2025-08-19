output "api_url" {
  description = "API Gateway URL"
  value       = var.domain_name != "" ? "https://${var.domain_name}/" : "${aws_apigatewayv2_api.main.api_endpoint}/${local.stage_name}/"
}

output "ns_records" {
  description = "NS records for the domain"
  value       = var.domain_name != "" ? module.domain[0].ns_records : null
}

output "lambda_logs_url" {
  description = "CloudWatch logs URL for Lambda function"
  value       = "https://${var.region}.console.aws.amazon.com/cloudwatch/home?region=${var.region}#logsV2:log-groups/log-group/$252Faws$252Flambda$252F${aws_lambda_function.api.function_name}/log-events"
}

output "api_gateway_logs_url" {
  description = "CloudWatch logs URL for API Gateway"
  value       = "https://${var.region}.console.aws.amazon.com/cloudwatch/home?region=${var.region}#logsV2:log-groups/log-group/$252Faws$252Fapigateway$252F${aws_apigatewayv2_api.main.name}/log-events"
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.api.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.api.function_name
}

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = aws_apigatewayv2_api.main.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = var.create_db ? aws_dynamodb_table.main[0].name : null
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = var.create_bucket ? module.s3_bucket[0].bucket_name : null
}
