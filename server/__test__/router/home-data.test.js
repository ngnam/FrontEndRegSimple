import request from 'supertest';

const app = process.app;

describe('GET /home-data', () => {
  test('200 and correct data in response', done => {
    return request(app)
      .get('/api/home-data')
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
        expect(res.body.data.taxonomy).toMatchObject(taxonomyItemFormat);
        // expect(res.body.data.children[0]).toEqual(
        //   expect.objectContaining(layerFormat)
        // );
        return done();
      });
  });
});
