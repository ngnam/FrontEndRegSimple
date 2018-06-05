'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _loadEnv = require('./loadEnv');

var _loadEnv2 = _interopRequireDefault(_loadEnv);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

(0, _loadEnv2.default)();

const envVarNames = ['SMTP_HOST', 'SMTP_PORT', 'SMTP_USER', 'SMTP_PASS', 'POSTGRES_CONNECTION_STRING', 'PORT', 'SESSION_SECRET', 'CLIENT_APP_BASE_URL'];

exports.default = envVarNames.reduce((config, varName) => {
  const envVar = process.env[varName];

  if (!envVar) {
    throw new Error(`Cannot find environment variable ${varName}`);
  }

  config[varName] = process.env[varName];

  return config;
}, {});