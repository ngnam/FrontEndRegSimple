import puppeteer from 'puppeteer';
import path from 'path';
import { TEST } from '../constants/environments';

const createPdfService = ({ config }) => {
  const create = async ({ html }) => {
    const args = process.env === TEST ? ['--no-sandbox'] : [];
    const browser = await puppeteer.launch({ args });
    const page = await browser.newPage();
    await page.goto(`data:text/html;charset=UTF-8,${html}`, {
      waitUntil: 'networkidle2'
    });

    const pdf = await page.pdf({
      format: 'A4',
      margin: { left: '1.5cm', top: '2cm', right: '1.5cm', bottom: '2cm' },
      displayHeaderFooter: true,
      headerTemplate:
        '<header style="margin: 0 20px; font-size: 12px; font-family: sans-serif;"><span class="date"></span></header>',
      footerTemplate:
        '<footer style="margin: 0 20px; width: 100%; font-size: 12px; font-family: sans-serif; display: flex; justify-content: space-between;"><span><span class="pageNumber"></span>/<span class="totalPages"></span></span><span>&copy; RegSimple</span></footer>'
    });
    await browser.close();

    return pdf;
  };

  return { create };
};

export default createPdfService;
