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

  const getCodeDetailsByUserId = async userId => {
    const query = {
      text: 'SELECT * from passwordless WHERE user_id=$1 LIMIT 1',
      values: [userId]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  const createOneTimeCode = async userId => {
    const code = generateOneTimeCode();

    const query = {
      text:
        'INSERT INTO passwordless (user_id, code) VALUES($1, $2) ON CONFLICT (user_id) DO UPDATE SET code=$2 RETURNING *',
      values: [userId, code]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  const sendCode = async (code, recipient) => {
    const emailContent = 'Hello!\nHere is your One Time Code: ' + code;

    return await emailService.send({
      recipient,
      subject: `Here's your token, ${code}`,
      plainText: emailContent,
      html: emailContent
    });
  };

  return {
    sendCode,
    createOneTimeCode,
    getCodeDetailsByUserId
  };
};

export default createPasswordlessService;
