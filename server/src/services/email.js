import nodemailer from 'nodemailer';

import { PRODUCTION } from '../constants/environments';

const createEmailservice = ({ config }) =>
  new Promise((resolve, reject) => {
    const { SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS } = config;

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
      secure: parseInt(SMTP_PORT) === 465,
      auth: {
        user: SMTP_USER,
        pass: SMTP_PASS
      },
      tls: {
        // do not fail on invalid certs
        rejectUnauthorized: false
      }
      // service: 'SES-EU-WEST-1'
    });

    // setup email data with unicode symbols
    const options = data => {
      return {
        from: {
          name: 'RegSimple',
          address: 'info@regsimple.io'
        },
        to: data.recipient, // list of receivers
        subject: data.subject, // Subject line
        text: data.plainText, // plain text body
        html: data.html // html body
      };
    };

    const send = (data, cb) => {
      return new Promise((resolve, reject) => {
        const mailOptions = options(data);
        console.log(data);
        transporter.sendMail(mailOptions, (err, info) => {
          if (err) {
            console.error(err);

            reject(err);
          } else {
            console.log('Message %s sent: %s', info.messageId, info.response);

            resolve(info);
          }
        });
      });
    };

    transporter.verify((err, success) => {
      if (err) {
        if (process.env.NODE_ENV !== PRODUCTION) {
          console.error('WARNING: Email service unable to connect');
          return resolve({ send });
        }
        reject(err);
      } else {
        console.log(
          'Server is ready to send messages on behalf of ' + SMTP_USER
        );
        resolve({ send });
      }
    });
  });

export default createEmailservice;
