import passwordless from 'passwordless';
import PostgreStore from 'passwordless-postgrestore';

const createPasswordlessMiddleware = ({ emailService, config }) => {
  const { POSTGRES_CONNECTION_STRING, CLIENT_APP_BASE_URL } = config;

  const sendToken = (tokenToSend, uidToSend, recipient, cb, req) => {
    const emailContent =
      'Hello!\nAccess your account here: ' +
      CLIENT_APP_BASE_URL +
      '?token=' +
      tokenToSend +
      '&uid=' +
      encodeURIComponent(uidToSend);

    emailService.send(
      {
        recipient,
        subject: "Here's your token, friend",
        plainText: emailContent,
        html: emailContent
      },
      cb
    );
  };

  passwordless.init(new PostgreStore(POSTGRES_CONNECTION_STRING), {
    skipForceSessionSave: true
  });

  passwordless.addDelivery(sendToken);

  return passwordless;
};

export default createPasswordlessMiddleware;
