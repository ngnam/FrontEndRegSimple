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

  const fetchCountries = async () => {
    return axios({
      method: 'GET',
      url: `${REGSIMPLE_SEARCH_API}/countries`,
      headers: { 'Content-Type': 'application/json' }
    });
  };

  const fetchTaxonomy = async () => {
    return axios({
      method: 'GET',
      url: `${REGSIMPLE_SEARCH_API}/taxonomy`,
      headers: { 'Content-Type': 'application/json' }
    });
  };

  return {
    fetchResults,
    fetchCountries,
    fetchTaxonomy
  };
};

export default createSearchApiService;
