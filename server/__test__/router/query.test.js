import request from 'supertest';

const app = process.app;

describe('GET /query', () => {
  test('200 if correct query params passed', done => {
    return request(app)
      .get('/api/query?countries[]=GB&categories[]=aml-authority')
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(200);

        return done();
      });
  });

  test('400 if countries not an array', done => {
    return request(app)
      .get('/api/query?countries=GB&categories[]=aml-authority')
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(400);

        return done();
      });
  });

  test('400 if categories not an array', done => {
    return request(app)
      .get('/api/query?countries[]=GB&categories=aml-authority')
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(400);

        return done();
      });
  });

  test('400 if no countries param', done => {
    return request(app)
      .get('/api/query?categories[]=aml-authority')
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(400);

        return done();
      });
  });

  test('400 if no categories param', done => {
    return request(app)
      .get('/api/query?countries[]=GB')
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(400);

        return done();
      });
  });

  test('400 if more than one country passed', done => {
    return request(app)
      .get(
        '/api/query?countries[]=GB&countries[]=FR&categories[]=aml-authority'
      )
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(400);

        return done();
      });
  });
});
