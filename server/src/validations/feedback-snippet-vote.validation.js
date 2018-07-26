import joi from 'joi';

import querySchema from './query.validation';

const feedbackSnippetVoteSchema = {
  params: joi.object().keys({
    snippetId: joi.string().required()
  }),
  body: joi.object().keys({
    categoryId: joi.string().required()
  })
};

export default feedbackSnippetVoteSchema;
