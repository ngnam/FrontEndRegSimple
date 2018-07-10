import { Client } from 'pg';

const createPostgresService = async ({ config }) => {
  const { POSTGRES_CONNECTION_STRING } = config;

  const client = new Client({
    connectionString: POSTGRES_CONNECTION_STRING
  });

  try {
    await client.connect();
    console.log('postgres server connected');
    return client;
  } catch (err) {
    throw new Error('error connecting to postgres, ' + err);
  }
};

export default createPostgresService;
