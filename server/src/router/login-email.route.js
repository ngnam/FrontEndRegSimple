import boom from 'boom';

export default ({ userService, passwordlessService }) => async (
  req,
  res,
  next
) => {
  const { email } = req.body;
  try {
    const user =
      (await userService.getUserByEmail(email)) ||
      (await userService.createUser(email));

    const { code } = await passwordlessService.createOneTimeCode(user.id);

    await passwordlessService.sendCode(code, email);

    return res.json({ data: user });
  } catch (err) {
    console.error(err);
    return next(boom.forbidden('login route failed', err.details));
  }
};
