import boom from 'boom';

export default ({ userService, jwtService }) => async (req, res, next) => {
  const { id: userId } = req.user || {};

  try {
    let userData;

    if (userId) {
      userData = await userService.getUserById(userId);
    }
    if (!userId) {
      userData = await userService.createUser();
    }

    const token = await jwtService.encode(userData);
    res.cookie('token', token, { httpOnly: true });

    return res.json({ data: userData });
  } catch (err) {
    console.error(err);
    return next(boom.forbidden('user edit route failed', err.details));
  }
};
