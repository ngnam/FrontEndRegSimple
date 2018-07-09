export default ({ jwtService }) => async (req, res, next) => {
  const { token } = req.cookies;

  if (!token) {
    return next();
  }

  try {
    const user = await jwtService.decode(token);

    req.user = user;

    return next();
  } catch (err) {
    return next();
  }
};
