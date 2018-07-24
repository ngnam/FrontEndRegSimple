import config from '../../src/config';
import createApp from '../../src/app';
import { multiCategoryCountrySearch } from '../../src/services/search-api';

import queryResultsFixture from './fixtures/query-results.js';
import taxonomyFixture from './fixtures/taxonomy.js';
import countriesFixture from './fixtures/countries.js';
import userFixture from './fixtures/user.js';
import passwordlessFixture from './fixtures/passwordless.js';
import suggestSnippetFixture from './fixtures/suggest-snippet.js';

module.exports = async () => {
  const emailService = { send: () => null };
  const dbClient = {};
  const searchApiService = {
    fetchResults: ({ countries }) =>
      Promise.resolve({ data: queryResultsFixture }),
    multiCategoryCountrySearch: multiCategoryCountrySearch(
      async ({ countries, categories }) => ({ data: queryResultsFixture })
    ),
    fetchCountries: () => Promise.resolve({ data: countriesFixture }),
    fetchTaxonomy: () => Promise.resolve({ data: taxonomyFixture }),
    feedbackSnippet: () => Promise.resolve({ data: suggestSnippetFixture })
  };
  const userService = {
    getUserByEmail: email =>
      email // simulate user not existing by not passing argument
        ? Promise.resolve(userFixture)
        : Promise.resolve(undefined),
    createUser: () => Promise.resolve(userFixture),
    getUserById: _userId => Promise.resolve(userFixture)
  };
  const passwordlessService = {
    sendCode: (_email, _code) => Promise.resolve(),
    createOneTimeCode: () => passwordlessFixture,
    getCodeDetailsByUserId: async _userId => passwordlessFixture
  };
  const analyticsService = {
    logEvent: () => null
  };
  const app = await createApp({
    config,
    emailService,
    searchApiService,
    dbClient,
    passwordlessService,
    userService,
    analyticsService
  });

  process.app = app;
};
