import boom from 'boom';

const bookmarksHandler = ({ bookmarksService }) => (req, res, next) => {
  const { snippetId, categoryId } = req.body;
  const { id: userId } = req.user;

  const addBookmark = async () => {
    try {
      const bookmarkResponse = await bookmarksService.addBookmark({
        userId,
        snippetId,
        categoryId
      });
      const { created_at: createdAt } = bookmarkResponse;
      console.log({ createdAt });
      res.json({ data: { createdAt } });
    } catch (e) {
      return next(
        boom.forbidden('bookmarksService failed to add new bookmark')
      );
    }
  };

  const removeBookmark = async () => {
    console.log('1');
    try {
      const bookmarkResponse = await bookmarksService.removeBookmark({
        userId,
        snippetId,
        categoryId
      });

      const { created_at: createdAt } = bookmarkResponse;
      res.json({ data: { createdAt } });
    } catch (e) {
      console.error(e);
      return next(boom.forbidden('bookmarksService failed to remove bookmark'));
    }
  };

  return {
    addBookmark,
    removeBookmark
  };
};

export default bookmarksHandler;
