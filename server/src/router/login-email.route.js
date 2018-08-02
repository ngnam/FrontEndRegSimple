import boom from 'boom';
import { ROLE_UNAUTHENTICATED } from '../constants/roles';

export default ({ userService, passwordlessService }) => async (
  req,
  res,
  next
) => {
  const { id: userId } = req.user || {};
  const { email } = req.body;
  try {
    let user =
      (await userService.getUserByEmail(email)) ||
      (await userService.getUserById(userId));

    if (user && user.role === ROLE_UNAUTHENTICATED) {
      console.log('verifying');
      user = await userService.verifyUser({ userId, email });
    } else if (!user) {
      console.log('creating new user');
      user = await userService.createUser(email);
    }

    const { code } = await passwordlessService.createOneTimeCode(user.id);
    console.log({ code });
    // await passwordlessService.sendCode(code, email);

    return res.json({ data: user });
  } catch (err) {
    console.error(err);
    return next(boom.forbidden('login route failed', err.details));
  }
};
