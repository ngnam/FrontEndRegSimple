import joi from 'joi';

const schema = {
  body: joi.object().keys({
    userType: joi
      .string()
      .lowercase()
      .required()
  })
};

export default schema;
