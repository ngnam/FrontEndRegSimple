import boom from 'boom';

export default ({ config, searchApiService }) => async (req, res, next) => {
  const { snippetId } = req.params;
  const { categories, countries } = req.query;
  const { suggestedCategories } = req.body;
  const user = req.user;

  try {
    const apiResponse = await searchApiService.feedbackSnippet({
      snippetId,
      user,
      categories,
      countries,
      suggestedCategories
    });

    res.json({ data: apiResponse.data });
  } catch (err) {
    console.error('searchApiService.feedbackSnippet failed', { err });
    return next(boom.forbidden('searchApiService.feedbackSnippet failed'));
  }
};
