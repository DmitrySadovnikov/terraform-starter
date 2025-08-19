output "webhook_url" {
  description = "URL for Telegram webhook"
  value       = module.telegram_bot.api_url
}

output "lambda_logs_url" {
  description = "CloudWatch logs URL for the Lambda function"
  value       = module.telegram_bot.lambda_logs_url
}

output "ns_records" {
  description = "NS records for the domain"
  value       = module.telegram_bot.ns_records
}
