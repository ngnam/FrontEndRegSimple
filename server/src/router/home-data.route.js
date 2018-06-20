export default ({ searchApiService }) => async (req, res) => {
  const { fetchTaxonomy, fetchCountries } = searchApiService;

  const homeDataRes = await Promise.all([fetchTaxonomy(), fetchCountries()]);

  const [{ data: taxonomy }, { data: countries }] = homeDataRes;

  res.json({
    data: { taxonomy, countries }
  });
};
