import { Router } from 'express';

import validate from '../middleware/validation.middleware';
import auth from '../middleware/auth.middleware';

import querySchema from '../validations/query.validation';
import loginEmailSchema from '../validations/login-email.validation';
import loginCodeSchema from '../validations/login-code.validation';
import feedbackSnippetSchema from '../validations/feedback-snippet.validation';

import loginEmail from './login-email.route';
import loginCode from './login-code.route';
import logout from './logout.route';
import query from './query.route';
import appData from './app-data.route';
import feedbackSnippet from './feedback-snippet.route';

const createRouter = dependencies => {
  const router = Router();

  router.use(auth(dependencies));

  router.post(
    '/login/email',
    validate(loginEmailSchema),
    loginEmail(dependencies)
  );
  router.post(
    '/login/code',
    validate(loginCodeSchema),
    loginCode(dependencies)
  );
  router.post('/logout', logout());

  router.get('/query', validate(querySchema), query(dependencies));

  router.put(
    '/feedback/snippet/:snippetId/:action',
    validate(feedbackSnippetSchema),
    feedbackSnippet(dependencies)
  );

  router.get('/app-data', appData(dependencies));

  return router;
};

export default createRouter;
