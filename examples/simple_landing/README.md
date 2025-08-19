# Simple Landing Page Example

A basic serverless website that serves a static HTML page using AWS Lambda and API Gateway.

## 🚀 Quick Start

1. **Navigate to the example**
   ```bash
   cd examples/simple_landing
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Deploy the infrastructure**
   ```bash
   terraform apply
   ```

4. **Access your website**
   The deployment will output a URL where your website is available.

## 📁 Files

- `main.tf` - Terraform configuration
- `outputs.tf` - Output definitions
- `code/index.js` - Lambda function code
- `code/index.html` - HTML page content

## ⚙️ Configuration

### Basic Setup
The default configuration creates a simple landing page:

```hcl
module "simple_landing" {
  source       = "../../modules/serverless"
  project_name = "simple-landing"
  
  routes = {
    home = {
      method = "GET"
      path   = "/"
    }
  }
}
```

### Custom Domain (Optional)
To use a custom domain, uncomment and modify the domain_name:

```hcl
module "simple_landing" {
  source       = "../../modules/serverless"
  project_name = "simple-landing"
  domain_name  = "your-domain.com"  # Add your domain
  
  routes = {
    home = {
      method = "GET"
      path   = "/"
    }
  }
}
```

## 🔧 Customization

### Modify HTML Content
Edit `code/index.html` to change your page content:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Your Title</title>
</head>
<body>
    <h1>Your Content Here</h1>
</body>
</html>
```

### Add Styling
You can add CSS directly in the HTML file or serve additional static files through Lambda.

### Environment Variables
Add environment variables to your Lambda function:

```hcl
module "simple_landing" {
  source       = "../../modules/serverless"
  project_name = "simple-landing"
  
  envs = {
    SITE_NAME = "My Awesome Site"
    NODE_ENV  = "production"
  }
  
  routes = {
    home = {
      method = "GET"
      path   = "/"
    }
  }
}
```

## 📊 Outputs

After deployment, you'll get:

- `website_url` - URL of your deployed website
- `lambda_logs_url` - CloudWatch logs for debugging

## 💰 Costs

This example uses:
- AWS Lambda (free tier: 1M requests/month)
- API Gateway (free tier: 1M requests/month)
- CloudWatch Logs (minimal cost for logging)

Expected monthly cost: **$0-5** depending on traffic.

## 🔧 Troubleshooting

### Common Issues

**"Website not loading"**
- Check the Lambda function logs using the `lambda_logs_url` output
- Ensure the `code/index.html` file exists

**"Custom domain not working"**
- Verify DNS settings point to AWS Route 53
- Wait for SSL certificate validation (5-10 minutes)
- Run `terraform apply` again if needed

**"Permission denied"**
- Ensure your AWS CLI is configured with appropriate permissions
- Check IAM user has Lambda and API Gateway permissions

## 📈 Scaling

This architecture automatically scales:
- **Lambda**: Handles up to 1,000 concurrent executions
- **API Gateway**: No limits on requests per second
- **CloudWatch**: Automatic log aggregation

## 🚀 Next Steps

1. **Add More Pages**: Create additional routes in `main.tf`
2. **Add a Database**: Use the [Blog Example](../blog/) for database integration
3. **Add File Storage**: Use S3 for serving images and assets
4. **Add Analytics**: Integrate with CloudWatch metrics or external services

## 🔗 Related Examples

- [Blog API](../blog/) - Full-featured blog with database
- [Telegram Bot](../telegram_bot/) - Bot with webhook handling

---

[← Back to main documentation](../../README.md)
