import joi from 'joi';

const querySchema = {
  body: joi.object().keys({
    code: joi
      .string()
      .length(4)
      .required(),
    userId: joi
      .string()
      .uuid()
      .required()
  })
};

export default querySchema;
