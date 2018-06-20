import boom from 'boom';

export default ({ config, searchApiService }) => async (req, res, next) => {
  const { countries, categories } = req.query;

  try {
    const results = await searchApiService.fetchResults({
      countries,
      categories
    });

    res.json({ data: results.data });
  } catch (err) {
    return next(
      boom.forbidden('searchApiService.fetchResults failed', err.details)
    );
  }
};
