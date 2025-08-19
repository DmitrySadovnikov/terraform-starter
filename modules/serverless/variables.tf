variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where the resources will be created."
}

variable "project_name" {
  type        = string
  description = "Name of the project, used for naming resources."
  
  validation {
    condition = can(regex("^[a-z0-9-]+$", var.project_name)) && length(var.project_name) <= 50
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens, and be max 50 characters."
  }
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "development"
    ManagedBy   = "terraform"
  }
  description = "Tags to apply to all resources."
}

variable "lambda_timeout" {
  type        = number
  default     = 5
  description = "Timeout for the Lambda function in seconds."
}

variable "lambda_memory_size" {
  type        = number
  default     = 512
  description = "Memory size for the Lambda function in MB."
}

variable "envs" {
  type = map(string)
  default = {}
  description = "Environment variables to pass to the Lambda function."
}

variable "create_bucket" {
  type        = bool
  default     = false
  description = "Flag to create an S3 bucket for the bot."
}

variable "create_db" {
  type        = bool
  default     = false
  description = "Flag to create a DynamoDB table for the bot."
}

variable "routes" {
  description = "Map of API routes with their HTTP methods and paths."
  type = map(object({
    method = string
    path   = string
  }))
}

variable "domain_name" {
  type        = string
  default     = ""
  description = "Domain name for the API, used for custom domain setup."
}

variable "cron_jobs" {
  type = list(object({
    name = string
    cron = string
    path = string
  }))
  default = []
  description = "List of scheduled jobs with their names, cron expressions, and paths."
}
