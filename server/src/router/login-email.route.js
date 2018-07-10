import boom from 'boom';

export default ({ userService, passwordlessService }) => async (
  req,
  res,
  next
) => {
  const { email } = req.body;
  try {
    let user = await userService.getUserByEmail(email);

    if (!user.rows[0]) user = await userService.createUser(email);

    const userId = user.rows[0].id;
    const code = await passwordlessService.createOneTimeCode(userId);

    passwordlessService.sendCode(code, email, (err, pgRes) => {
      res.json({ data: { userId } });
    });
  } catch (err) {
    console.error(err);
    return next(boom.forbidden('login route failed', err.details));
  }
};
