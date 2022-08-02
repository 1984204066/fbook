import { load } from "cheerio";
import * as fs from "fs";
let fname = process.argv[2];
// let fname = "../html/continue/fjj061004/fjj-01.htm";
if (fs.existsSync(fname)) {
    const v = fs.readFileSync(fname);
    const html = v;
    const $ = load(html);
    const main_td = $("body>div>table>tbody>tr>td").eq(1);
    // console.log(main_td);
    main_td.children("table").each((i, e) => { $(e).remove(); });
    main_td.children("script, hr").each((i, e) => { $(e).remove(); });
    main_td.children("span, a").each((i, e) => { $(e).remove(); });
    const td = $(main_td).html();
    console.log(td);
}
