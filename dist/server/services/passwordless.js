'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _passwordless = require('passwordless');

var _passwordless2 = _interopRequireDefault(_passwordless);

var _passwordlessPostgrestore = require('passwordless-postgrestore');

var _passwordlessPostgrestore2 = _interopRequireDefault(_passwordlessPostgrestore);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const createPasswordlessMiddleware = ({ emailService, config }) => {
  const { POSTGRES_CONNECTION_STRING, CLIENT_APP_BASE_URL } = config;

  const sendToken = (tokenToSend, uidToSend, recipient, cb, req) => {
    const emailContent = 'Hello!\nAccess your account here: ' + CLIENT_APP_BASE_URL + '?token=' + tokenToSend + '&uid=' + encodeURIComponent(uidToSend);

    emailService.send({
      recipient,
      subject: "Here's your token, friend",
      plainText: emailContent,
      html: emailContent
    }, cb);
  };

  _passwordless2.default.init(new _passwordlessPostgrestore2.default(POSTGRES_CONNECTION_STRING), {
    skipForceSessionSave: true
  });

  _passwordless2.default.addDelivery(sendToken);

  return _passwordless2.default;
};

exports.default = createPasswordlessMiddleware;