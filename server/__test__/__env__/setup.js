import config from '../../src/config';
import createApp from '../../src/app';

module.exports = async () => {
  const app = await createApp({ config });

  process.app = app;
};
