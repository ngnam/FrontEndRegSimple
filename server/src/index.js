import env from 'env2';
env('./.env');

import app from './app';

const { PORT } = process.env;

app.listen(PORT, () => {
  console.log(`Listening at http://localhost:${PORT}`);
});
