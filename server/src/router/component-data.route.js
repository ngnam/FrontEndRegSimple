import taxonomy from '../fixtures/taxonomy';
import countries from '../fixtures/countries';

export default () => (req, res) => {
  res.json({ data: { taxonomy, countries } });
};
