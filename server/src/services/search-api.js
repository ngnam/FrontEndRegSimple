import axios from 'axios';

export const multiCategoryCountrySearch = fetchResultsFn => ({
  categories,
  countries,
  filterText
}) => {
  const request = category => country => {
    return {
      country: country,
      category: category,
      result: fetchResultsFn({
        countries: [country],
        categories: [category],
        filterText
      })
    };
  };

  return categories
    .map(category => countries.map(request(category)))
    .reduce((accum, curr) => accum.concat(curr), [])
    .map(async query => {
      const result = await query.result;

      return {
        ...query,
        result: result.data
      };
    });
};

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

  const feedbackSnippet = async ({
    snippetId,
    user,
    categories,
    countries,
    suggestedCategories
  }) => {
    const userId = user.isDeveloper ? null : user.id;

    return axios({
      method: 'PUT',
      url: `${REGSIMPLE_SEARCH_API}/feedback/${snippetId}`,
      data: { user_id: userId, categories, countries, suggestedCategories },
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
    feedbackSnippet,
    multiCategoryCountrySearch: multiCategoryCountrySearch(fetchResults)
  };
};

export default createSearchApiService;
