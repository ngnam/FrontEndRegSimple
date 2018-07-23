import boom from 'boom';

export default ({ config, searchApiService }) => async (req, res, next) => {
  const { countries, categories, filterText } = req.query;

  try {
    const categoryRequest = category =>
      countries.map(country => {
        return {
          country: country,
          category: category,
          result: searchApiService.fetchResults({
            countries: [country],
            categories: [category],
            filterText
          })
        };
      });

    const queries = categories
      .map(categoryRequest)
      .reduce((accum, curr) => accum.concat(curr), []);

    const responses = await Promise.all(
      queries.map(async query => {
        const result = await query.result;

        return {
          ...query,
          result: result.data
        };
      })
    );

    res.json({ data: responses });
  } catch (err) {
    console.log(err);
    return next(
      boom.forbidden('searchApiService.fetchResults failed', err.details)
    );
  }
};
