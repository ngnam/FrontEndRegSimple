import uuid from 'uuid/v4';

import { ROLE_USER } from '../constants/roles';

const createUserService = () => dbClient => {
  const getUserById = async id => {
    const query = {
      text: 'SELECT * from users WHERE id=$1 LIMIT 1',
      values: [id]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  const getUserByEmail = async email => {
    const query = {
      text: 'SELECT * from users WHERE email=lower($1) LIMIT 1',
      values: [email]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  const createUser = async email => {
    const userId = uuid();
    const role = ROLE_USER;
    const query = {
      text:
        'INSERT INTO users (id, email, role) VALUES($1, lower($2), $3) RETURNING *',
      values: [userId, email, role]
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
