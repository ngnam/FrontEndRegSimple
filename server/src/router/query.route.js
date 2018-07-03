import boom from 'boom';

export default ({ config, searchApiService }) => async (req, res, next) => {
  const { countries, categories, filterText } = req.query;

  try {
    const requests = countries.map(country =>
      searchApiService.fetchResults({
        countries: [country],
        categories,
        filterText
      })
    );

    const resultsRes = await Promise.all(requests);

    const results = resultsRes.map(result => result.data);

    res.json({ data: { results } });
  } catch (err) {
    return next(
      boom.forbidden('searchApiService.fetchResults failed', err.details)
    );
  }
};
