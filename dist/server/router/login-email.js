'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

exports.default = () => (req, res) => {
  const { user } = req.body;

  res.json({ email: user, foo: 'bar' });
};