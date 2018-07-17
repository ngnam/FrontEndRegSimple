import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const app = Main.fullscreen({
  config: {
    apiBaseUrl: process.env.ELM_APP_API_BASE_URL,
    clientBaseUrl: process.env.ELM_APP_CLIENT_APP_BASE_URL
  },
  session: localStorage.session
});

app.ports.copy.subscribe(copyLink => {
  const body = document.getElementsByTagName('body')[0];
  const input = document.createElement('input');

  input.setAttribute('id', 'copyInput');
  input.setAttribute('class', 'clip');
  input.setAttribute('value', copyLink);
  body.appendChild(input);

  input.select();
  document.execCommand('copy');
});

app.ports.storeSession.subscribe(function(session) {
  localStorage.session = session;
});

window.addEventListener(
  'storage',
  function(event) {
    if (event.storageArea === localStorage && event.key === 'session') {
      app.ports.onSessionChange.send(event.newValue);
    }
  },
  false
);

registerServiceWorker();
