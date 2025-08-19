const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN;
const TELEGRAM_CHAT_ID = process.env.TELEGRAM_CHAT_ID
const TELEGRAM_API_URL = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}`;

exports.handler = async (event) => {
  console.log('Event:', JSON.stringify(event, null, 2));

  const resource = event.resource;

  try {
    if (resource === '/') {
      return await handleTelegramWebhook(event);
    } else if (resource === '/cron/hello') {
      return await handleScheduledHello();
    }

    return {
      statusCode: 404,
      body: JSON.stringify({ message: 'Not found' })
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};

async function handleTelegramWebhook(event) {
  const body = JSON.parse(event.body || '{}');

  if (body.message && body.message.text) {
    const chatId = body.message.chat.id;
    await sendMessage(chatId, 'hello from API');
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'OK' })
  };
}

async function handleScheduledHello() {
  await sendMessage(TELEGRAM_CHAT_ID, 'hello from Cron job');

  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Scheduled message sent' })
  };
}

async function sendMessage(chatId, text) {
  const response = await fetch(`${TELEGRAM_API_URL}/sendMessage`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      chat_id: chatId,
      text: text
    })
  });

  if (!response.ok) {
    throw new Error(`Telegram API error: ${response.status}`);
  }

  return response.json();
}