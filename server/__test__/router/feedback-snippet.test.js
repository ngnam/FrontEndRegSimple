import request from 'supertest';

import rejectSnippetFixture from '../__env__/fixtures/reject-snippet';
import { admin, editor, user } from '../__env__/fixtures/cookies';

const app = process.app;

describe('GET /feedback/snippet/:snippetId/:feedbackType', () => {
  const userCookie = user();
  const editorCookie = editor();
  const adminCookie = admin();

  test('200 and "success:true" if ROLE_ADMIN', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/reject?countries[]=GB&categories[]=aml-authority'
      )
      .set('Cookie', [adminCookie])
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(200);
        expect(res.body.data).toMatchObject(rejectSnippetFixture);

        return done();
      });
  });
  test('200 if ROLE_EDITOR', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/reject?countries[]=GB&categories[]=aml-authority'
      )
      .set('Cookie', [editorCookie])
      .send()
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);

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
      .set('Cookie', [userCookie])
      .send()
      .expect(401)
      .end(done);
  });
  test('400 if countries not passed', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/reject?categories[]=aml-authority')
      .set('Cookie', [adminCookie])
      .send()
      .expect(400)
      .end(done);
  });
  test('400 if categories not passed', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/reject?countries[]=DK')
      .set('Cookie', [adminCookie])
      .send()
      .expect(400)
      .end(done);
  });
  test('400 from invalid feedback action', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/foo')
      .set('Cookie', [adminCookie])
      .send()
      .expect(400)
      .end(done);
  });
});
