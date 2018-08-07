import boom from 'boom';

export default ({ searchApiService }) => async (req, res, next) => {
  const { blocks } = req.query;

  try {
    const bookmarkResponse = await searchApiService.fetchSnippetDetails({
      blocks
    });
    console.log('>>>>>>', bookmarkResponse);

    res.json({ data: bookmarkResponse.data });
  } catch (e) {
    console.error(e.message);
    return next(boom.forbidden('bookmarksService failed to get bookmarks'));
  }
};
