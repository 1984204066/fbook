import { AnyNode, BasicAcceptedElems, CheerioAPI, load } from "cheerio";
import * as fs from "fs";
import { appendImage, getImgs, markH6, levelUp } from "./lib.js";
// import {getImgs, appendImage, levelUp} from "../../../typedscript/lib.js";

let fname = process.argv[2];
const chapter = process.argv[3];
// let fname = "../html/continue/fjj061004/fjj-01.htm";
if (fs.existsSync(fname)) {
    const v = fs.readFileSync(fname);
    const html = v;

    const $ = load(html);
    let main = $("div#js_content");

    const title = $("h1").eq(0).text();
    console.error(title);
    markH6($);
    let imgs = getImgs($, main, chapter);
    const imgn = $("img", main).length;
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
    markEmBold($, main);
    // const last = $('img', main).eq(-1)
    // $(last).remove();
    // console.log($.xml(last));
    // main chanaged, so reload it.
    // main = $("div#js_content");
    console.log($(main).html());
}

// modMark($: CheerioAPI, main: BasicAcceptedElems<AnyNode>, mark: string) {
// }
//function upImage($: CheerioAPI, elem: BasicAcceptedElems<Node>) {
function upImage($: CheerioAPI) {
    const lable = "div#js_content";
    const tmp = $(lable);
    console.log("tmp:", $(tmp).html());
    const main = $("div#js_content");
    console.log("upImage", $.xml(main));
    $("img", main).map((j, e) => {
        // levelUp($, main, e)
        let i = 0;
        let parent = $(e).parent();

        while (!$(parent).is(main)) {
            console.log($.xml(parent));
            if ($(parent).is("strong") || $(parent).is("em")) {
                console.log("ok, strong or em");
                const newp = $(parent).replaceWith("<span><p>" + $(parent).html() + "</p></span>");
                console.log("newp: ", $.xml(newp));
                console.log(`parent xml: ${$.xml(parent)}, html: ${$(parent).html()}`);
            }
            console.log("after, ", $.xml(parent));
            //e=parent;
            parent = $(parent).parent();
            if (i > 3) break;
            i++;
        }
        console.log($(e).html());
    });
}
