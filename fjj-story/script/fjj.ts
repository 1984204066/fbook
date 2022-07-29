import { AnyNode, BasicAcceptedElems, CheerioAPI, contains, load } from "cheerio";
import * as fs from "fs";
import iconv from "iconv-lite";
let last_word = "";
let fname = process.argv[2];
// let fname = "../html/continue/fjj061004/fjj-01.htm";
if (fs.existsSync(fname)) {
    const v = fs.readFileSync(fname);
    const html = iconv.decode(v, "gbk");
    // const content = iconv.encode(body, 'utf8');
    // console.log(html);
    const $ = load(html);
    const glass = [
        ".font6",
        ".font8Copy4",
        ".h21",
        ".h22",
        ".h23",
        ".h21Copy",
        ".h22Copy",
        ".h21copy1",
        ".h23copy",
        ".Songti",
        ".font7shadow",
        ".font8copy5",
    ];
    // console.log(glass);
    // glass.map((s) => $(s).remove());

    $("script").map((_i, it) => $(it).remove());
    $("style").map((_i, it) => $(it).remove());
    $("meta").map((_i, it) => $(it).remove());

    $("#Layer6").remove();
    $("#Layer5").remove();
    $("#Layer2").remove();

    // $("table").eq(0).remove();
    // $("table").eq(0).remove();
    const main_tbl = $("table").eq(2);
    main_tbl.siblings().remove();
    // $("table", main_tbl).eq(0).remove(); //dirs
    // 如果用这个提取的话，得到的是目录table的td.因为目录table是main_tbl里的第一个sub-table.
    // const tds = $('table>tbody>tr>td', main_tbl).eq(3);
    // td[0] "空白"
    // td[1] "目录"
    // td[2] "---"
    const main_td = $("body>table>tbody>tr>td").eq(3);
    // main_td.map((i, td) => {
    // 	console.error(i);
    // 	console.error($(td).text());
    // })

    main_td.siblings().remove();
    // last 是 "下一页"
    main_td.children("table").last().remove();
    // tbl[0] "下一页"
    // tbl[1] "讲义[n*]"
    let content_tbl = $(">table", main_td).eq(2); // 只是一个元素iter.
    // content_tbl.prevAll().map((_i, tbl) => {console.error(_i);$(tbl).remove()});
    content_tbl.prevAll().remove(); // 可能只是从链表中断开。
    // console.error(content_tbl.html());
    // 这里虽然remove了，但是不影响content_tbl,
    // 然而replaceWith不能再用这个content_tbl，需要重新提取，奇怪。可能是bug.
    // content_tbl = $(">table", main_td);
    // console.error(content_tbl.html()); // 这里显示只有一个。
    // 直接输出md文件，不用replaceWith.
    // main_tbl.replaceWith(content_tbl); // 这里是全部table，可能content_tbl保持了链表关系。
    // console.log($(content_tbl).toArray().length);
    const td = handleTD($, main_td); // 如果用了replaceWith，main_td会失效，返回空。
    // const td = handleTbl($, content_tbl); // 3 elements Table,Poem-Img,Story
    console.log(td.trim());
}

function handleTD($: CheerioAPI, td: BasicAcceptedElems<AnyNode>): string {
    // const child = $(td).children().length;
    // console.error(child);
    let str = "";
    $(td)
        .children()
        .map((i, e) => {
            // console.log($(e).html());
            if ($(e).is("table")) {
                // console.error("is table");
                str += handleTbl($, e);
            } else {
                // console.error("is story");
                const story = handleStory($, e);
                str += story;
                // console.error(str);
            }
        });
    return str;
}

function handleTbl($: CheerioAPI, tbl: BasicAcceptedElems<AnyNode>): string {
    // console.log($(tbl).html());
    let str = "";
    $(">tbody>tr", tbl).map((_i, tr) => {
        // console.log(_i);
        // console.log($(tr).html());
        const td = $(">td", tr);
        const ntd = td.toArray().length;
        if (ntd > 1) {
            str += handlePoemImgRow($, tr);
        } else {
            str += handleTD($, td);
        }
    });
    return str;
}

function handlePoemImgRow(
    $: CheerioAPI,
    tr: BasicAcceptedElems<AnyNode>,
): string {
    if ($(tr).find("img").length <= 0) {
        console.error("should have img, but noooooooo!");
        console.error($(tr).html());
        return "";
    }
    // console.log($(tr).html());
    let poem_img = "";
    $("td", tr).each((_i, td) => {
        poem_img += handleImgPoem($, td);
    });
    const str = '<div class="e2">\n' + poem_img + "</div>\n\n";
    return str;
}

function handleImgPoem(
    $: CheerioAPI,
    elem: BasicAcceptedElems<AnyNode>,
): string {
    let img_poem = "";
    if ($(elem).find("img").length > 0) {
        $("img", elem).each((_i, img) => {
            let src = $(img).attr("src");
            const re = /..\/fotuodehua030806\/images\//;
            if (src && src.match(re)) {
                src = src && src.replace(re, "img2/");
                $(img).attr("src", src);
            }
            const word = ' alt="' + last_word + '"/>';
            // const word = iconv.encode(last_word, 'utf8');
            const imgstr = $.xml(img);
            // $(img).attr("alt", word);
            img_poem += imgstr.replace(/\/>/, word) + "\n";
        });
    } else {
        // poem
        // const p = stripFont3($(elem).html());
        let p = stripFont($(elem).html()).trim();
        p = p.replace(/　+/g, "").replace(/\s+/g, " ").replace(/<br>/g, "<br>\n");
        const $2 = load(p);
        const div = $2("div").html();
        // console.error(div);
        p = div === null ? p : div;
        // console.error($2.root().html());
        // if ($2('div').toArray().length > 0) {
        //     console.error("root is div")
        // }
        img_poem += "<div>\n" + p + "\n</div>\n"; //重复多次替换
    }
    return img_poem;
}

function handleStory($: CheerioAPI, elem: BasicAcceptedElems<AnyNode>): string {
    let str = "";
    const nlen = $(elem).find("p").length;
    // console.error($(elem).html());
    // console.error(nlen);
    if (nlen > 0) {
        // console.error("yes have p");
        // console.error($(elem).html());
        $(elem)
            .children("p")
            .map((_i, p) => {
                str += handleLine($(p).text());
            });
    } else {
        // console.error('no ppppppp text:');
        // console.error($(elem).text());
        str += handleLine($(elem).text());
    }
    saveLastWords(str);
    return str;
}

function saveLastWords(words: string) {
    let last = words.trim().replace(/\s+$/m, "").split("\n", -1).slice(-1)[0];
    // console.error("----------")
    // console.error(last);
    // console.error("^^^^^^^^^^")
    function last_re(last: string) {
        const re = /\S+?\s+?\S+?$/;
        // const last = re.test(words);
        // console.error(last.match(re));
        const lw = last.match(re)?.[0];
        return lw === undefined ? "" : lw;
    }

    function last2(last: string) {
        const a = last.split(" ");

        if (a.length > 0) {
            if (a.length > 3) {
                last = a.slice(-2).join(" ");
            } else {
                last = a.join(" ");
            }
        }
        return last;
    }
    // let n = 0;
    // let a = [last2(last).trim(), last_re(last).trim()];
    // a.forEach((word, i) => word.length > n ? (n = i) : i);
    // last = a[n];
    last = last_re(last);
    if (last.length > 0) {
        last_word = last;
    }
    // last_word = last.replace(/\s+/g, " ").replace(/\s+$/, "");
    // console.error(`${last_word.length} -- ${last_word}`);
    if (last_word.length > 26) { // too long
        last_word = "";
    }
}

function handleLine(text: string) {
    let line = text.replace(/法句经要义|陈燕珠编述/g, "").trim();
    line = line.replace(/　/g, "").replace(/\s+/g, " ").trim() + "\n\n";
    // console.error(line);
    return line;
}

function stripFont3(html: string | null) {
    if (html === null) {
        return "";
    }
    const $ = load(html);
    while ($("font").toArray().length > 0) {
        const font = $("font").contents();
        // console.error($(font).html()); // return null?
        $("font").replaceWith(font);
    }
    return $.html();
}

function stripFont2($: CheerioAPI, elem: BasicAcceptedElems<AnyNode>): string {
    var str = "";
    // console.log("hahaahahha");
    // console.error($(elem).html());
    if ($(elem).contents().length === 0) {
        if ($(elem).is("font")) {
            return $(elem).text();
        }
        return $.xml(elem);
    }
    $(elem)
        .contents()
        .map((_i, e) => {
            str += stripFont2($, e);
        });
    console.error(`---${str}---`);
    return str;
}

function stripFont(font: string | null) {
    if (font === null) {
        return "";
    }
    const re = /([\S\s]*)<font[^>]*>([\S\s]*)<\/font>([\S\s]*)/;
    let str = font;
    let m;
    while ((m = re.exec(str)) !== null) {
        // console.error(str);
        str = "";
        m.forEach((match, i) => {
            // console.error(`found match group ${i}: ${match}\n`);
            i > 0 && (str += match);
        });
    }
    return str;
}
