# Blog Example
# This creates a serverless blog with DynamoDB for posts and S3 for images

module "blog" {
  source       = "../../modules/serverless"
  project_name = "blog"

  # Blog routes
  routes = {
    list_posts = {
      method = "GET"
      path   = "/blog"
    }
    get_post = {
      method = "GET"
      path   = "/blog/{id}"
    }
    create_post = {
      method = "POST"
      path   = "/blog"
    }
  }

  # Enable database and file storage
  create_db     = true
  create_bucket = true

  # Optional: Add your custom domain
  # domain_name = "example.com"

  tags = {
    Example     = "blog"
    Environment = "demo"
  }
}
