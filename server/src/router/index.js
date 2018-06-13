import { Router } from 'express';

import validate from '../middleware/validation.middleware';

import querySchema from '../validations/query.validation';

import loginEmail from './login-email.route';
import query from './query.route';
import componentData from './component-data.route';

const createRouter = dependencies => {
  const router = Router();

  router.post(
    '/login/email',
    // dependencies.passwordlessService.requestToken(
    //   (user, delivery, callback, req) => {
    //     callback(null, user);
    //   }
    // ),
    loginEmail()
  );

  router.get('/query', validate(querySchema), query());

  router.get('/component-data', componentData());

  return router;
};

export default createRouter;
