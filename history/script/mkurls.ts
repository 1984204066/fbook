import puppeteer from "puppeteer";
import { load } from "cheerio";
import * as fs from "fs";
let fname = process.argv[2];
// let fname = "../html/continue/fjj061004/fjj-01.htm";
if (fs.existsSync(fname)) {
    const v = fs.readFileSync(fname);
    const html = v;

    const $ = load(html);
    const main = $("div.album__content");
    // fs.appendFileSync("img-urls", imgs);

    const content = $('li', main).map((i, e) => {
	// console.log(i, $(e).text());
	const title= $(e).attr('data-title');
        const link = $(e).attr('data-link');
	console.log(`${title} % ${link}`);
    });
}
