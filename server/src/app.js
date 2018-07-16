import path from 'path';
import express from 'express';
import morgan from 'morgan';
import bodyParser from 'body-parser';
import cookieParser from 'cookie-parser';

import createEmailService from './services/email';
import createSearchApiService from './services/search-api';
import createPostgresService from './services/postgresConnect';
import createPasswordlessService from './services/passwordless';
import createUserService from './services/user';
import createJwtService from './services/jwt';
import createAnalyticsService from './services/analytics';
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
  dbClient,
  jwtService,
  analyticsService
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

    jwtService = jwtService || createJwtService({ config });
    analyticsService =
      analyticsService || createAnalyticsService({ config })(dbClient);

    const app = express();

    const { SESSION_SECRET } = config;
    const publicDir =
      process.env.NODE_ENV === PRODUCTION
        ? path.join(__dirname, '..', 'client')
        : path.join(__dirname, '..', '..', 'client', 'public');

    app.use(morgan('tiny'));
    app.use(express.static(publicDir));
    app.use(cookieParser());
    app.use(bodyParser.json());
    app.use(cors());
    app.use(
      '/api',
      createRouter({
        config,
        passwordlessService,
        searchApiService,
        userService,
        jwtService,
        analyticsService
      })
    );
    app.use(errorHandler());

    return app;
  } catch (err) {
    throw err;
  }
};

export default createApp;
