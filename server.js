'use strict';

import 'dotenv/config';
import express from 'express';
import router from './lib/index.js';

const app = express();
const port = process.env.PORT || 8080;

// 确保 API_KEY 已设置
if (!process.env.API_KEY) {
  console.error('API_KEY environment variable is not set');
  process.exit(1);
}

const authMiddleware = (req, res, next) => {
  const apiKey = req.headers['x-api-key'];

  if (!apiKey || apiKey !== process.env.API_KEY) {
    return res.status(401).json({
      error: 'Unauthorized - Invalid API Key'
    });
  }

  next();
};

// 将中间件应用到所有 API 路由
app.use('/api/', authMiddleware, router);

app.get('/', function (req, res) {
  res.redirect('/api');
});

app.listen(port, function () {
  console.log('Server started on port', port);
});
