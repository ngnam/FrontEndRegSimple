import boom from 'boom';

import { ROLES } from '../constants/roles';

export default ({ minRole }) => async (req, res, next) => {
  const { user } = req;
  if (!user) {
    console.warn(`Unauthorised request
      An unauthenticated user made the following unauthorised request:
      ${req.method} ${req.url}
      This route requires a minimum role of ${minRole}.
    `);

    return next(boom.unauthorized());
  }

  const { role, id, email } = user;

  if (ROLES.indexOf(role) < ROLES.indexOf(minRole)) {
    console.warn(`Unauthorised request
      User ${id} ${email} made the following unauthorised request:
      ${req.method} ${req.url}
      This route requires a minimum role of ${minRole}, but this user has role ${role}.
    `);

    return next(boom.unauthorized());
  }

  return next();
};
