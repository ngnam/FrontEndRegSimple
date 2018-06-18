import request from 'supertest';

const app = process.app;

test('POST /login/email 200', done => {
  const email = 'test@regsimple.com';

  return request(app)
    .post('/api/login/email')
    .send({ user: email })
    .end((err, res) => {
      if (err) return done(err);

      expect(res.status).toBe(200);
      expect(res.body.email).toBe(email);

      return done();
    });
});
