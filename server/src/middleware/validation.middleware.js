import joi from 'joi';
import boom from 'boom';

const validate = (dataKey, schema) => async (req, res, next) => {
  const data = req[dataKey];

  try {
    const sanitisedData = await joi.validate(data, schema);

    req[dataKey] = sanitisedData;

    return next();
  } catch (err) {
    return next(boom.badRequest('Invalid query', err.details));
  }
};

export default validate;
