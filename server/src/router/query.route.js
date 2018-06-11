export default () => (req, res) => {
  const { countries, categories } = req.query;

  console.log({ countries, categories });

  res.json('RECEIVED');
};
