import joi from 'joi';

import querySchema from './query.validation';

const feedbackSnippetVoteSchema = {
  params: joi.object().keys({
    snippetId: joi.string().required(),
    voteDirection: joi
      .string()
      .valid(['up', 'down'])
      .required()
  }),
  body: joi.object().keys({
    categoryId: joi.string().required()
  })
};

export default feedbackSnippetVoteSchema;
