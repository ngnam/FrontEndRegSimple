import joi from 'joi';

const bookmarksSchema = {
  query: joi.object().keys({
    blocks: joi
      .array()
      .items(joi.string())
      .required()
  })
};

export default bookmarksSchema;
