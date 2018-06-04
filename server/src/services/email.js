import nodemailer from 'nodemailer';

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
    const options = data => {
      return {
        from: `RegSimple <${SMTP_USER}>`, // sender address
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

        if (cb) {
          return cb(err, info);
        }
      });
    };

    transporter.verify((err, success) => {
      if (err) {
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
