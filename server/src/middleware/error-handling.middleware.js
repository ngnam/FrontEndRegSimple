const errorHandler = () => (err, req, res, next) => {
  if (err.isBoom) {
    const { statusCode } = err.output;

    return res.status(statusCode).send({
      ...err.output.payload,
      data: err.data
    });
  }

  next.status(500).send({ statusCode: 500, message: 'Internal Server Error' });
};

export default errorHandler;
