import joi from 'joi';
import boom from 'boom';

const validate = schema => async (req, res, next) => {
  if (!schema) {
    return next();
  }

  const dataToValidate = Object.keys(schema).reduce((accum, key) => {
    accum[key] = req[key];
    return accum;
  }, {});

  try {
    const validatedData = await joi.validate(dataToValidate, schema);

    req = {
      ...req,
      ...validatedData
    };

    return next();
  } catch (err) {
    return next(boom.badRequest('Invalid query', err.details));
  }
};

export default validate;
