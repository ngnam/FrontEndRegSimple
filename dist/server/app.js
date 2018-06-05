'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

var _morgan = require('morgan');

var _morgan2 = _interopRequireDefault(_morgan);

var _cookieSession = require('cookie-session');

var _cookieSession2 = _interopRequireDefault(_cookieSession);

var _bodyParser = require('body-parser');

var _bodyParser2 = _interopRequireDefault(_bodyParser);

var _email = require('./services/email');

var _email2 = _interopRequireDefault(_email);

var _passwordless = require('./services/passwordless');

var _passwordless2 = _interopRequireDefault(_passwordless);

var _cors = require('./middleware/cors');

var _cors2 = _interopRequireDefault(_cors);

var _router = require('./router');

var _router2 = _interopRequireDefault(_router);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const createApp = async function ({ config, emailService }) {
  emailService = emailService || (await (0, _email2.default)({ config }));
  const passwordlessService = null; //createPasswordlessService({ config, emailService });

  const app = (0, _express2.default)();

  const { SESSION_SECRET } = config;
  const publicDir = _path2.default.join(__dirname, '..', '..', 'client', 'public');

  app.use((0, _morgan2.default)('tiny'));
  app.use(_express2.default.static(publicDir));
  app.use(_bodyParser2.default.json());
  app.use((0, _cookieSession2.default)({
    name: 'session',
    secret: SESSION_SECRET,

    // Cookie Options
    maxAge: 24 * 60 * 60 * 1000 // 24 hours
  }));
  app.use((0, _cors2.default)());
  // app.use(passwordlessService.sessionSupport());
  // app.use(passwordlessService.acceptToken());
  app.use((0, _router2.default)({ passwordlessService }));

  return app;
};

exports.default = createApp;