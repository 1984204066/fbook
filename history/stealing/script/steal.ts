import { load } from "cheerio";
import * as fs from "fs";
let fname = process.argv[2];
const chapter = process.argv[3];
// let fname = "../html/continue/fjj061004/fjj-01.htm";
if (fs.existsSync(fname)) {
    const v = fs.readFileSync(fname);
    const html = v;

    const $ = load(html);
    let main = $("div#js_content");
    let mp3 = "";
    // const mpvoice = $("embed", main);
    $("mpvoice", main).each((i, voice) => {
        const addr = "https://res.wx.qq.com/voice/getvoice?mediaid=" +
            $(voice).attr("voice_encode_fileid");
        const fname = chapter + "-" + String(i);
        mp3 += fname + " % " + addr + "\n";
        $(voice).replaceWith(
            "<embed src='./mp3/" + fname + ".mp3' width='530px' height='80px' />",
        );
    });    
    if (mp3 !== "") {
	fs.appendFileSync("voice-urls", mp3);
    }
    let imgs = "";
    $("img", main).each((i, img) => {
        // console.log($.xml(img));
        const src = $(img).attr("data-src");
        // console.log(src);
        let ext = src && src.match(/wx_fmt=([^&]*)/)?.[0] || "";
        ext = ext.replace(/wx_fmt=([^&]*)/, "$1");
	const fname = chapter + "-" + String(i) + "." + ext;
        imgs += fname + " % " + src + "\n";
	$(img).replaceWith("<img src='./img/" + fname + "'>")
    });
    const imgn = $('img', main).length;
    
    const title = $("h1").eq(0).text();
    console.error(title);
    $('h1').map((i,e)=>{
	$(e).replaceWith("<p>" + $(e).text() + "</p>");
    });
    const content = $(main).children().eq(3);
    // console.log($(main).children().length, $(content).text());
    $(content).prevAll().map((i, e) => {
	// console.log(i, $(e).text());
        $(e).remove();
    });
    const trim_head = imgn !== $('img', main).length;
    appendImage(imgs, trim_head);
    // main chanaged, so reload it.
    main = $("div#js_content");
    console.log($(main).html());
}

function appendImage(imgs: string, trim_head = false, trim_tail = true) {
    let image = imgs.split("\n", -1);
    // console.log(image);
    // assert(image.length >= 2);
    // a删除第一和最后一个元素。
    if (trim_head) {
	image.shift();
    }
    let img : string | undefined;
    do {
	img = image.pop();
    } while(img !== undefined && img === '');
    imgs = image.join("\n")+"\n";
    fs.appendFileSync("img-urls", imgs);
}
