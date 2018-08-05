import request from 'supertest';

import snippetBookmarkFixture from '../__env__/fixtures/snippet-bookmark';
import { admin, editor, user } from '../__env__/fixtures/cookies';

const app = process.app;

describe('DELETE /bookmark', () => {
  const userCookie = user();
  const addBookmarkPaylod = {
    snippetId: '1234',
    categoryId: 'category'
  };
  const expected = {
    createdAt: snippetBookmarkFixture.created_at
  };

  test('200 and snippetBookmarkMetadata data if ROLE_USER', done => {
    return request(app)
      .delete('/api/bookmark')
      .set('Cookie', [userCookie])
      .send(addBookmarkPaylod)
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(200);
        expect(res.body.data).toMatchObject(expected);
        expect(res.body.data).toHaveProperty('snippetId');
        expect(res.body.data).toHaveProperty('categoryId');

        return done();
      });
  });

  test('401 if user not logged in', done => {
    return request(app)
      .delete('/api/bookmark')
      .send(addBookmarkPaylod)
      .expect(401)
      .end(done);
  });

  test('400 if no categoryId in payload', done => {
    const badPayload = {
      ...addBookmarkPaylod
    };
    delete badPayload.categoryId;
    return request(app)
      .delete('/api/bookmark')
      .set('Cookie', [userCookie])
      .send(badPayload)
      .expect(400)
      .end(done);
  });
  test('400 if no snippetId in payload', done => {
    const badPayload = {
      ...addBookmarkPaylod
    };
    delete badPayload.snippetId;
    return request(app)
      .delete('/api/bookmark')
      .set('Cookie', [userCookie])
      .send(badPayload)
      .expect(400)
      .end(done);
  });
  test('400 if no payload', done => {
    return request(app)
      .delete('/api/bookmark')
      .set('Cookie', [userCookie])
      .send()
      .expect(400)
      .end(done);
  });
});
