import boom from 'boom';

import { ROLE_EDITOR, ROLE_ADMIN } from '../constants/roles';

export default ({ config, searchApiService }) => async (req, res, next) => {
  const { snippetId, action } = req.params;
  const { userId } = req.user || {};
  const { categories, countries } = req.query;

  try {
    const apiResponse = await searchApiService.rejectSnippet({
      snippetId,
      userId,
      categories,
      countries
    });

    res.json({ data: apiResponse.data });
  } catch (err) {
    console.error('searchApiService.rejectSnippet failed', { err });
    return next(boom.forbidden('searchApiService.rejectSnippet failed'));
  }
};
