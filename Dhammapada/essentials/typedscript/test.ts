import { AnyNode, BasicAcceptedElems, CheerioAPI, contains, load } from "cheerio";

// const html = "<div><span>1</span><span>2</span><p>3</p><span>4</span></div>";
const html = "<div><section>111</section><p>222</p></div>";
const $ = load(html);
const sec = $('section');
const p = $(sec).next();
console.log($(sec).html());
console.log($.xml(p));
const n = $('span').siblings('span').toArray().length;
console.log(n);

let src="wx_fmt=jpeg";
const s2 = src.replace(/wx_fmt=(.*)/, "$1");
console.log(s2);
