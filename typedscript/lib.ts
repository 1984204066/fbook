import { CheerioAPI, load, BasicAcceptedElems, AnyNode } from "cheerio";
import * as fs from "fs";
export function getMP3($:CheerioAPI, main:BasicAcceptedElems<AnyNode>, num:string) {
    let mp3 = "";
    const voc_uri = "https://res.wx.qq.com/voice/getvoice?mediaid=";
    // const mpvoc = $("embed", main);
    $("mpvoice", main).each((i, voc) => {
        const addr = voc_uri + $(voc).attr("voice_encode_fileid");
        const fname = num + "-" + String(i);
        mp3 += fname + " % " + addr + "\n";
        $(voc).replaceWith("<embed src='./mp3/" + fname + ".mp3' width='530px' height='80px' />");
    });
    if (mp3 !== "") {
        fs.appendFileSync("voice-urls", mp3);
    }
    return mp3;
}

export function getImgs($:CheerioAPI, main:BasicAcceptedElems<AnyNode>, num:string) {
    let imgs = "";
    $("img", main).each((i, img) => {
        // console.log($.xml(img));
        const src = $(img).attr("data-src");
        // console.log(src);
        let ext = src && src.match(/wx_fmt=([^&]*)/)?.[0] || "";
        ext = ext.replace(/wx_fmt=([^&]*)/, "$1");
        const fname = num + "-" + String(i) + "." + ext;
        imgs += fname + " % " + src + "\n";
        $(img).replaceWith("<img src='./img/" + fname + "'>");
    });
    return imgs;
}

export function appendImage(imgs:string, trim_head = 0, trim_tail = 0) {
    let image = imgs.split("\n", -1);
    // console.log(image);
    // assert(image.length >= 2);
    // console.log(trim_head);
    // a删除第一和最后一个元素。
    while (trim_head > 0) {
        image.shift();
        trim_head--;
    }
    let img;
    while (trim_tail > 0) {
        do {
            img = image.pop();
        } while (img !== undefined && img === "" && image.length > 0);
        trim_tail--;
    }
    imgs = image.join("\n") + "\n";
    fs.appendFileSync("img-urls", imgs);
    return imgs;
}

export function markH6($:CheerioAPI) {
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
}


export function markEmBold($: CheerioAPI, main: BasicAcceptedElems<AnyNode>) {
    for (var lable of ["strong", "em", "sup", "sub"]) {
        $(lable, main).map((_j, e) => {
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

// not work.
export function levelUp($:CheerioAPI, main: BasicAcceptedElems<AnyNode>, elem: BasicAcceptedElems<AnyNode>) {
    console.log("main:", $(main).html());
    let parent = $(elem).parent();
    console.log("elem:", $.xml(elem));
    console.log($.xml(parent));
    let i=0;

    while (! $(parent).is(main)) {
	console.log($.xml(parent));
        if ($(parent).is('strong') || $(parent).is('em') ) {
	    console.log("ok, strong or em")
            const newp=$(parent).replaceWith("<span><p>" + $(parent).html() + "</p></span>");
	    console.log("newp: ", $.xml(newp));
	    console.log(`parent xml: ${$.xml(parent)}, html: ${$(parent).html()}`);
        }
	console.log("after, ", $.xml(parent));
        elem=parent;
        parent=$(parent).parent();
	if (i > 3) {break;}
	i++;
    }
    console.log($(elem).html());
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
