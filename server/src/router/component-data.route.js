import taxonomy from '../../__test__/__fixtures__/taxonomy.json';

export default () => (req, res) => {
  res.json({ data: taxonomy });
};
