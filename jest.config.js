const { readFileSync } = require('fs')
const babelConfig = JSON.parse(readFileSync('./.babelrc', 'utf8'))

require('babel-register')(babelConfig)
require('babel-polyfill')

const { join } = require('path')

const ROOT = process.cwd()
const JEST_ENV = join(ROOT, 'server', '__test__', '__env__')

module.exports = {
  verbose: true,
  transform: {
    '^.+\\.jsx?$': 'babel-jest'
  },
  globalSetup: join(JEST_ENV, 'setup.js'),
}
