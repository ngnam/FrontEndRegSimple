#!/usr/bin/env node
require('env2')('./.dev.env');

const argv = require('yargs').argv;
const { Client } = require('pg');

const roles = require('../shared/roles');
const editors = require('../shared/editors');

(async () => {
  const ROLE_EDITOR = roles.ROLE_EDITOR.name;

  const { email, role, pgConnectionString } = argv;
  const { POSTGRES_CONNECTION_STRING } = process.env;

  const emails = email ? [email] : editors;

  if ((email && !role) || (!email && role)) {
    return console.error(
      'ERROR ... you must either include both `email` and `role`, or neither'
    );
  }
  if ((email || role) && !roles.hasOwnProperty(role)) {
    return console.error(
      `ERROR ... cannot set role as ${role}, role must be one of ${Object.keys(
        roles
      )}`
    );
  }

  const client = new Client({
    connectionString: pgConnectionString || POSTGRES_CONNECTION_STRING
  });

  const updateRole = role => email =>
    client.query(`
    UPDATE users
    SET role = '${role}'
    WHERE email = '${email}'
    RETURNING *
    `);

  try {
    await client.connect();
    console.log('Good start ... postgres connected');
  } catch (err) {
    return console.error('ERROR ... connecting to postgres:\n, ' + err);
  }

  try {
    const queries = emails.map(updateRole(role || ROLE_EDITOR));

    queriesRes = await Promise.all(queries);

    const totalRowsUpdated = queriesRes.reduce(
      (accum, queryRes) => accum + queryRes.rowCount,
      0
    );

    const notFoundEmails = emails.filter(
      (email, index) => queriesRes[index].rowCount === 0
    );

    if (notFoundEmails.length > 0) {
      console.log(
        `EEK ... some email addresses weren't found in the database, check the following email(s) and make sure they've logged in already:\n ${notFoundEmails}`
      );
    }
    console.log(
      `FINISHED ... ${emails.length -
        notFoundEmails.length} user(s) updated successfully`
    );
  } catch (err) {
    return console.error('ERROR ... running postgres script:\n, ' + err);
  }

  console.log('END');

  process.exit();
})();
