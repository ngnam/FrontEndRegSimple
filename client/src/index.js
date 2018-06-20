import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const app = Main.embed(document.getElementById('root'), {
  apiBaseUrl: process.env.ELM_APP_API_BASE_URL,
  clientBaseUrl: process.env.ELM_APP_CLIENT_APP_BASE_URL
});

app.ports.copy.subscribe(copyLink => {
  const body = document.getElementsByTagName('body')[0];
  const input = document.createElement('input')

  input.setAttribute("id", "copyInput");
  input.setAttribute("class", "hidden");
  input.setAttribute("value", copyLink);
  body.appendChild(input)

  input.select();
  document.execCommand('copy');
});

registerServiceWorker();
