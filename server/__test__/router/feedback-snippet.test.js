import request from 'supertest';

import rejectSnippetFixture from '../__env__/fixtures/reject-snippet';

const app = process.app;

describe('GET /feedback/snippet/:snippetId/:feedbackType', () => {
  test.skip('200 and "success:true" from FEEDBACK_REJECT request', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/reject?countries[]=GB&categories[]=aml-authority'
      )
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(200);
        expect(res.body.data).toMatchObject(rejectSnippetFixture);

        return done();
      });
  });
  test('403 if no cookie', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/reject?countries[]=GB&categories[]=aml-authority'
      )
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(401);

        return done();
      });
  });
  test('400 if countries not passed', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/reject?categories[]=aml-authority')
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(400);

        return done();
      });
  });
  test('400 if categories not passed', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/reject?countries[]=DK')
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(400);

        return done();
      });
  });
  test('400 from invalid feedback action', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/foo')
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(400);

        return done();
      });
  });
});
