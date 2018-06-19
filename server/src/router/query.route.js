import results from '../fixtures/query-results';

export default () => (req, res) => {
  res.json({ data: results });
};
