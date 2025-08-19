# Telegram Bot Example
# This creates a serverless Telegram bot with webhook support and scheduled tasks

locals {
  webhook_path    = "/"
  cron_hello_path = "/cron/hello"
}

moved {
  from = module.api
  to = module.telegram_bot
}

module "telegram_bot" {
  source       = "../../modules/serverless"
  project_name = "telegram-bot"

  # Bot routes
  routes = {
    webhook = {
      method = "POST"
      path   = local.webhook_path
    }
    cron_task = {
      method = "POST"
      path   = local.cron_hello_path
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
      cron = "cron(0 * * * ? *)" # Runs every hour
      path = local.cron_hello_path
    }
  ]

  tags = {
    Example     = "telegram-bot"
    Environment = "demo"
  }
}

# Set up Telegram webhook
resource "null_resource" "telegram_webhook" {
  provisioner "local-exec" {
    command = "curl -X POST https://api.telegram.org/bot${var.telegram_bot_token}/setWebhook?url=${module.telegram_bot.api_url}"
  }

  triggers = {
    api_url   = module.telegram_bot.api_url
    bot_token = var.telegram_bot_token
  }

  depends_on = [module.telegram_bot]
}
