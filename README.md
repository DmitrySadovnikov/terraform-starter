# Terraform Starter

A production-ready Terraform boilerplate for building serverless APIs on AWS. This project provides a complete infrastructure-as-code solution for deploying scalable serverless applications with AWS Lambda, API Gateway, DynamoDB, and S3.

This starter is valuable for SaaS and startups that need quick prototyping with a minimum budget (less than $1 a month per project).

[![Watch the video](https://github.com/user-attachments/assets/f0ee1ea0-7f18-4565-83f9-a450141d82ee)](https://youtu.be/Kty_2gO_hvA)

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone git@github.com:DmitrySadovnikov/terraform-starter.git
   cd terraform-starter
   ```

2. **Choose an example**
   - [Simple Landing Page](examples/simple_landing/) - Basic HTML page
   - [Blog](examples/blog/) - Full-featured blog with database and file storage
   - [Telegram Bot](examples/telegram_bot/) - Serverless bot with webhooks and scheduling

3. **Deploy**
   ```bash
   cd examples/simple_landing
   terraform init
   terraform apply
   ```

## 📁 Project Structure

```
terraform-starter/
├── modules/
│   ├── serverless/      # Main serverless module
│   └── bucket/          # S3 bucket module
└── examples/
    ├── simple_landing/  # Basic website example
    ├── blog/            # Blog with database
    └── telegram_bot/    # Telegram bot example
```

## 🏗️ Architecture

The boilerplate creates a serverless architecture using:

- **AWS Lambda** - Server-side logic execution
- **API Gateway** - HTTP API management and routing
- **DynamoDB** - NoSQL database (optional)
- **S3** - File storage (optional)
- **CloudWatch** - Logging and monitoring
- **Route 53** - Custom domain support (optional)

## 📖 Examples

### [Simple Landing Page](examples/simple_landing/)
Perfect for static websites and landing pages.
- ✅ Single HTML page
- ✅ Custom domain support
- ✅ CDN-ready

### [Blog](examples/blog/)
Full-featured blog with HTML templates and REST API.
- ✅ Create, read, and list blog posts
- ✅ Image upload to S3
- ✅ DynamoDB storage
- ✅ HTML templating

### [Telegram Bot](examples/telegram_bot/)
Serverless Telegram bot with webhook support.
- ✅ Webhook handling
- ✅ Scheduled tasks
- ✅ Message processing

## 🛠️ Features

- **Zero Configuration** - Works out of the box
- **Production Ready** - Includes security, monitoring, and best practices
- **Cost Optimized** - Pay-per-use serverless architecture
- **Scalable** - Automatic scaling with demand
- **Secure** - IAM roles with least privilege principle
- **Observable** - CloudWatch logging and monitoring
- **Customizable** - Easy to extend and modify

## 📋 Requirements

- [Terraform](https://www.terraform.io/) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate permissions
- AWS Account with the following services enabled:
  - AWS Lambda
  - API Gateway
  - DynamoDB (for database examples)
  - S3 (for storage examples)
  - Route 53 (for custom domains)

## 🔧 Configuration

### Basic Configuration

```hcl
module "my_api" {
  source       = "../../modules/serverless"
  project_name = "my-project"
  
  routes = {
    home = {
      method = "GET"
      path   = "/"
    }
  }
}
```

### Advanced Configuration

```hcl
module "my_api" {
  source       = "../../modules/serverless"
  project_name = "my-project"
  
  # Custom domain
  domain_name = "example.com"
  
  # Enable database and storage
  create_db     = true
  create_bucket = true
  
  # Lambda configuration
  lambda_timeout     = 30
  lambda_memory_size = 256
  
  # Environment variables
  envs = {
    NODE_ENV = "production"
    API_KEY  = "your-api-key"
  }
  
  # Scheduled tasks
  cron_jobs = [
    {
      name = "cleanup"
      cron = "cron(0 2 * * ? *)"  # Daily at 2 AM
      path = "/cron/cleanup"
    }
  ]
  
  # Custom tags
  tags = {
    Environment = "production"
    Team        = "backend"
  }
}
```

## 🌐 Custom Domains

To use a custom domain:

1. **Set domain_name** in your configuration
2. **Run terraform apply** - This will create a hosted zone with your domain name and SSL certificate. You may see an error "Certificate not yet issued" - this is expected.
3. **Update DNS** - Point your domain's nameservers to AWS Route 53. The NS records will be provided in the terraform output.
4. **Wait for certificate** - SSL certificate validation typically takes 5-10 minutes
5. **Apply again if needed** - Run `terraform apply` again after DNS propagation completes

**Note**: The initial apply may fail due to certificate validation. This is normal - just wait for DNS propagation and run `terraform apply` again.

## 📊 Monitoring

Access your application logs and metrics:

- **Lambda Logs**: Available in outputs as `lambda_logs_url`
- **API Gateway Logs**: Available in outputs as `api_gateway_logs_url`
- **CloudWatch Metrics**: Automatic monitoring for all resources

## 🔒 Security

The boilerplate follows AWS security best practices:

- ✅ IAM roles with minimal permissions
- ✅ S3 bucket encryption
- ✅ DynamoDB encryption
- ✅ HTTPS-only API Gateway
- ✅ CloudWatch logging

## 💰 Cost Optimization

Serverless architecture means you only pay for what you use:

- **Lambda**: First 1M requests/month free
- **API Gateway**: First 1M requests/month free
- **DynamoDB**: 25GB free tier
- **S3**: 5GB free tier

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Troubleshooting

### Common Issues

**Certificate not yet issued**
- Wait 5-10 minutes for DNS propagation
- Run `terraform apply` again

**Lambda deployment fails**
- Ensure your `code/` directory contains `index.js`
- Check that the handler is correctly set to `index.handler`

**Permission denied errors**
- Verify your AWS CLI configuration
- Ensure your AWS user has the necessary permissions

### Getting Help

- 📖 Check the [example README files](examples/) for detailed guides
- 🐛 [Open an issue](../../issues) for bugs
- 💡 [Start a discussion](../../discussions) for questions

---

Made with ❤️ for the serverless community
