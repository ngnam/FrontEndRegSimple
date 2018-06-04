import { Router } from 'express';

import loginEmail from './login-email';

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

  return router;
};

export default createRouter;
