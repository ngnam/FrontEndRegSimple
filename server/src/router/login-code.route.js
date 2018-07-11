import boom from 'boom';
import differenceInMinutes from 'date-fns/difference_in_minutes';

export default ({ passwordlessService, userService, jwtService }) => async (
  req,
  res,
  next
) => {
  const { userId, code } = req.body;

  try {
    const {
      code: correctCode,
      created_at: createdAt
    } = await passwordlessService.getCodeDetailsByUserId(userId);

    if (code !== correctCode) {
      console.error('incorrect code', { code, correctCode });
      return next(boom.forbidden('login failed, incorrect code'));
    }

    if (differenceInMinutes(new Date(), new Date(createdAt)) > 5) {
      console.error('too long since code generated');
      return next(boom.forbidden('login failed, timeout'));
    }

    const user = await userService.getUserById(userId);

    const userData = {
      id: user.id,
      email: user.email
    };

    const token = await jwtService.encode(userData);

    res.cookie('token', token);

    res.send({ data: userData });
  } catch (err) {
    console.error(err);
    return next(boom.forbidden('login failed'));
  }
};
