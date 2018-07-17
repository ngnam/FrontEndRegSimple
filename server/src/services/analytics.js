const createAnalyticsService = () => dbClient => {
  const logEvent = async ({ eventName, params }) => {
    try {
      const query = {
        text: 'INSERT INTO analytics values($1, $2)',
        values: [eventName, JSON.stringify(params)]
      };
      await dbClient.query(query);

      console.log(`ANALYTICS ${eventName} success`);

      return { success: true };
    } catch (e) {
      console.error(`ANALYTICS ${eventName} failure.\nERROR ${e}`);

      return { success: false };
    }
  };

  return {
    logEvent
  };
};

export default createAnalyticsService;
