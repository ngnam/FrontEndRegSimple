import boom from 'boom';

export default ({ userService }) => async (req, res, next) => {
  const { id: userId } = req.user || {};
  const { userType } = req.body;

  try {
    await userService.editUser({ userId, userType });

    return res.json();
  } catch (err) {
    console.error(err);
    return next(boom.forbidden('user edit route failed', err.details));
  }
};
