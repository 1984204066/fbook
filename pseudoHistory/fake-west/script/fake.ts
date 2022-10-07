import { AnyNode, BasicAcceptedElems, CheerioAPI, load } from "cheerio";
import * as fs from "fs";
import { appendImage, getImgs, levelUp } from "./lib.js";
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
    $("h1, h2, h3, h4, h5, h6").map((i, e) => {
        let h = "";
        if ($(e).is("h1")) h = "h1";
        if ($(e).is("h2")) h = "h2";
        if ($(e).is("h3")) h = "h3";
        if ($(e).is("h4")) h = "h4";
        if ($(e).is("h5")) h = "h5";
        if ($(e).is("h6")) h = "h6";
	h = "(" + h + ")>" + $(e).text() + "<("  +h  + ")"
        $(e).replaceWith("<p>" + h + "</p>");
        // console.log($(e).html());
    });
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

function markEmBold($: CheerioAPI, main: BasicAcceptedElems<AnyNode>) {
    for (var lable of ["strong", "em", "sup", "sub"]) {
        $(lable, main).map((j, e) => {
            if ($(e).find("img").length > 0) { // 如果包含img,那么取缔 strong/em.
                $(e).replaceWith("<span>" + $(e).html() + "</span>");
            } else {
                let m = "";
                if (lable === "strong") {
                    m = "S";
                } else if (lable === "em") {
                    m = "E";
                } else if (lable === "sup") {
		    m = "P"
                } else if (lable === "sub") {
		    m = "B"
		}
                if (m !== "") {
		    m = "(" + m + ")";
                    // $(e).replaceWith("<span>" + m + "👉" + $(e).html() + "👈" + m + "</span>");
                    $(e).replaceWith("<span>" + m + ">" + $(e).html() + "<" + m + "</span>");
                }
            }
            // console.log($(e).html());
        });
    }
}
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
