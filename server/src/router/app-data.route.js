import boom from 'boom';

export default ({ searchApiService, userService, jwtService }) => async (
  req,
  res,
  next
) => {
  const { fetchTaxonomy, fetchCountries } = searchApiService;

  try {
    const appDataRes = await Promise.all([fetchTaxonomy(), fetchCountries()]);

    const [{ data: taxonomy }, { data: countries }] = appDataRes;

    res.json({
      data: { taxonomy, countries }
    });
  } catch (err) {
    console.error(err);
    return next(
      boom.forbidden(
        'searchApiService failure in either fetchTaxonomy or fetchCountries'
      )
    );
  }
};
