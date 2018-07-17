import request from 'supertest';

const app = process.app;

describe('POST /analytics', () => {
  test('200', done => {
    return request(app)
      .post('/api/analytics')
      .send({ eventName: 'TEST_EVENT', params: '{}' })
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(200);

        return done();
      });
  });
  test('400 and if no eventName', done => {
    return request(app)
      .post('/api/login/code')
      .send({ params: '{}' })
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(400);

        return done();
      });
  });
  test('400 and if no params', done => {
    return request(app)
      .post('/api/login/code')
      .send({ eventName: 'TEST_EVENT' })
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(400);

        return done();
      });
  });
});
