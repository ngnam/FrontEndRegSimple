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
      res.json({
        data: {
          createdAt,
          snippetId,
          categoryId
        }
      });
    } catch (e) {
      console.error(e);
      return next(
        boom.forbidden('bookmarksService failed to add new bookmark')
      );
    }
  };

  const removeBookmark = async () => {
    try {
      const bookmarkResponse = await bookmarksService.removeBookmark({
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
      return next(boom.forbidden('bookmarksService failed to remove bookmark'));
    }
  };

  const getBookmarks = async () => {
    try {
      const bookmarkResponse = await bookmarksService.getBookmarksByUserId({
        userId
      });
      const bookmarks = bookmarkResponse.map(
        ({ snippet_id, category_id, created_at }) => ({
          snippetId: snippet_id,
          categoryId: category_id,
          createdAt: created_at
        })
      );

      res.json({ data: bookmarks });
    } catch (e) {
      console.error(e);
      return next(boom.forbidden('bookmarksService failed to get bookmarks'));
    }
  };

  return {
    addBookmark,
    removeBookmark,
    getBookmarks
  };
};

export default bookmarksHandler;
