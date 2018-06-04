import express from 'express';
import morgan from 'morgan';
import cookieSession from 'cookie-session';
import bodyParser from 'body-parser';

import cors from './middleware/cors';

import passwordless from './services/passwordless';

import router from './router';

const app = express();

const { SESSION_SECRET } = process.env;

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
app.use(morgan('combined'));
app.use(passwordless.sessionSupport());
app.use(passwordless.acceptToken());

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.use(router({ passwordlessService: passwordless }));

export default app;
