import { Router } from 'express';

import {
  ROLE_EDITOR,
  ROLE_USER,
  ROLE_UNAUTHENTICATED
} from '../constants/roles';

import validate from '../middleware/validation.middleware';
import authenticate from '../middleware/authenticate.middleware';
import authorise from '../middleware/authorise.middleware';

import querySchema from '../validations/query.validation';
import queryPdfValidationSchema from '../validations/query-pdf.validation';
import loginEmailSchema from '../validations/login-email.validation';
import loginCodeSchema from '../validations/login-code.validation';
import feedbackSnippetSuggestSchema from '../validations/feedback-snippet-suggest.validation';
import feedbackSnippetVoteSchema from '../validations/feedback-snippet-vote.validation';
import analyticsSchema from '../validations/analytics.validation';
import bookmarksSchema from '../validations/bookmarks.validation';
import userEditSchema from '../validations/user-edit.validation';

import loginEmail from './login-email.route';
import loginCode from './login-code.route';
import logout from './logout.route';
import query from './query.route';
import appData from './app-data.route';
import feedbackSnippetSuggest from './feedback-snippet-suggest.route';
import feedbackSnippetVoteUp from './feedback-snippet-vote-up.route';
import feedbackSnippetVoteDown from './feedback-snippet-vote-down.route';
import analytics from './analytics.route';
import queryPdf from './query-pdf.route';
import getBookmarks from './bookmark-get.route';
import addBookmark from './bookmark-post.route';
import removeBookmark from './bookmark-delete.route';
import userEdit from './user-edit.route';
import userSelf from './user-self.route';

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
  router.get(
    '/query/pdf',
    validate(queryPdfValidationSchema),
    queryPdf(dependencies)
  );

  router.put(
    '/feedback/snippet/:snippetId/suggest',
    authorise({ minRole: ROLE_EDITOR }),
    validate(feedbackSnippetSuggestSchema),
    feedbackSnippetSuggest(dependencies)
  );
  router.put(
    '/feedback/snippet/:snippetId/vote/up',
    authorise({ minRole: ROLE_USER }),
    validate(feedbackSnippetVoteSchema),
    feedbackSnippetVoteUp(dependencies)
  );
  router.put(
    '/feedback/snippet/:snippetId/vote/down',
    authorise({ minRole: ROLE_USER }),
    validate(feedbackSnippetVoteSchema),
    feedbackSnippetVoteDown(dependencies)
  );

  router.get('/app-data', appData(dependencies));
  router.post('/analytics', validate(analyticsSchema), analytics(dependencies));
  router.post(
    '/bookmark',
    authorise({ minRole: ROLE_USER }),
    validate(bookmarksSchema),
    addBookmark(dependencies)
  );
  router.delete(
    '/bookmark',
    authorise({ minRole: ROLE_USER }),
    validate(bookmarksSchema),
    removeBookmark(dependencies)
  );
  router.get(
    '/bookmark',
    authorise({ minRole: ROLE_USER }),
    getBookmarks(dependencies)
  );
  router.post(
    '/user',
    authorise({ minRole: ROLE_UNAUTHENTICATED }),
    validate(userEditSchema),
    userEdit(dependencies)
  );
  router.get('/user/self', userSelf(dependencies));

  return router;
};

export default createRouter;
