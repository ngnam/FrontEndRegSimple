import axios from 'axios';
import boom from 'boom';
import fixtureResult from '../fixtures/query-results.js';

export default config => async (req, res, next) => {
  const { countries, categories } = req.query;
  const query = { countries, categories, text: '' };
  
  try {
    const results = await fetchResults(config)(query);

    res.json({ data: results.data });
  } catch (err) {
    return next(boom.badRequest('Invalid query', err.details));
  }
};

const fetchResults = config => async ({ countries, categories }) => axios({
    method: 'GET',
    url: `${config.REGSIMPLE_SEARCH_API}/search`,
    data: { categories, countries },
    headers: { 'Content-Type': 'application/json' }
  });
