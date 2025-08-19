# Blog API Example

A full-featured serverless blog with HTML templating, DynamoDB storage, and S3 image uploads.

## 🚀 Quick Start

1. **Navigate to the example**
   ```bash
   cd examples/blog
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Deploy the infrastructure**
   ```bash
   terraform apply
   ```

4. **Access your blog**
   The deployment will output a URL where your blog is available at `/blog`.

## 📁 Files

- `main.tf` - Terraform configuration
- `outputs.tf` - Output definitions  
- `code/index.js` - Lambda function with blog logic
- `code/blog-list.html` - HTML template for blog list
- `code/blog-post.html` - HTML template for individual posts

## 🏗️ Architecture

This example creates:
- **Lambda Function** - Handles blog operations
- **DynamoDB Table** - Stores blog posts
- **S3 Bucket** - Stores uploaded images
- **API Gateway** - Routes blog requests
- **CloudWatch Logs** - Application logging

## 📖 API Endpoints

- `GET /blog` - List all blog posts (HTML page)
- `GET /blog/{id}` - View individual blog post (HTML page)
- `POST /blog` - Create new blog post (JSON API)

## ⚙️ Configuration

### Basic Setup
The configuration automatically creates all necessary resources:

```hcl
module "blog_api" {
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
}
```

### Custom Domain (Optional)
Add a custom domain for your blog:

```hcl
module "blog_api" {
  source       = "../../modules/serverless"
  project_name = "blog"
  domain_name  = "your-domain.com"
  
  # ... rest of configuration
}
```

## 🖊️ Creating Blog Posts

### Via Web Interface
1. Visit your blog URL (`/blog`)
2. Use the form to create new posts
3. Upload images (optional)
4. Add tags (comma-separated)

### Via API
Send a POST request to `/blog` with JSON:

```json
{
  "title": "My First Post",
  "content": "This is the content of my blog post.",
  "author": "John Doe",
  "tags": ["tech", "tutorial"],
  "images": [
    {
      "data": "base64_encoded_image_data",
      "name": "image.jpg",
      "type": "image/jpeg"
    }
  ]
}
```

## 🗃️ Data Structure

Blog posts are stored in DynamoDB with this structure:

```json
{
  "pk": "post-uuid",
  "sk": "POST",
  "id": "post-uuid",
  "title": "Blog Post Title",
  "content": "Full post content",
  "author": "Author Name",
  "tags": ["tag1", "tag2"],
  "images": [
    {
      "id": "image-uuid",
      "url": "https://s3-bucket-url/path/to/image.jpg",
      "originalName": "image.jpg",
      "uploadedAt": "2024-01-01T12:00:00.000Z"
    }
  ],
  "createdAt": "2024-01-01T12:00:00.000Z",
  "updatedAt": "2024-01-01T12:00:00.000Z",
  "published": true
}
```

## 📊 Outputs

After deployment, you'll get:

- `blog_url` - URL of your blog
- `lambda_logs_url` - CloudWatch logs for debugging
- `database_table_name` - DynamoDB table name
- `storage_bucket_name` - S3 bucket name

## 🎨 Customization

### HTML Templates
Edit the HTML templates in the `code/` directory:

- `blog-list.html` - Main blog page layout
- `blog-post.html` - Individual post page layout

Templates use placeholder variables like `{{POST_TITLE}}` for dynamic content.

### Styling
Modify the CSS within the HTML templates to change the appearance.

### Features to Add
- Comment system
- Post categories
- Search functionality
- RSS feed
- Admin authentication

## 💰 Costs

This example uses:
- AWS Lambda (free tier: 1M requests/month)
- API Gateway (free tier: 1M requests/month)
- DynamoDB (free tier: 25GB storage)
- S3 (free tier: 5GB storage)
- CloudWatch Logs (minimal cost)

Expected monthly cost: **$0-10** depending on usage.

## 🔧 Troubleshooting

### Common Issues

**"Blog posts not saving"**
- Check Lambda logs using `lambda_logs_url`
- Verify DynamoDB table permissions
- Ensure images are properly base64 encoded

**"Images not displaying"**
- Check S3 bucket permissions
- Verify image uploads in S3 console
- Check browser console for CORS errors

**"Posts not listing"**
- Check DynamoDB table has items
- Verify DynamoDB scan permissions
- Check Lambda logs for errors

### Database Access
Monitor your DynamoDB table:
```bash
aws dynamodb scan --table-name $(terraform output -raw database_table_name)
```

### S3 Bucket Access
List uploaded images:
```bash
aws s3 ls s3://$(terraform output -raw storage_bucket_name) --recursive
```

## 📈 Scaling

This architecture automatically scales:
- **Lambda**: Up to 1,000 concurrent executions
- **DynamoDB**: On-demand scaling
- **S3**: Unlimited storage
- **API Gateway**: No request limits

## 🚀 Next Steps

1. **Add Authentication**: Implement user login and post ownership
2. **Add Comments**: Extend the data model for comments
3. **Add Search**: Implement full-text search with OpenSearch
4. **Add Categories**: Organize posts by categories
5. **Add RSS Feed**: Generate XML feeds for subscribers

## 🔗 Related Examples

- [Simple Landing](../simple_landing/) - Basic static website
- [Telegram Bot](../telegram_bot/) - Bot with webhook handling

---

[← Back to main documentation](../../README.md)
