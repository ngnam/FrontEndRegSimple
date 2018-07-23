import joi from 'joi';

import { FEEDBACK_SUGGEST } from '../constants/feedbackTypes';

import querySchema from './query.validation';

const feedbackSnippetSchema = {
  query: querySchema.query,
  params: joi.object().keys({
    snippetId: joi.string().required(),
    action: joi.string().only([FEEDBACK_SUGGEST])
  }),
  body: joi.object().keys({
    suggestedCategories: joi.array().items(joi.string())
  })
};

export default feedbackSnippetSchema;
