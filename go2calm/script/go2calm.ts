import { load } from "cheerio";
import * as fs from "fs";
let fname = process.argv[2];
const chapter = process.argv[3];
// let fname = "../html/continue/fjj061004/fjj-01.htm";
if (fs.existsSync(fname)) {
    const v = fs.readFileSync(fname);
    const html = v;

    const $ = load(html);
    const main = $("div#js_content");
    let mp3 = "";
    $("mpvoice", main).each((i, voice) => {
        const addr = "https://res.wx.qq.com/voice/getvoice?mediaid=" +
            $(voice).attr("voice_encode_fileid");
        const fname = chapter + "-" + String(i);
        mp3 += fname + " % " + addr + "\n";
        $(voice).replaceWith(
            "<embed src='./mp3/" + fname + ".mp3' width='530px' height='80px' />",
        );
    });
    // const mpvoice = $("embed", main);
    
    // console.log(mp3);
    fs.appendFileSync("voice-urls", mp3);

    const title = $("section[data-role='title']", main);
    const p0 = $(title).text();
    const p1 = $(">section>section", title).eq(0).text();
    const p2 = $(">section>section", title).eq(1).text();
    // console.log(`${p1}, ${p2}`);
    $(title).prevAll().map((i, e) => {
        $(e).remove();
    });
    // $(title).prepend(mpvoice);
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
    fs.appendFileSync("img-urls", imgs);

    // const main_td = $("body>div>table>tbody>tr>td").eq(1);
    // main_td.children("table").each((i, e) => { $(e).remove(); });
    // main_td.children("script, hr").each((i, e) => { $(e).remove(); });
    // main_td.children("span, a").each((i, e) => { $(e).remove(); });
    // const td = $(main_td).html();
    console.log($(main).html());
}
