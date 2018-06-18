import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

Main.embed(document.getElementById('root'), {
  apiBaseUrl: process.env.ELM_APP_API_BASE_URL
});

registerServiceWorker();
