# Simple Landing Page Example
# This creates a basic serverless website using AWS Lambda and API Gateway

module "simple_landing" {
  source       = "../../modules/serverless"
  project_name = "simple-landing"

  # Optional: Add your custom domain
  # domain_name = "example.com"

  routes = {
    home = {
      method = "GET"
      path   = "/"
    }
  }

  tags = {
    Example     = "simple-landing"
    Environment = "demo"
  }
}
