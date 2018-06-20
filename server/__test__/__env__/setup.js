import config from '../../src/config';
import createApp from '../../src/app';

import queryResultsFixture from './fixtures/query-results.js';
import taxonomyFixture from './fixtures/taxonomy.js';
import countriesFixture from './fixtures/countries.js';

module.exports = async () => {
  const emailService = {};
  const searchApiService = {
    fetchResults: () => Promise.resolve({ data: queryResultsFixture }),
    fetchCountries: () => Promise.resolve({ data: countriesFixture }),
    fetchTaxonomy: () => Promise.resolve({ data: taxonomyFixture })
  };
  const app = await createApp({ config, emailService, searchApiService });

  process.app = app;
};
