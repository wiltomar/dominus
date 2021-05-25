/**
 * File: server.js
 * Description: Responsible file to every configuration and execution of application.
 * Date: 06/08/2020
 * Author: José Wiltomar DUARTE
 */
import express from 'express';
import cors from 'cors';
import './common/database/connect';
import { load } from 'ts-dotenv';
import fs from 'fs';
import https from 'https';
import path from 'path';

import routes from './routes';
import errorHandler from './common/middlewares/errors.middleware';
import notFoundHandler from './common/middlewares/notfound.middleware';

const app = express();
const env =load({
  BASE_URL: String,
  NODE_ENV: [
    'production' as const,
    'development' as const,
  ],
  API_VERSION: String,
  PORT: Number,
});

const serverName = env.BASE_URL || 'localhost';
const serverPort = env.PORT || 3000;

if (!serverPort) {
  process.exit(1);
}

var corsOptions = {
  origin: `${process.env.BASE_URL}:${process.env.PORT}`,
};

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.json({ type: 'application/vnd.api+json' }));

app.disable('x-powered-by');

app.use(cors(corsOptions));
app.use(routes);

app.use(errorHandler);
app.use(notFoundHandler);

const privateKey = fs.readFileSync(
  path.resolve(__dirname, './common/resources/certificates/server.key'),
  'utf8'
);
const certificate = fs.readFileSync(
  path.resolve(__dirname, './common/resources/certificates/server.crt'),
  'utf8'
);
const password = process.env.PASSWORD || 'password';

const credentials = {
  key: privateKey,
  cert: certificate,
  passphrase: password,
};

https.createServer(credentials, app).listen(serverPort, () => {
  console.log(`🚀 - Listening on ${serverName}:${serverPort}`);
});
