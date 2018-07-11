import { Router } from 'express';

import validate from '../middleware/validation.middleware';
import auth from '../middleware/auth.middleware';

import querySchema from '../validations/query.validation';
import loginSchema from '../validations/login.validation';
import loginCodeSchema from '../validations/login-code.validation';

import loginEmail from './login-email.route';
import loginCode from './login-code.route';
import query from './query.route';
import appData from './app-data.route';

const createRouter = dependencies => {
  const router = Router();

  router.use(auth(dependencies));

  router.post('/login/email', validate(loginSchema), loginEmail(dependencies));
  router.post(
    '/login/code',
    validate(loginCodeSchema),
    loginCode(dependencies)
  );

  router.get('/query', validate(querySchema), query(dependencies));

  router.get('/app-data', appData(dependencies));

  return router;
};

export default createRouter;
