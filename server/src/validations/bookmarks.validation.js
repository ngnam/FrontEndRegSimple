import joi from 'joi';

const bookmarksSchema = {
  body: joi.object().keys({
    snippetId: joi.string().required(),
    categoryId: joi.string().required()
  })
};

export default bookmarksSchema;
