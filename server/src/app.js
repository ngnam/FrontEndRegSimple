import path from 'path';
import express from 'express';
import morgan from 'morgan';
import cookieSession from 'cookie-session';
import bodyParser from 'body-parser';

import createEmailService from './services/email';
import createSearchApiService from './services/search-api';
import createPostgresService from './services/postgresConnect';
import createPasswordlessService from './services/passwordless';
import createUserService from './services/user';
import { PRODUCTION } from './constants/environments';

import cors from './middleware/cors.middleware';
import errorHandler from './middleware/error-handling.middleware';

import createRouter from './router';

const createApp = async function({
  config,
  emailService,
  userService,
  searchApiService,
  passwordlessService,
  dbClient
}) {
  try {
    emailService = emailService || (await createEmailService({ config }));
    searchApiService =
      searchApiService || (await createSearchApiService({ config }));
    dbClient = dbClient || (await createPostgresService({ config }));
    userService = userService || (await createUserService()(dbClient));
    passwordlessService =
      passwordlessService ||
      (await createPasswordlessService({ config, emailService })(dbClient));

    const app = express();

    const { SESSION_SECRET } = config;
    const publicDir =
      process.env.NODE_ENV === PRODUCTION
        ? path.join(__dirname, '..', 'client')
        : path.join(__dirname, '..', '..', 'client', 'public');

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
    app.use(
      '/api',
      createRouter({
        config,
        passwordlessService,
        searchApiService,
        userService
      })
    );
    app.use(errorHandler());

    return app;
  } catch (err) {
    throw err;
  }
};

export default createApp;
