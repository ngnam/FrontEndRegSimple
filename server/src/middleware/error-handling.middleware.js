const errorHandler = () => (err, req, res, next) => {
  if (err.isBoom) {
    const { statusCode } = err.output;

    return res.status(statusCode).send({
      ...err.output.payload,
      data: err.data
    });
  }

  res.status(500).send({ message: 'Internal Server Error' });
};

export default errorHandler;
