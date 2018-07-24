import puppeteer from 'puppeteer';
import path from 'path';
import os from 'os';
import fs from 'fs';

const { sep } = path;

const createPdfService = ({ config }) => {
  const create = async ({ html }) => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto(`data:text/html;charset=UTF-8,${html}`, {
      waitUntil: 'networkidle2'
    });

    const pdf = await page.pdf({
      format: 'A4',
      margin: { left: '1.5cm', top: '1cm', right: '1.5cm', bottom: '2cm' }
    });
    await browser.close();

    return pdf;
  };

  return { create };
};

export default createPdfService;
