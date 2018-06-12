export default () => (req, res) => {
  const { countries, categories } = req.query;

  res.json({ data: 'RESULTS' });
};
