import boom from 'boom';
import path from 'path';
import pug from 'pug';
import fs from 'fs';

const htmlPath = path.join(__dirname, '..', 'html-templates', 'query-pdf.pug');
const createHtml = pug.compileFile(htmlPath);

console.log('outside', { htmlPath });

export default ({ pdfService, searchApiService, config }) => async (
  req,
  res,
  next
) => {
  const { countries, categories, activity } = req.query;
  const {
    fetchTaxonomy,
    fetchCountries,
    multiCategoryCountrySearch
  } = searchApiService;

  try {
    const [
      { data: taxonomy },
      { data: countryLabels },
      ...results
    ] = await Promise.all([
      fetchTaxonomy(),
      fetchCountries(),
      ...multiCategoryCountrySearch({ countries, categories })
    ]);

    const activityId = activity[0];

    const flatten = (layer, init) => {
      init = init || [];
      return layer.children.reduce(
        (accum, curr) =>
          accum.concat(flatten(curr, curr.children)).concat(curr),
        init
      );
    };

    const taxonomyDict = flatten(taxonomy).reduce((accum, curr) => {
      if (!curr.id) return accum;

      accum[curr.id] = curr;

      return accum;
    }, {});

    const title = `RegSimple--${countries.reduce(
      (str, id) => `${str}${id}-`,
      ''
    )}-${categories[0]}`;

    console.log('inside', { htmlPath });

    const html = createHtml({
      CLIENT_APP_BASE_URL: config.CLIENT_APP_BASE_URL,
      countryLabels,
      taxonomyDict,
      activityId,
      results,
      title
    });

    console.log('html', { html });

    const pdf = await pdfService.create({ html });

    res.setHeader('Content-Disposition', `attachment; filename=${title}.pdf`);

    return res.send(pdf);
  } catch (err) {
    console.error(err);
    return next(boom.forbidden('failed', err.details));
  }
};
