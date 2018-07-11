import request from 'supertest';

import user from '../__env__/fixtures/user';
import passwordless from '../__env__/fixtures/passwordless';

const app = process.app;

const userId = user.id;
const validCode = passwordless.code;
const invalidCode = '0000';

describe('POST /login/code', () => {
  test('200 and sets cookie', done => {
    return request(app)
      .post('/api/login/code')
      .send({ code: validCode, userId })
      .end((err, res) => {
        if (err) return done(err);

        expect(res.headers['set-cookie']).toHaveLength(1);
        expect(res.status).toBe(200);

        return done();
      });
  });
  test('403 and if code invalid', done => {
    return request(app)
      .post('/api/login/code')
      .send({ code: invalidCode, userId })
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(403);

        return done();
      });
  });
});
