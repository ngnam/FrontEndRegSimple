import boom from 'boom';

export default ({ config, searchApiService }) => async (req, res, next) => {
  const { snippetId, action } = req.params;
  const userId = req.user && req.user.id;
  const { categories, countries } = req.query;

  if (!userId) {
    return next(
      boom.forbidden(
        'searchApiService.rejectSnippet failed, user not authorised'
      )
    );
  }

  try {
    const apiResponse = await searchApiService.rejectSnippet({
      snippetId,
      userId,
      categories,
      countries
    });

    res.json({ data: apiResponse.data });
  } catch (err) {
    console.error('searchApiService.rejectSnippet failed', { err });
    return next(boom.forbidden('searchApiService.rejectSnippet failed'));
  }
};
