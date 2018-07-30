import boom from 'boom';

export default ({ config, searchApiService }) => async (req, res, next) => {
  const { countries, categories, filterText } = req.query;

  try {
    const responses = await Promise.all(
      searchApiService.multiCategoryCountrySearch({
        categories,
        countries,
        filterText
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
