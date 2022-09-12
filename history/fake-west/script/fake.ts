import { load } from "cheerio";
import * as fs from "fs";
import {getImgs, appendImage} from "./lib.js";

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
    // $('h1').map((i,e)=>{
    // 	$(e).replaceWith("<p>" + $(e).text() + "</p>");
    // });
    let imgs = getImgs($, main, chapter);
    const imgn = $('img', main).length;
    // const content = $(main).children().eq(2);
    // // console.log($(main).children().length, $(content).text());
    // $(content).prevAll().map((i, e) => {
    // 	// console.log(i, $(e).text());
    //     $(e).remove();
    // });
    // const trim_head = imgn - $('img', main).length;
    // appendImage(imgs, trim_head, 1);
    appendImage(imgs, 0, 0);
    // const last = $('img', main).eq(-1)
    // $(last).remove();
    // console.log($.xml(last));
    // main chanaged, so reload it.
    main = $("div#js_content");
    console.log($(main).html());
}

