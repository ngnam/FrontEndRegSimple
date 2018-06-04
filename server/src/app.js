import path from 'path';
import express from 'express';
import morgan from 'morgan';
import cookieSession from 'cookie-session';
import bodyParser from 'body-parser';

import createEmailService from './services/email';
import createPasswordlessService from './services/passwordless';

import cors from './middleware/cors';

import createRouter from './router';

const createApp = async function({ config, emailService }) {
  emailService = emailService || (await createEmailService({ config }));
  const passwordlessService = null; //createPasswordlessService({ config, emailService });

  const app = express();

  const { SESSION_SECRET } = config;
  const publicDir = path.join(__dirname, '..', '..', 'client', 'public');

  app.use(morgan('tiny'));
  app.use(express.static(publicDir));
  app.use(bodyParser.json());
  app.use(
    cookieSession({
      name: 'session',
      secret: SESSION_SECRET,

      // Cookie Options
      maxAge: 24 * 60 * 60 * 1000 // 24 hours
    })
  );
  app.use(cors());
  // app.use(passwordlessService.sessionSupport());
  // app.use(passwordlessService.acceptToken());
  app.use(createRouter({ passwordlessService }));

  return app;
};

export default createApp;
