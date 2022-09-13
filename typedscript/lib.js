import * as fs from "fs";
export function getMP3($, main, num) {
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
export function getImgs($, main, num) {
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
export function appendImage(imgs, trim_head = 0, trim_tail = 0) {
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
function upOne($, elem, main) {
    const parent = $(elem).parent();
    if ($(parent).is(main)) {
        return [elem, 0];
    }
    if ($(parent).text().trim() === $(elem).text().trim()) {
        $(parent).replaceWith(elem)
        return [parent, 1];
    }
    return [elem, -1];
}
function levelUp($, elem, lable) {
    const main = $(lable);
        let [parent, ret] = upOne($, elem, main);
        if (ret === 1) {
            return levelUp($, parent, lable);
        }
    return [parent, ret];
}
