import boom from 'boom';

export default ({ config, searchApiService }) => async (req, res, next) => {
  const { snippetId, voteDirection } = req.params;
  const { categories, countries } = req.query;
  const { suggestedCategories } = req.body;
  const user = req.user;

  try {
    const apiResponse = await searchApiService.feedbackSnippet({
      snippetId,
      user,
      categories,
      countries,
      vote: voteDirection === 'up' ? true : false
    });
    res.json({ data: 'success' });
  } catch (err) {
    console.error('searchApiService.feedbackSnippet failed', { err });
    return next(boom.forbidden('searchApiService.feedbackSnippet failed'));
  }
};
