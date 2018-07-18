export default ({ config, analyticsService }) => (req, res, next) => {
  const { eventName, params } = req.body;

  analyticsService.logEvent({ eventName, params });
  res.sendStatus(200);
};
