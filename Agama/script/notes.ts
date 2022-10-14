import { launch, Page, Browser } from "puppeteer";
// import {intercept, patterns } from 'puppeteer-interceptor';
import { load } from "cheerio";
import * as fs from "fs";
import {execaCommand} from 'execa';

let notemap = new Map();
let notefiles = new Array();
var note_array = new Array();
const min = process.argv[2];

function fileNo(aref:string[]) {
    let notef = new Array();
    for (let a of aref) {
        const filenum = Math.floor(Number(a) / 100);

	if (filenum === undefined) {
	    console.log('x:', a, 'filenum:', filenum)
	    continue;
	} 
        if (notefiles[filenum]) continue; else notef[filenum] = filenum;
        // if (notemap.has(key) && notemap.get(key) !== "") {
        //     console.log("already have:", key)
        //     continue;
        // }
        // retryHover(page, over);
    }
    return notef;
}

async function oneUrl(browser: Browser, url: string) {
    const fid = url.substring(url.lastIndexOf("/") + 3, url.lastIndexOf("."));
    console.log('reading...', url);

    const page = await browser.newPage();
    await page.goto(url);
    await page.waitForTimeout(1000);

    page.on("console", (msg) => console.log(msg.text()));
    // await page.exposeFunction('mynote', (text:string) => mynote(text));

    // await page.evaluate(async (source) => {
    // 	const { note2 } = await import(`data:text/javascript,${source}`);
    // 	note2(47);
    // }, fs.readFileSync('./sn2.js', 'utf8'));
    // const f = await page.addScriptTag({path: './sn2.js'});

    // const note_code = fs.readFileSync('./sn2.js', 'utf8');
    // intercept(page, patterns.Script('*sn.js'), {
    //    onResponseReceived: event => {
    //         console.log(`${event.request.url} intercepted, going to modify`)
    //         event.response.body = note_code;
    //         return event.response;
    //     }
    // });

    let content = await page.content();
    let $ = load(content);
    const aref = $(".nikaya a[onmouseover]").map((i,a)=>{
        const over = $(a).attr("onmouseover") || "note(this,0);";
        const s = over?.replace(/[^0-9]/g, "");
	return s;
    }).toArray();
    // console.log(aref);
    let notef = fileNo(aref);

    console.log(notef)
    for (let f of notef) {
	if (f === undefined) continue;
	if (f < Number(min)) continue;
        await page.evaluate(ajaxRequest, f);
        while (true) {
	    console.log("waiting for reply:", f)
            await page.waitForTimeout(200);
            try {
		const id = '#notef' + f;
		const note = await page.$eval(id, div => div.innerHTML);
		notefiles[f] = note;
		break;
            } catch (e) {
		console.error(e);
	    }
        }
	fs.appendFileSync("../html/notes.html", notefiles[f])
    }
    // for (let f of notefiles) {
    //     console.log(f);
    //     console.log("===========================================");
    // }
    await page.close();
}

function ajaxRequest(x: number) {
    // const promise = new Promise((resolve, reject) => {
    // });
    const url = "http://www.agama.buddhason.org/note/note" + x + ".htm";
    // （1）创建异步对象
    var ajaxObj = new XMLHttpRequest();
    // （2）设置请求的参数。包括：请求的方法、请求的url。
    ajaxObj.open("get", url);
    // （3）发送请求
    ajaxObj.send();
    console.log("send ajax request");
    //（4）注册事件。 onreadystatechange事件，状态改变时就会调用。
    //如果要在数据完整请求回来的时候才调用，我们需要手动写一些判断的逻辑。
    ajaxObj.onreadystatechange = function () {
        // 为了保证 数据 完整返回，我们一般会判断 两个值
        if (ajaxObj.readyState == 4 && ajaxObj.status == 200) {
            // 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
            // 5.在注册的事件中 获取 返回的 内容 并修改页面的显示
            console.log("数据返回成功", x);
            // 数据是保存在 异步对象的 属性中
            // console.log(ajaxObj.responseText);
            // 修改页面的显示
            let xf = document.querySelector("body");
            const div = `<div id="notef${x}">${ajaxObj.responseText}</div>`;
            xf?.insertAdjacentHTML("beforeend", div);

            // resolve(ajaxObj.responseText);
        }
    };
    // return promise;
}

async function retryHover(page: Page, over: string) {
    // console.log(key);
    const aid = "a[onmouseover='" + over + "']";
    const gl = over?.indexOf("note") >= 0 ? "G" : "L";
    const x = over?.replace(/[^0-9]/g, "");
    // const key = gl === 'G'? gl  + x : gl  +fid + '.' + x;
    const key = gl + x;
    // console.log(aid);
    await page.hover(aid);
    let prev = "";
    let retry = 0;
    do {
        const div = await page.$("#notediv");
        // const html = await page.$eval('#notediv', (div) => div.innerHTML);
        const html = await page.evaluate((div) => div.innerHTML, div);
        await page.waitForTimeout(200);
        if (html === "" || html.indexOf("載入中") >= 0 || prev === html) {
            await page.waitForTimeout(100);
            if (retry++ % 10 === 0) {
                await page.keyboard.press("PageDown");
            }
            const aref = await page.$(aid);
            //test(aref);
            const box = await div?.boundingBox();
            // const mynote = await page.evaluateHandle((num:string)=>num, key);
            // const note = await page.evaluate(async (source, x) => {
            //     console.log(source)
            //     const { note2 } = await import(`data:text/javascript,${source}`);
            //     // note2(x);
            // }, fs.readFileSync('./sn2.js', 'utf8'), x);
            // const note = await callNote(page, x);
            // const note = await page.evaluateHandle(()=>note);
            // console.log(key, ": retry!!", note)
            continue;
        }
        prev = html;
        notemap.set(key, html);
        // console.log(html);
        break;
    } while ((retry += 10) < 100);
    if (retry >= 10) {
        notemap.set(key, "");
    }
}

// const url = "http://www.agama.buddhason.org/SN/SN0001.htm";
// const fname = process.argv[2];
// const urls = fs.readFileSync(fname).toString().split("\n", -1);

// const url_base = "file:///fbook/Agama/script/../html/SN/SN"
const url_base = "http://www.agama.buddhason.org/SN/SN"
const browser = await launch({
    headless: false,
    // executablePath: '/usr/bin/firefox',
    slowMo: 100,
    args: [
	"--start-maximized",
	"-no-sandbox",
    ],
    defaultViewport: null,
});

for (let n = 1; n <= 1806 ; n++) {
    const sn = n.toLocaleString('en',{minimumIntegerDigits:4,useGrouping:false});
    console.log(sn);
    const url = url_base + sn + '.htm'
    // if (url === "") {
    //     continue;
    // }
    try {
        const data = await oneUrl(browser, url);
	if (n % 5 === 0) {
	    // system ls -t /tmp | grep puppeteer_dev_profile | tail -n +2 | awk '{print "/tmp/"$1}' | xargs -l1 rm -rf
	    const stdout = await execaCommand(`/bin/ls -t /tmp | grep puppeteer_dev_profile | tail -n +2 | awk '{print "/tmp/"$1}' | xargs -l1 rm -rf`, {shell: '/usr/bin/bash'});
	}
    } catch (err) {
        console.error(err);
    }
}
await browser.close();
