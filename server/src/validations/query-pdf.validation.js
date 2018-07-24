import joi from 'joi';

const querySchema = {
  query: joi.object().keys({
    // countries is an array (currently max 1) of country ids
    countries: joi
      .array()
      .items(joi.string().uppercase())
      .min(1)
      .max(2)
      .required(),
    categories: joi
      .array()
      .items(joi.string())
      .min(1)
      .max(1)
      .required(),
    activity: joi
      .array()
      .items(joi.string())
      .min(1)
      .max(2)
      .required(),
    filterText: joi.string().allow('')
  })
};

export default querySchema;
