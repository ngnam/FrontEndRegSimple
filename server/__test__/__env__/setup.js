import config from '../../src/config';
import createApp from '../../src/app';

import queryResultsFixture from './fixtures/query-results.js';

module.exports = async () => {
  const emailService = {};
  const searchApiService = {
    fetchResults: ({ countries, categories }) =>
      Promise.resolve(queryResultsFixture)
  };
  const app = await createApp({ config, emailService, searchApiService });

  process.app = app;
};
