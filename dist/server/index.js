'use strict';

var _app = require('./app');

var _app2 = _interopRequireDefault(_app);

var _config = require('./config');

var _config2 = _interopRequireDefault(_config);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const PORT = process.env.PORT || 4000;

async function startApp() {
  const app = await (0, _app2.default)({ config: _config2.default });

  app.listen(PORT, () => {
    console.log(`Listening at http://localhost:${PORT}`);
  });
}

startApp();