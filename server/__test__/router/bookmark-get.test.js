import request from 'supertest';

import snippetBookmarkFixture from '../__env__/fixtures/snippet-bookmark';
import { admin, editor, user } from '../__env__/fixtures/cookies';

const app = process.app;

describe('GET /bookmark', () => {
  const userCookie = user();

  const expected = { createdAt: snippetBookmarkFixture.created_at };

  test('200 and snippetBookmarkMetadata data if ROLE_USER', done => {
    return request(app)
      .get('/api/bookmark')
      .set('Cookie', [userCookie])
      .send()
      .end((err, res) => {
        if (err) return done(err);

        expect(res.status).toBe(200);
        expect(res.body.data).toHaveLength(2);
        expect(res.body.data).toHaveLength(2);
        expect(res.body.data[0]).toHaveProperty('snippetId');
        expect(res.body.data[0]).toHaveProperty('categoryId');
        return done();
      });
  });

  test('401 if user not logged in', done => {
    return request(app)
      .get('/api/bookmark')
      .send()
      .expect(401)
      .end(done);
  });
});
