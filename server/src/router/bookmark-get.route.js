import boom from 'boom';

export default ({ bookmarksService }) => async (req, res, next) => {
  const { id: userId } = req.user;

  try {
    const bookmarkResponse = await bookmarksService.getBookmarksByUserId({
      userId
    });
    const bookmarks = bookmarkResponse.map(
      ({ snippet_id, category_id, created_at, country_id }) => ({
        snippetId: snippet_id,
        categoryId: category_id,
        countryId: country_id,
        createdAt: created_at
      })
    );

    res.json({ data: bookmarks });
  } catch (e) {
    console.error(e);
    return next(boom.forbidden('bookmarksService failed to get bookmarks'));
  }
};
