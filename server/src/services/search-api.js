import axios from 'axios';

const createSearchApiService = ({ config }) => {
  const { REGSIMPLE_SEARCH_API } = config;

  const fetchResults = async ({ countries, categories }) => {
    return axios({
      method: 'GET',
      url: `${REGSIMPLE_SEARCH_API}/search`,
      data: { categories, countries },
      headers: { 'Content-Type': 'application/json' }
    });
  };

  return {
    fetchResults
  };
};

export default createSearchApiService;
