import joi from 'joi';

const querySchema = {
  body: joi.object().keys({
    eventName: joi.string().required(),
    params: joi.string().required()
  })
};

export default querySchema;
