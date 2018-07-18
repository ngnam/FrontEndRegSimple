import { Router } from 'express';

import { ROLE_EDITOR } from '../constants/roles';

import validate from '../middleware/validation.middleware';
import authenticate from '../middleware/authenticate.middleware';
import authorise from '../middleware/authorise.middleware';

import querySchema from '../validations/query.validation';
import loginEmailSchema from '../validations/login-email.validation';
import loginCodeSchema from '../validations/login-code.validation';
import feedbackSnippetSchema from '../validations/feedback-snippet.validation';
import analyticsSchema from '../validations/analytics.validation';

import loginEmail from './login-email.route';
import loginCode from './login-code.route';
import logout from './logout.route';
import query from './query.route';
import appData from './app-data.route';
import feedbackSnippet from './feedback-snippet.route';
import analytics from './analytics.route';

const createRouter = dependencies => {
  const router = Router();

  router.use(authenticate(dependencies));

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
    authorise({ minRole: ROLE_EDITOR }),
    validate(feedbackSnippetSchema),
    feedbackSnippet(dependencies)
  );

  router.get('/app-data', appData(dependencies));
  router.post('/analytics', validate(analyticsSchema), analytics(dependencies));

  return router;
};

export default createRouter;
