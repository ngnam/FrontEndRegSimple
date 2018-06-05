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

function _asyncToGenerator(fn) { return function () { var gen = fn.apply(this, arguments); return new Promise(function (resolve, reject) { function step(key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { return Promise.resolve(value).then(function (value) { step("next", value); }, function (err) { step("throw", err); }); } } return step("next"); }); }; }

var createApp = function () {
  var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(_ref) {
    var config = _ref.config;
    var emailService, passwordlessService, app, SESSION_SECRET, publicDir;
    return regeneratorRuntime.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            _context.next = 2;
            return (0, _email2.default)({ config: config });

          case 2:
            emailService = _context.sent;
            passwordlessService = null; //createPasswordlessService({ config, emailService });

            app = (0, _express2.default)();
            SESSION_SECRET = config.SESSION_SECRET;
            publicDir = _path2.default.join(__dirname, '..', '..', 'client', 'public');


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
            app.use((0, _router2.default)({ passwordlessService: passwordlessService }));

            return _context.abrupt('return', app);

          case 14:
          case 'end':
            return _context.stop();
        }
      }
    }, _callee, this);
  }));

  return function createApp(_x) {
    return _ref2.apply(this, arguments);
  };
}();

exports.default = createApp;