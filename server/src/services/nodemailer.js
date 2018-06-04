import env from 'env2';
env('./.env');

import nodemailer from 'nodemailer';

const { SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS } = process.env;

const allGood = function allGood(arr) {
  return arr.reduce(function(prev, curr) {
    return !!prev && !!curr;
  });
};
if (!allGood([SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS])) {
  throw new Error("Can't start server, SMTP details not found.");
}
// create reusable transporter object using the default SMTP transport
const transporter = nodemailer.createTransport({
  host: SMTP_HOST,
  port: SMTP_PORT,
  secure: true, // use TLS
  auth: {
    user: SMTP_USER,
    pass: SMTP_PASS
  },
  tls: {
    // do not fail on invalid certs
    rejectUnauthorized: false
  }
});

transporter.verify(function(err, success) {
  if (err) {
    console.log(err);
  } else {
    console.log('Server is ready to send messages on behalf of ' + SMTP_USER);
  }
});

// setup email data with unicode symbols
const options = function options(data) {
  return {
    from: '"Fred Foo \uD83D\uDC7B" <' + SMTP_USER + '>', // sender address
    to: data.recipient, // list of receivers
    subject: data.subject, // Subject line
    text: data.plainText, // plain text body
    html: data.html // html body
  };
};

const send = (data, cb) => {
  const mailOptions = options(data);
  console.log(data);
  transporter.sendMail(mailOptions, (err, info) => {
    if (err) {
      console.log(err);
    } else {
      console.log('Message %s sent: %s', info.messageId, info.response);
    }

    return cb(err, info);
  });
};

export default send;
