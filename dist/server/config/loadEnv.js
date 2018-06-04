'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _environments = require('../constants/environments');

var env2 = require('env2');
var NODE_ENV = process.env.NODE_ENV;


var loadEnv = function loadEnv() {
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

exports.default = loadEnv;