import request from 'supertest';

import app from '../app';

test('POST /login/email 200', done => {
  const email = 'test@regsimple.com';

  return request(app)
    .post('/login/email')
    .send({ user: email })
    .end((err, res) => {
      if (err) return done(err);

      expect(res.status).toBe(200);
      expect(res.body.email).toBe(email);

      return done();
    });
});
