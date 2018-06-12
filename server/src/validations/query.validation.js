import joi from 'joi';

const querySchema = {
  query: joi.object().keys({
    // countries is an array (currently max 1) of country ids
    countries: joi
      .array()
      .items(joi.string())
      .max(1)
      .required(),
    categories: joi
      .array()
      .items(joi.string())
      .required()
  })
};

export default querySchema;
