import passwordless from 'passwordless';
import PostgreStore from 'passwordless-postgrestore';

import sendEmail from './nodemailer';

const { POSTGRES_CONNECTION_STRING, CLIENT_APP_BASE_URL } = process.env;

const sendToken = (tokenToSend, uidToSend, recipient, cb, req) => {
  const emailContent =
    'Hello!\nAccess your account here: ' +
    CLIENT_APP_BASE_URL +
    '?token=' +
    tokenToSend +
    '&uid=' +
    encodeURIComponent(uidToSend);

  sendEmail({
    recipient,
    subject: "Here's your token, friend",
    plainText: emailContent,
    html: emailContent
  }, cb);
};

passwordless.init(new PostgreStore(POSTGRES_CONNECTION_STRING), {
  skipForceSessionSave: true
});

passwordless.addDelivery(sendToken);

export default passwordless;
