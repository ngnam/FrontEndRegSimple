import joi from 'joi';

const querySchema = {
  body: joi.object().keys({
    email: joi
      .string()
      .trim()
      .lowercase()
      .email()
      .required()
  })
};

export default querySchema;
