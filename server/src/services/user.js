import uuid from 'uuid/v4';

const createUserService = () => dbClient => {
  const getUserByEmail = email => {
    const query = {
      text: 'SELECT id from users WHERE email=$1',
      values: [email]
    };
    return dbClient.query(query);
  };

  const createUser = email => {
    const userId = uuid();
    const query = {
      text: 'INSERT INTO users (id, email) VALUES($1, $2) RETURNING id',
      values: [userId, email]
    };
    return dbClient.query(query);
  };

  return {
    getUserByEmail,
    createUser
  };
};

export default createUserService;
