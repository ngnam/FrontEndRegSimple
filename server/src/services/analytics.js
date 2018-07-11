const createAnalyticsService = () => dbClient => {
  const logEvent = ({ eventName, params }) => {
    const query = {
      text: 'INSERT INTO analytics values($1, $2)',
      values: [eventName, JSON.stringify(params)]
    };
    dbClient
      .query(query)
      .then(() => console.log(`ANALYTICS ${eventName} success`) || 'success')
      .catch(
        () => console.error(`ANALYTICS ${eventName} failure`) || 'failure'
      );
  };

  return {
    logEvent
  };
};

export default createAnalyticsService;
