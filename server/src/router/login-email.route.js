export default () => (req, res) => {
  const { user } = req.body;

  res.json({ email: user, foo: 'bar' });
};
