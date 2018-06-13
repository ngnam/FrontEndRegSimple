import request from 'supertest';

const app = process.app;

describe('GET /component-data', () => {
  // TODO: we must check that apart from the first level, all `children` arrays
  // contain enabled: Bool, id: String, children: Array
  test('200 and correct data in response', done => {
    return request(app)
      .get('/component-data')
      .send()
      .end((err, res) => {
        if (err) return done(err);

        const taxonomyItemFormat = {
          id: null,
          enabled: false,
          name: null,
          children: expect.any(Array)
        };

        expect(res.status).toBe(200);
        expect(res.body.data).toMatchObject(taxonomyItemFormat);
        // expect(res.body.data.children[0]).toEqual(
        //   expect.objectContaining(layerFormat)
        // );
        return done();
      });
  });
});
