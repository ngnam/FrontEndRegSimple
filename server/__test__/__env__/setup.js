import config from '../../src/config';
import createApp from '../../src/app';

module.exports = async () => {
  const emailService = {};
  const app = await createApp({ config, emailService });

  process.app = app;
};
