import uuid from 'uuid/v4';

import { ROLE_UNAUTHENTICATED, ROLE_USER } from '../constants/roles';

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

    const role = email ? ROLE_USER : ROLE_UNAUTHENTICATED;

    const query = {
      text:
        'INSERT INTO users (id, email, role) VALUES($1, lower($2), $3) RETURNING *',
      values: [userId, email, role]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  const verifyUser = async ({ userId, email }) => {
    const role = ROLE_USER;

    const query = {
      text: 'UPDATE users SET email=$2, role=$3 WHERE id=$1 RETURNING *',
      values: [userId, email, role]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  const editUser = async ({ userId, userType }) => {
    const query = {
      text:
        'INSERT INTO user_types (user_id, user_type) VALUES($1, $2) ON CONFLICT (user_id) DO UPDATE SET user_type=$2 RETURNING *',
      values: [userId, userType]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  return {
    getUserByEmail,
    createUser,
    getUserById,
    editUser,
    verifyUser
  };
};

export default createUserService;
