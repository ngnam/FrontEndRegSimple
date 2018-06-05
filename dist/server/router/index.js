'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _express = require('express');

var _loginEmail = require('./login-email');

var _loginEmail2 = _interopRequireDefault(_loginEmail);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const createRouter = dependencies => {
  const router = (0, _express.Router)();

  router.post('/login/email',
  // dependencies.passwordlessService.requestToken(
  //   (user, delivery, callback, req) => {
  //     callback(null, user);
  //   }
  // ),
  (0, _loginEmail2.default)());

  return router;
};

exports.default = createRouter;