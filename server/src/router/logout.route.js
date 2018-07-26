export default () => async (req, res, next) => {
  res.clearCookie('token', { httpOnly: true });
  res.sendStatus(200);
};
