import { load,BasicAcceptedElems, AnyNode} from "cheerio";
import * as fs from "fs";
import assert from "assert";

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

    const title = $("h1").text();
    console.error(title);
    const content = $("section[data-support='96编辑器']").eq(0);
    $(content).prevAll().map((i, e) => {
        $(e).remove();
    });
    {
	function pick(i:number,e:BasicAcceptedElems<AnyNode>) : boolean {
	    const style=$(e).attr('style');
	    if (style !== undefined && style.match(/text-align: center/)) {
		// console.log($(e).text());
		return true;
	    }
	    return false;	    
	}
	const content = $("section,p[style]").filter(pick).map((i,e)=>{
	    const txt = $(e).text();
	    if (txt !== "" && !txt.match(/写给红尘男女/)) {
		$(e).replaceWith("<h2>" + txt + "</h2>")
	    }
	});
	
    }
    // $(title).prepend(mpvoice);
    let imgs = "";
    $("img", main).each((i, img) => {
        // console.log($.xml(img));
        const src = $(img).attr("data-src");
        // console.log(src);
        let ext = src && src.match(/wx_fmt=([^&]*)/)?.[0] || "";
        ext = ext.replace(/wx_fmt=([^&]*)/, "$1").trim();
        if (ext === "png") {
	    //console.log($.xml(img));
	    // console.log(`${ext} ..`)
            // $(img).empty();
	    const parent = $(img).parent().parent();
	    $(parent).replaceWith("<h2>" + $(parent).text() + "</h2>");
        } else {
	    // console.log(ext)
            const fname = chapter + "-" + String(i) + "." + ext;
            imgs += fname + " % " + src + "\n";
            $(img).replaceWith("<img src='./img/" + fname + "'>");
        }
    });
    let image = imgs.split("\n", -1);
    // console.log(image.length);
    assert(image.length >= 2);
    // a删除第一和最后一个元素。
    // image.shift();
    // let img: string | undefined;
    // do {
    //     img = image.pop();
    // } while (img !== undefined && img === "");
    imgs = image.join("\n") + "\n";
    fs.appendFileSync("img-urls", imgs);

    // const main_td = $("body>div>table>tbody>tr>td").eq(1);
    // main_td.children("table").each((i, e) => { $(e).remove(); });
    // main_td.children("script, hr").each((i, e) => { $(e).remove(); });
    // main_td.children("span, a").each((i, e) => { $(e).remove(); });
    // const td = $(main_td).html();
    console.log($(main).html());
    // console.log("135 editor=", $("section[data-tools='135编辑器']").toArray().length);
}
