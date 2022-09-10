import puppeteer from "puppeteer";
import { load, CheerioAPI} from "cheerio";
import * as fs from "fs";

const browser = await puppeteer.connect({
    slowMo: 100,
    browserURL: "http://localhost:9222", //connect to Google Chrome
});
const page = await browser.newPage();

async function scrollPage(i:number) {
    /*执行js代码（滚动页面）*/
    await page.evaluate(function (i) {
	/* 这里做的是渐进滚动，如果一次性滚动则不会触发获取新数据的监听 */
	for (var y = 0; y <= 1000*i; y += 100) {
	    window.scrollTo(0,y)
	}
    })
    return;
}

try {
    let limap = new Map();
    let fname = process.argv[2];
    const nchapter = process.argv[3];
    if (fname === "" || nchapter === "") {
	console.error("Usage heart url-file n-item")
    } else {
	const url= fs.readFileSync(fname);
	console.error(url);
	await page.goto(url.toString());
	let i = 0;
	do {
	    let content = await page.content();
	    let $ = load(content);
	    // 获取数据列表
	    const lis = $($('.album__content').find('ul')[0]).find('li')
	    $(lis).map((k, e) => {
		// console.log(i, $(e).text());
		const title= $(e).attr('data-title');
		const link = $(e).attr('data-link');
		limap.set(title, link);
		console.log(`${title} % ${link}`);
	    });

	    let li = await scrollPage(++i)
	    //如果数据列表 不够30 则一直获取
	    // const main = $("div.album__content");

	} while (limap.size < Number(nchapter));
	for (let [key, value] of limap) {
	    fs.appendFileSync("out.urls", key + ' % ' + value + '\n');	
	}
    }
    /* 关闭 puppeteer*/
    await browser.close()
} catch (err) {
    console.error(err);
}
