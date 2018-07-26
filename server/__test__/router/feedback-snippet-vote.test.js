import request from 'supertest';

import { admin, editor, user } from '../__env__/fixtures/cookies';

const app = process.app;

describe('GET /feedback/snippet/:snippetId/vote', () => {
  const userCookie = user();
  const editorCookie = editor();
  const adminCookie = admin();

  test('200 and if ROLE_ADMIN', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/vote/up')
      .set('Cookie', [adminCookie])
      .send({ categoryId: 'id123' })
      .expect(200)
      .end(done);
  });
  test('200 if ROLE_EDITOR', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/vote/up')
      .set('Cookie', [editorCookie])
      .send({ categoryId: 'id123' })
      .expect(200)
      .end(done);
  });
  test('200 if ROLE_USER', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/vote/up')
      .set('Cookie', [userCookie])
      .send({ categoryId: 'id123' })
      .expect(200)
      .end(done);
  });
  test('401 if no cookie', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/vote/up')
      .send({ categoryId: 'id123' })
      .expect(401)
      .end(done);
  });
  test('400 if categoryId not passed', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/vote/up')
      .set('Cookie', [adminCookie])
      .send()
      .expect(400)
      .end(done);
  });
  test('400 if invalid categoryId passed', done => {
    return request(app)
      .put('/api/feedback/snippet/id123/vote/up')
      .set('Cookie', [adminCookie])
      .send({ categoryId: 1234 })
      .expect(400)
      .end(done);
  });
});
