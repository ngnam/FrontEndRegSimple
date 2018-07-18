import jwt from 'jsonwebtoken';

import userFixture from './user';
import {
  ROLE_USER,
  ROLE_EDITOR,
  ROLE_ADMIN
} from '../../../src/constants/roles';

const { JWT_SECRET } = process.env;

const token = role => jwt.sign({ ...userFixture, role }, JWT_SECRET);
const cookie = token => `token=${token}`;

export const user = () => cookie(token(ROLE_USER));
export const editor = () => cookie(token(ROLE_EDITOR));
export const admin = () => cookie(token(ROLE_ADMIN));
