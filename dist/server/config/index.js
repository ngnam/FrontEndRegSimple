'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _environments = require('../constants/environments');

if (process.env.NODE_ENV !== _environments.PRODUCTION) {
  const loadEnv = require('./loadEnv');
  loadEnv();
}

const envVarNames = ['SMTP_HOST', 'SMTP_PORT', 'SMTP_USER', 'SMTP_PASS', 'POSTGRES_CONNECTION_STRING', 'PORT', 'SESSION_SECRET', 'CLIENT_APP_BASE_URL'];

exports.default = envVarNames.reduce((config, varName) => {
  const envVar = process.env[varName];

  if (!envVar) {
    throw new Error(`Cannot find environment variable ${varName}`);
  }

  config[varName] = process.env[varName];

  return config;
}, {});