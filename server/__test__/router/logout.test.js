import request from 'supertest';

const app = process.app;

describe('POST /logout', () => {
  test('200 and sets cookie', done => {
    return request(app)
      .post('/api/logout')
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.headers['set-cookie']).toHaveLength(1);
        expect(res.status).toBe(200);

        return done();
      });
  });
});
