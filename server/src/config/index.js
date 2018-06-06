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
  'CLIENT_APP_BASE_URL'
];

export default envVarNames.reduce((config, varName) => {
  const envVar = process.env[varName];

  if (!envVar) {
    throw new Error(`Cannot find environment variable ${varName}`);
  }

  config[varName] = process.env[varName];

  return config;
}, {});
