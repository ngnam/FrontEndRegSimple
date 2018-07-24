const createBookmarksService = () => dbClient => {
  const getBookmarksByUserId = async ({ userId }) => {
    const query = {
      text: 'SELECT * from users WHERE user_id=$1',
      values: [userId]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  const addBookmark = async ({ userId, snippetId, categoryId }) => {
    const query = {
      text: 'INSERT INTO bookmarks VALUES($1, $2, $3) RETURNING *',
      values: [userId, snippetId, categoryId]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  const removeBookmark = async ({ userId, snippetId, categoryId }) => {
    console.log('3');
    const query = {
      text:
        'DELETE FROM bookmarks WHERE user_id=$1 AND snippet_id=$2 AND category_id=$3 RETURNING *',
      values: [userId, snippetId, categoryId]
    };

    const res = await dbClient.query(query);

    return res.rows[0];
  };

  return {
    getBookmarksByUserId,
    addBookmark,
    removeBookmark
  };
};

export default createBookmarksService;
