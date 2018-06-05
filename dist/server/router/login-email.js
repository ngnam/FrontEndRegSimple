'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

exports.default = function () {
  return function (req, res) {
    var user = req.body.user;


    res.json({ email: user, foo: 'bar' });
  };
};