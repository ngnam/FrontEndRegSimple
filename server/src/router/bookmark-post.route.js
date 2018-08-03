import boom from 'boom';

export default ({ bookmarksService }) => async (req, res, next) => {
  const { snippetId, categoryId } = req.body;
  const { id: userId } = req.user;

  try {
    const bookmarkResponse = await bookmarksService.addBookmark({
      userId,
      snippetId,
      categoryId
    });
    const { created_at: createdAt } = bookmarkResponse;
    res.json({
      data: {
        createdAt,
        snippetId,
        categoryId
      }
    });
  } catch (e) {
    console.error(e);
    return next(boom.forbidden('bookmarksService failed to add new bookmark'));
  }
};
