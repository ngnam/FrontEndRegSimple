import boom from 'boom';

export default ({ config, searchApiService }) => async (req, res, next) => {
  const { snippetId } = req.params;
  const { userId } = req.user || {};
  const { categories, countries } = req.query;
  const { suggestedCategories } = req.body;

  try {
    const apiResponse = await searchApiService.feedbackSnippet({
      snippetId,
      userId,
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
