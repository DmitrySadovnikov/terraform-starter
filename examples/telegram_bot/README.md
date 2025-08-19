# Telegram Bot Example

A serverless Telegram bot with webhook support and scheduled tasks using AWS Lambda and API Gateway.

## 🚀 Quick Start

1. **Create a Telegram Bot**
   - Message [@BotFather](https://t.me/BotFather) on Telegram
   - Use `/newbot` command and follow instructions
   - Save your bot token

2. **Configure Variables**
   Create `terraform.tfvars` file:
   ```hcl
   telegram_bot_token = "your_bot_token_here"
   telegram_chat_id   = "your_chat_id_here"  # Optional for scheduled messages
   ```

3. **Navigate to the example**
   ```bash
   cd examples/telegram_bot
   ```

4. **Initialize and Deploy**
   ```bash
   terraform init
   terraform apply
   ```

5. **Test Your Bot**
   The webhook will be set automatically. Send a message to your bot!

## 📁 Files

- `main.tf` - Terraform configuration
- `outputs.tf` - Output definitions
- `variables.tf` - Variable definitions
- `terraform.tfvars.example` - Example variables file
- `code/index.js` - Lambda function with bot logic

## 🏗️ Architecture

This example creates:
- **Lambda Function** - Handles bot messages and scheduled tasks
- **API Gateway** - Receives webhook requests from Telegram
- **CloudWatch Logs** - Application logging
- **EventBridge** - Scheduled task triggers (optional)

## ⚙️ Configuration

### Basic Setup

```hcl
module "telegram_bot" {
  source       = "../../modules/serverless"
  project_name = "telegram-bot"
  
  # Bot routes
  routes = {
    webhook = {
      method = "POST"
      path   = "/"
    }
    cron_task = {
      method = "POST"
      path   = "/cron/hello"
    }
  }
  
  # Bot configuration
  envs = {
    TELEGRAM_BOT_TOKEN = var.telegram_bot_token
    TELEGRAM_CHAT_ID   = var.telegram_chat_id
  }
  
  # Scheduled tasks (optional)
  cron_jobs = [
    {
      name = "hello"
      cron = "cron(0 * * * ? *)" # Every hour
      path = "/cron/hello"
    }
  ]
}
```

### Variables

Required variables in `terraform.tfvars`:

```hcl
# Required: Your bot token from @BotFather
telegram_bot_token = "1234567890:ABCdefGHIjklMNOpqrsTUVwxyz"

# Optional: Chat ID for scheduled messages
telegram_chat_id = "123456789"
```

### Custom Domain (Optional)

Add a custom domain for your webhook:

```hcl
module "telegram_bot" {
  source      = "../../modules/serverless"
  project_name = "telegram-bot"
  domain_name = "bot.your-domain.com"
  
  # ... rest of configuration
}
```

## 🤖 Bot Features

### Message Handling
The bot can respond to:
- Text messages
- Commands (e.g., `/start`, `/help`)
- Media files
- Inline queries

### Scheduled Tasks
Optional cron jobs can:
- Send periodic messages
- Perform maintenance tasks
- Fetch external data

### Example Bot Logic

```javascript
exports.handler = async (event) => {
  if (event.message) {
    // Handle incoming message
    const chatId = event.message.chat.id;
    const text = event.message.text;
    
    if (text === '/start') {
      await sendMessage(chatId, 'Hello! I\'m your bot.');
    }
  }
  
  if (event.path === '/cron/hello') {
    // Handle scheduled task
    await sendMessage(process.env.TELEGRAM_CHAT_ID, 'Scheduled hello!');
  }
};
```

## 📊 Outputs

After deployment, you'll get:

- `webhook_url` - Telegram webhook URL (automatically configured)
- `lambda_logs_url` - CloudWatch logs for debugging

## 🔧 Getting Chat IDs

To get your chat ID for scheduled messages:

1. Start a chat with your bot
2. Send any message
3. Check the Lambda logs to see the chat ID
4. Update your `terraform.tfvars` with the chat ID

## 💰 Costs

This example uses:
- AWS Lambda (free tier: 1M requests/month)
- API Gateway (free tier: 1M requests/month)
- EventBridge (free tier: 1M events/month)
- CloudWatch Logs (minimal cost)

Expected monthly cost: **$0-5** depending on usage.

## 🔧 Troubleshooting

### Common Issues

**"Bot not responding"**
- Check Lambda logs using `webhook_logs_url`
- Verify bot token is correct
- Ensure webhook URL is accessible

**"Scheduled messages not working"**
- Check EventBridge rules in AWS console
- Verify `telegram_chat_id` is correct
- Check Lambda logs for errors

**"Webhook not set"**
- Check if `null_resource.telegram_webhook` executed
- Manually set webhook: `curl -X POST https://api.telegram.org/bot<TOKEN>/setWebhook?url=<WEBHOOK_URL>`

**"Custom domain issues"**
- Wait for SSL certificate validation (5-10 minutes)
- Check DNS settings point to AWS Route 53
- Run `terraform apply` again if needed

### Manual Webhook Setup

If automatic webhook setup fails:

```bash
curl -X POST "https://api.telegram.org/bot<YOUR_BOT_TOKEN>/setWebhook?url=<YOUR_WEBHOOK_URL>"
```

### Testing Webhook

Check if webhook is set:

```bash
curl "https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getWebhookInfo"
```

## 📈 Scaling

This architecture automatically scales:
- **Lambda**: Up to 1,000 concurrent executions
- **API Gateway**: No request limits
- **EventBridge**: No event limits

## 🚀 Bot Ideas

Extend your bot with these features:

1. **Database Integration**: Store user data with DynamoDB
2. **File Storage**: Handle media with S3
3. **External APIs**: Integrate with weather, news, or other services
4. **User Management**: Track users and preferences
5. **Analytics**: Monitor bot usage and metrics

## 🔗 Useful Telegram Bot Resources

- [Telegram Bot API](https://core.telegram.org/bots/api)
- [BotFather Commands](https://core.telegram.org/bots#6-botfather)
- [Webhook Guide](https://core.telegram.org/bots/webhooks)

## 🔗 Related Examples

- [Simple Landing](../simple_landing/) - Basic static website
- [Blog](../blog/) - Full-featured blog with database

---

[← Back to main documentation](../../README.md)
