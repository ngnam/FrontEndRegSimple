import request from 'supertest';
import qs from 'qs';

const app = process.app;

const searchResultsFormat = {
  n_matches: 10,
  total_matches: 100,
  max_score: 1.5,
  matches: expect.any(Array)
};
const endpoint = ({ countries, categories, activity, filterText }) =>
  '/api/export/query-results.pdf?' +
  qs.stringify(
    { countries, categories, activity: [activity], filterText },
    { arrayFormat: 'brackets' }
  );

const countries = ['GB', 'TZ'];
const categories = ['aml-authority'];
const activity = 'aml';
const filterText = 'hello';

describe('GET /exporty/query-results.pdf', () => {
  test('200 and correct results if correct query params passed', done => {
    return request(app)
      .get(endpoint({ countries, categories, activity }))
      .send()
      .expect(200)
      .expect('Content-Type', 'application/octet-stream')
      .end(done);
  });

  test('400 if multiple categories passed', done => {
    return request(app)
      .get(
        endpoint({
          countries,
          categories: categories.concat('aml-cdd'),
          activity
        })
      )
      .send()
      .expect(400)
      .end(done);
  });

  test('400 if activity[] param not passed', done => {
    return request(app)
      .get(endpoint({ countries, categories }))
      .send()
      .expect(400)
      .end(done);
  });

  test('400 if countries not an array', done => {
    return request(app)
      .get('/api/query?countries=GB&categories[]=aml-authority')
      .send()
      .expect(400)
      .end(done);
  });

  test('400 if categories not an array', done => {
    return request(app)
      .get('/api/query?countries[]=GB&categories=aml-authority')
      .send()
      .expect(400)
      .end(done);
  });

  test('400 if no countries param', done => {
    return request(app)
      .get('/api/query?categories[]=aml-authority')
      .send()
      .expect(400)
      .end(done);
  });

  test('400 if no categories param', done => {
    return request(app)
      .get('/api/query?countries[]=GB')
      .send()
      .expect(400)
      .end(done);
  });

  test('400 if more than two country passed', done => {
    return request(app)
      .get(
        '/api/query?countries[]=GB&countries[]=FR&countries[]=TZ&categories[]=aml-authority'
      )
      .send()
      .expect(400)
      .end(done);
  });
});
