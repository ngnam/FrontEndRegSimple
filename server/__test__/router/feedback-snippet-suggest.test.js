import request from 'supertest';

import suggestSnippetFixture from '../__env__/fixtures/suggest-snippet';
import { admin, editor, user } from '../__env__/fixtures/cookies';

const app = process.app;

describe('GET /feedback/snippet/:snippetId/suggest', () => {
  const userCookie = user();
  const editorCookie = editor();
  const adminCookie = admin();

  test('200 and "success:true" if ROLE_ADMIN', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/suggest?countries[]=GB&categories[]=aml-authority'
      )
      .set('Cookie', [adminCookie])
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(200);
        expect(res.body.data).toMatchObject(suggestSnippetFixture);

        return done();
      });
  });
  test('200 if ROLE_EDITOR', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/suggest?countries[]=GB&categories[]=aml-authority'
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
        '/api/feedback/snippet/id123/suggest?countries[]=GB&categories[]=aml-authority'
      )
      .send()
      .expect(401)
      .end(done);
  });
  test('401 if role ROLE_USER', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/suggest?countries[]=GB&categories[]=aml-authority'
      )
      .set('Cookie', [userCookie])
      .send()
      .expect(401)
      .end(done);
  });
  test('400 if countries not passed', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/suggest?categories[]=aml-authority')
      .set('Cookie', [adminCookie])
      .send()
      .expect(400)
      .end(done);
  });
  test('400 if categories not passed', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/suggest?countries[]=DK')
      .set('Cookie', [adminCookie])
      .send()
      .expect(400)
      .end(done);
  });
  test('200 if valid suggestedCategories passed', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/suggest?countries[]=GB&categories[]=aml-authority'
      )
      .set('Cookie', [adminCookie])
      .send({ suggestedCategories: ['id1'] })
      .expect(200)
      .end(done);
  });
  test('400 if invalid suggestedCategories passed', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/suggest?countries[]=GB&categories[]=aml-authority'
      )
      .set('Cookie', [adminCookie])
      .send({ suggestedCategories: '' })
      .expect(400)
      .end(done);
  });
  test('200 if empty array suggestedCategories passed', done => {
    return request(app)
      .put(
        '/api/feedback/snippet/id123/suggest?countries[]=GB&categories[]=aml-authority'
      )
      .set('Cookie', [adminCookie])
      .send({ suggestedCategories: [] })
      .expect(200)
      .end(done);
  });
});
