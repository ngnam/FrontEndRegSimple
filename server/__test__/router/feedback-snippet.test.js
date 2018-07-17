import request from 'supertest';

import rejectSnippetFixture from '../__env__/fixtures/reject-snippet';
import { admin, user } from '../__env__/fixtures/cookies';

const app = process.app;

describe('GET /feedback/snippet/:snippetId/:feedbackType', () => {
  test('200 and "success:true" from FEEDBACK_REJECT request', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/reject?countries[]=GB&categories[]=aml-authority'
      )
      .set('Cookie', [admin])
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(200);
        expect(res.body.data).toMatchObject(rejectSnippetFixture);

        return done();
      });
  });
  test('401 if no cookie', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/reject?countries[]=GB&categories[]=aml-authority'
      )
      .send()
      .expect(401)
      .end(done);
  });
  test('401 if role ROLE_USER', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/reject?countries[]=GB&categories[]=aml-authority'
      )
      .set('Cookie', [user])
      .send()
      .expect(401)
      .end(done);
  });
  test('400 if countries not passed', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/reject?categories[]=aml-authority')
      .set('Cookie', [admin])
      .send()
      .expect(400)
      .end(done);
  });
  test('400 if categories not passed', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/reject?countries[]=DK')
      .set('Cookie', [admin])
      .send()
      .expect(400)
      .end(done);
  });
  test('400 from invalid feedback action', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/foo')
      .set('Cookie', [admin])
      .send()
      .expect(400)
      .end(done);
  });
});
