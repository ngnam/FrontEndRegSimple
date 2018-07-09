import jwt from 'jsonwebtoken';

const createJwtService = ({ config }) => {
  const { JWT_SECRET } = config;

  const encode = data => {
    return new Promise((resolve, reject) => {
      jwt.sign(data, JWT_SECRET, (err, token) => {
        if (err) {
          return reject(err);
        }

        resolve(token);
      });
    });
  };

  const decode = token => {
    return new Promise((resolve, reject) => {
      jwt.verify(token, JWT_SECRET, (err, decoded) => {
        if (err) {
          return reject(err);
        }

        resolve(decoded);
      });
    });
  };

  return {
    encode,
    decode
  };
};

export default createJwtService;
