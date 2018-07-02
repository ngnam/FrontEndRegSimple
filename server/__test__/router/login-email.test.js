import request from 'supertest';
import userFixture from '../__env__/fixtures/user';

const app = process.app;

test('POST /login/email 200', done => {
  const email = 'test@regsimple.com';

  return request(app)
    .post('/api/login/email')
    .send({ email })
    .end((err, res) => {
      if (err) return done(err);

      expect(res.status).toBe(200);
      expect(res.body.data.userId).toBe(userFixture.userId);

      return done();
    });
});
