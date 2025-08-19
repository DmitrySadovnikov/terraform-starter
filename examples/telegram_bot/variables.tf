variable "telegram_bot_token" {
  type        = string
  description = "Telegram Bot Token, required for the bot to function."
}

variable "telegram_chat_id" {
  type        = string
  description = "Telegram Chat ID, required for sending messages to a specific chat or user."
}