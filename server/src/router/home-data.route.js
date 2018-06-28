export default ({ searchApiService }) => async (req, res, next) => {
  const { fetchTaxonomy, fetchCountries } = searchApiService;

  try {
    const homeDataRes = await Promise.all([fetchTaxonomy(), fetchCountries()]);

    const [{ data: taxonomy }, { data: countries }] = homeDataRes;

    res.json({
      data: { taxonomy, countries }
    });
  } catch (err) {
    return next(
      boom.forbidden(
        'searchApiService failure in either fetchTaxonomy or fetchCountries',
        err.details
      )
    );
  }
};
