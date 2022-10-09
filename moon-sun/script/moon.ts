import { AnyNode, BasicAcceptedElems, CheerioAPI, load } from "cheerio";
import * as fs from "fs";
import { appendImage, markH6, markEmBold, levelUp } from "./lib.js";
// import {getImgs, appendImage, levelUp} from "../../../typedscript/lib.js";

let fname = process.argv[2];
const chapter = process.argv[3];
// let fname = "../html/continue/fjj061004/fjj-01.htm";
if (fs.existsSync(fname)) {
    const v = fs.readFileSync(fname);
    const html = v;

    const $ = load(html);
    let main = $("div.entry-content");

    const title = $("h1").eq(0).text();
    console.error(title);
    const related = $("#jp-relatedposts", main);
    $(related).remove();
    const toc = $("#toc_container", main);
    $(toc).remove();
    $(".seriesmeta", main).remove()
    $("fieldset", main).remove()
    markH6($);
    let imgs = getImgs($, main, chapter);
    const imgn = $("img", main).length;
    // main = $("div.entry-content");
    $("img", main).map((i, img) => {
        const src = $(img).attr("src");
	// console.log($.xml(img));
	if (src && !/\/img\//.test(src)) {
	    $(img).remove();
	}
    });
    // const content = $(main).children().eq(2);
    // // console.log($(main).children().length, $(content).text());
    // $(content).prevAll().map((i, e) => {
    // 	// console.log(i, $(e).text());
    //     $(e).remove();
    // });
    // const trim_head = imgn - $('img', main).length;
    // appendImage(imgs, trim_head, 1);
    // upImage($)
    appendImage(imgs, 0, 0);
    modAref($, main);
    markEmBold($, main);
    // const last = $('img', main).eq(-1)
    // $(last).remove();
    // console.log($.xml(last));
    // main chanaged, so reload it.
    // main = $("div#js_content");
    console.log($(main).html());
}

function getImgs($:CheerioAPI, main:BasicAcceptedElems<AnyNode>, num:string) {
    let imgs = "";
    $("img", main).each((i, img) => {
        // console.log($.xml(img));
	// console.log("\n------\n")
        const src = $(img).attr("data-lazy-src");
        let ext = "";
	if (src) {ext = src.replace(/.+\./, "")}
        // console.log(src, "|", ext);
	// console.log("\n=========\n")
        // ext = ext.replace(/wx_fmt=([^&]*)/, "$1");
        const fname = num + "-" + String(i) + "." + ext;
        imgs += fname + " % " + src + "\n";
        $(img).replaceWith("<img src='./img/" + fname + "'>");
    });
    return imgs;
}

function modAref($:CheerioAPI, main:BasicAcceptedElems<AnyNode>) {
    $("a", main).each((i, aref) => {
	const img = $("img", aref).eq(0);
	if (img) {
	    $(aref).replaceWith(img);
            // console.log($.xml(aref));
	}
    });
}
