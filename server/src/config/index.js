import path from 'path';

import { PRODUCTION } from '../constants/environments';

if (process.env.NODE_ENV !== PRODUCTION) {
  const loadEnv = require('./loadEnv');
  loadEnv();
}

const envVarNames = [
  'SMTP_HOST',
  'SMTP_PORT',
  'SMTP_USER',
  'SMTP_PASS',
  'POSTGRES_CONNECTION_STRING',
  'PORT',
  'SESSION_SECRET',
  'REGSIMPLE_SEARCH_API',
  'CLIENT_APP_BASE_URL',
  'JWT_SECRET',
  'SEARCH_API_USERNAME',
  'SEARCH_API_PASSWORD'
];

export default envVarNames.reduce((config, varName) => {
  const envVar = process.env[varName];

  if (!envVar) {
    throw new Error(`Cannot find environment variable ${varName}`);
  }

  config[varName] = process.env[varName];

  config.PUBLIC_DIR_PATH =
    process.env.NODE_ENV === PRODUCTION
      ? path.join(__dirname, '..', 'client')
      : path.join(__dirname, '..', '..', 'client', 'public');

  return config;
}, {});
