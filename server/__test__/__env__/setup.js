import config from '../../src/config';
import createApp from '../../src/app';

import queryResultsFixture from './fixtures/query-results.js';
import taxonomyFixture from './fixtures/taxonomy.js';
import countriesFixture from './fixtures/countries.js';
import userFixture from './fixtures/user.js';

module.exports = async () => {
  const emailService = { send: () => null };
  const dbClient = {};
  const searchApiService = {
    fetchResults: ({ countries }) =>
      Promise.resolve({ data: queryResultsFixture }),
    fetchCountries: () => Promise.resolve({ data: countriesFixture }),
    fetchTaxonomy: () => Promise.resolve({ data: taxonomyFixture })
  };
  const userService = {
    getUserByEmail: email =>
      email // simulate user not existing by not passing argument
        ? Promise.resolve({ rows: [{ id: userFixture.userId }] })
        : Promise.resolve({ rows: [] }),
    createUser: () => Promise.resolve({ rows: [{ id: '67890' }] })
  };
  const passwordlessService = {
    sendCode: (_email, _code, cb) => cb(),
    createOneTimeCode: () => '0000'
  };
  const app = await createApp({
    config,
    emailService,
    searchApiService,
    dbClient,
    passwordlessService,
    userService
  });

  process.app = app;
};
