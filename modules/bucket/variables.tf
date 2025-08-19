variable "project_name" {
  type        = string
  description = "Name of the project, used for naming the S3 bucket."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all S3 resources."
}

