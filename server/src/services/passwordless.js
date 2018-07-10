import boom from 'boom';

const createPasswordlessService = ({ emailService }) => dbClient => {
  const generateOneTimeCode = () => {
    const createInt = () => Math.floor(Math.random() * Math.floor(9));
    return (
      createInt().toString() +
      createInt().toString() +
      createInt().toString() +
      createInt().toString()
    );
  };

  const createOneTimeCode = userId => {
    const code = generateOneTimeCode();

    const query = {
      text:
        'INSERT INTO passwordless (user_id, code) VALUES($1, $2) ON CONFLICT (user_id) DO UPDATE SET code=$2',
      values: [userId, code]
    };

    return dbClient.query(query).then(() => code);
  };

  const sendCode = (code, recipient, cb) => {
    const emailContent = 'Hello!\nHere is your One Time Code: ' + code;

    emailService.send(
      {
        recipient,
        subject: `Here's your token, ${code}`,
        plainText: emailContent,
        html: emailContent
      },
      cb
    );
  };

  return {
    sendCode,
    createOneTimeCode
  };
};

export default createPasswordlessService;
