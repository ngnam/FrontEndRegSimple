import uuid from 'uuid/v4';

const createUserService = () => dbClient => {
  const getUserById = async id => {
    const query = {
      text: 'SELECT * from users WHERE id=$1',
      values: [id]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  const getUserByEmail = async email => {
    const query = {
      text: 'SELECT id from users WHERE email=$1',
      values: [email]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  const createUser = async email => {
    const userId = uuid();
    const query = {
      text: 'INSERT INTO users (id, email) VALUES($1, $2) RETURNING id',
      values: [userId, email]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  return {
    getUserByEmail,
    createUser,
    getUserById
  };
};

export default createUserService;
