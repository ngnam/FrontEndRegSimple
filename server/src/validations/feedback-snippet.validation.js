import joi from 'joi';

import { FEEDBACK_REJECT } from '../constants/feedbackTypes';

import querySchema from './query.validation';

const feedbackSnippetSchema = {
  query: querySchema.query,
  params: joi.object().keys({
    snippetId: joi.string().required(),
    action: joi.string().only([FEEDBACK_REJECT])
  })
};

export default feedbackSnippetSchema;
