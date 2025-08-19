output "blog_url" {
  description = "URL of the blog"
  value       = "${module.blog.api_url}blog"
}

output "lambda_logs_url" {
  description = "CloudWatch logs URL for the Lambda function"
  value       = module.blog.lambda_logs_url
}

output "database_table_name" {
  description = "Name of the DynamoDB table for blog posts"
  value       = module.blog.dynamodb_table_name
}

output "storage_bucket_name" {
  description = "Name of the S3 bucket for images"
  value       = module.blog.s3_bucket_name
}

output "ns_records" {
  description = "NS records for the domain"
  value       = module.blog.ns_records
}
