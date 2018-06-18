import taxonomy from '../../__test__/__fixtures__/taxonomy.json';
import countries from '../../__test__/__fixtures__/countries.json';

export default () => (req, res) => {
  res.json({ data: { taxonomy, countries } });
};
