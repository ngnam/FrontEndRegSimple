import config from '../../src/config';
import createApp from '../../src/app';

import queryResultsFixture from './fixtures/query-results.js';
import taxonomyFixture from './fixtures/taxonomy.js';
import countriesFixture from './fixtures/countries.js';
import userFixture from './fixtures/user.js';
import passwordlessFixture from './fixtures/passwordless.js';
import rejectSnippetFixture from './fixtures/reject-snippet.js';

module.exports = async () => {
  const emailService = { send: () => null };
  const dbClient = {};
  const searchApiService = {
    fetchResults: ({ countries }) =>
      Promise.resolve({ data: queryResultsFixture }),
    fetchCountries: () => Promise.resolve({ data: countriesFixture }),
    fetchTaxonomy: () => Promise.resolve({ data: taxonomyFixture }),
    rejectSnippet: () => Promise.resolve({ data: rejectSnippetFixture })
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
  const jwtService = {
    encode: () => Promise.resolve('token'),
    decode: () => Promise.resolve(userFixture)
  };
  const app = await createApp({
    config,
    emailService,
    searchApiService,
    dbClient,
    passwordlessService,
    userService,
    jwtService
  });

  process.app = app;
};
