'use strict';

var _environments = require('../constants/environments');

const env2 = require('env2');
const { NODE_ENV } = process.env;

const loadEnv = () => {
  switch (NODE_ENV) {
    case _environments.TEST:
      env2('./.test.env');
      break;
    case _environments.DEVELOPMENT:
      env2('./.dev.env');
      break;
    default:
  }
};

module.exports = loadEnv;