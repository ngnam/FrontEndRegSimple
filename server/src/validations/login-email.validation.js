import joi from 'joi';

const querySchema = {
  body: joi.object().keys({
    email: joi
      .string()
      .lowercase()
      .email()
      .required()
  })
};

export default querySchema;
