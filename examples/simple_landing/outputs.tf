output "website_url" {
  description = "URL of the deployed website"
  value       = module.simple_landing.api_url
}

output "lambda_logs_url" {
  description = "CloudWatch logs URL for the Lambda function"
  value       = module.simple_landing.lambda_logs_url
}

output "ns_records" {
  description = "NS records for the domain"
  value       = module.simple_landing.ns_records
}
