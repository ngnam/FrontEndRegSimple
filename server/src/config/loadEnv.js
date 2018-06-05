const env2 = require('env2');
const { NODE_ENV } = process.env;

import { TEST, DEVELOPMENT } from '../constants/environments';

const loadEnv = () => {
  switch (NODE_ENV) {
    case TEST:
      env2('./.test.env');
      break;
    case DEVELOPMENT:
      env2('./.dev.env');
      break;
    default:
  }
};

export default loadEnv;
