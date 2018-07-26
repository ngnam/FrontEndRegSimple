import joi from 'joi';

import querySchema from './query.validation';

const feedbackSnippetSuggestSchema = {
  query: querySchema.query,
  params: joi.object().keys({
    snippetId: joi.string().required()
  }),
  body: joi.object().keys({
    suggestedCategories: joi.array().items(joi.string())
  })
};

export default feedbackSnippetSuggestSchema;
