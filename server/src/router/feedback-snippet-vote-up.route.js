import boom from 'boom';

export default ({ config, searchApiService }) => async (req, res, next) => {
  const { snippetId } = req.params;
  const { id: userId } = req.user || {};
  const { categoryId } = req.body;

  try {
    res.json({ data: 'METHOD NOT AVAILABLE YET' });
  } catch (err) {
    console.error('searchApiService.feedbackSnippet failed', { err });
    return next(boom.forbidden('searchApiService.feedbackSnippet failed'));
  }
};
