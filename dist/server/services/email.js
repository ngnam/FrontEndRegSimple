'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _nodemailer = require('nodemailer');

var _nodemailer2 = _interopRequireDefault(_nodemailer);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var createEmailservice = function createEmailservice(_ref) {
  var config = _ref.config;
  return new Promise(function (resolve, reject) {
    var SMTP_HOST = config.SMTP_HOST,
        SMTP_PORT = config.SMTP_PORT,
        SMTP_USER = config.SMTP_USER,
        SMTP_PASS = config.SMTP_PASS;


    var allGood = function allGood(arr) {
      return arr.reduce(function (prev, curr) {
        return !!prev && !!curr;
      });
    };
    if (!allGood([SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS])) {
      throw new Error("Can't start server, SMTP details not found.");
    }
    // create reusable transporter object using the default SMTP transport
    var transporter = _nodemailer2.default.createTransport({
      host: SMTP_HOST,
      port: SMTP_PORT,
      secure: SMTP_PORT === 465, // use TLS when port is 465
      auth: {
        user: SMTP_USER,
        pass: SMTP_PASS
      },
      tls: {
        // do not fail on invalid certs
        rejectUnauthorized: false
      }
    });

    // setup email data with unicode symbols
    var options = function options(data) {
      return {
        from: 'RegSimple <' + SMTP_USER + '>', // sender address
        to: data.recipient, // list of receivers
        subject: data.subject, // Subject line
        text: data.plainText, // plain text body
        html: data.html // html body
      };
    };

    var send = function send(data, cb) {
      var mailOptions = options(data);
      console.log(data);
      transporter.sendMail(mailOptions, function (err, info) {
        if (err) {
          console.log(err);
        } else {
          console.log('Message %s sent: %s', info.messageId, info.response);
        }

        if (cb) {
          return cb(err, info);
        }
      });
    };

    transporter.verify(function (err, success) {
      if (err) {
        reject(err);
      } else {
        console.log('Server is ready to send messages on behalf of ' + SMTP_USER);
        resolve({ send: send });
      }
    });
  });
};

exports.default = createEmailservice;