import createApp from './app';
import config from './config';

const PORT = process.env.PORT || 4000;

async function startApp() {
  const app = await createApp({ config });

  app.listen(PORT, () => {
    console.log(`Listening at http://localhost:${PORT}`);
  });
}

startApp();
