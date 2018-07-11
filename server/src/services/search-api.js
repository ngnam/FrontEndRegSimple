import axios from 'axios';

const createSearchApiService = ({ config }) => {
  const {
    REGSIMPLE_SEARCH_API,
    SEARCH_API_USERNAME,
    SEARCH_API_PASSWORD
  } = config;

  const fetchResults = async ({ countries, categories, filterText }) => {
    return axios({
      method: 'GET',
      url: `${REGSIMPLE_SEARCH_API}/search`,
      data: { categories, countries, text: filterText },
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

  const rejectSnippet = async ({
    snippetId,
    userId,
    categories,
    countries
  }) => {
    return axios({
      method: 'PUT',
      url: `${REGSIMPLE_SEARCH_API}/reject/${snippetId}`,
      data: { user_id: userId, categories, countries },
      headers: { 'Content-Type': 'application/json' },
      auth: {
        username: SEARCH_API_USERNAME,
        password: SEARCH_API_PASSWORD
      }
    });
  };

  return {
    fetchResults,
    fetchCountries,
    fetchTaxonomy,
    rejectSnippet
  };
};

export default createSearchApiService;
