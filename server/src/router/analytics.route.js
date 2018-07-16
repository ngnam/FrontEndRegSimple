export default ({ config, analyticsService }) => async (req, res, next) => {
  const { eventName, params } = req.body;

  await analyticsService.logEvent({ eventName, params });
  res.sendStatus(200);
};
