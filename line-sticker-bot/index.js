require('dotenv').config();

// ------------------------------------------------------------
// require express and line
// ------------------------------------------------------------
const express = require('express');
const line = require('@line/bot-sdk');

// ------------------------------------------------------------
// expressのインスタンスを作成
// ------------------------------------------------------------
const app = express();

// ------------------------------------------------------------
// LINE SDK設定
// ------------------------------------------------------------
const config = {
  channelAccessToken: process.env.LINE_CHANNEL_ACCESS_TOKEN,
  channelSecret: process.env.LINE_CHANNEL_SECRET,
};

// ------------------------------------------------------------
// LINE Bot のメイン処理
// ------------------------------------------------------------
async function handleLineEvents(events) {
  const client = new line.messagingApi.MessagingApiClient({
    channelAccessToken: config.channelAccessToken
  });

  return Promise.all(events.map(async (lineEvent) => {
    if (lineEvent.type !== 'message' || lineEvent.message.type !== 'sticker') {
      return null;
    }

    const { packageId, stickerId } = lineEvent.message;
    console.log(`受信したスタンプ: packageId=${packageId}, stickerId=${stickerId}`);

    return await client.replyMessage({
      replyToken: lineEvent.replyToken,
      messages: [
        {
          type: 'sticker',
          packageId: '6325',
          stickerId: '10979904'
        }
      ]
    });
  }));
}

// ------------------------------------------------------------
// Lambda function
// ------------------------------------------------------------
exports.handler = async (event) => {
  console.log('Lambda function triggered:', JSON.stringify(event, null, 2));
  
  try {
    const body = JSON.parse(event.body);
    await handleLineEvents(body.events);

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: 'OK' })
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: 'Internal Server Error' })
    };
  }
};

// ------------------------------------------------------------
// ローカル開発用サーバー
// ------------------------------------------------------------ 
if (process.env.NODE_ENV !== 'production') {
  const app = express();
  
  app.post('/webhook', line.middleware(config), async (req, res) => {
    try {
      await handleLineEvents(req.body.events);
      res.json({ message: 'OK' });
    } catch (err) {
      console.error('Error:', err);
      res.status(500).json({ message: 'Internal Server Error' });
    }
  });

  const port = process.env.PORT || 3000;
  app.listen(port, () => {
    console.log(`Local server running on port ${port}`);
  });
}
