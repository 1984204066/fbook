import jsdom from "jsdom";
import jQuery from "jquery";
const { JSDOM } = jsdom;
// https://stackoverflow.com/questions/21358015/error-jquery-requires-a-window-with-a-document
const data = "<html><body><div id='notediv'>haha</div></body></html>";
const dom = new JSDOM(data);
const $ = jQuery(dom.window);

var note_array = new Array();

export function mynote(x) {
    const num = Number(x);
    const filenum = Math.floor(num / 100);
    // console.log("filenum", filenum);
    if (note_array[filenum]) {
        return note_array[filenum];
    }
    const str = "../note/note" + filenum + ".htm #div" + x;
    const some_data = $("#notediv");
    console.log(str, some_data.text());
    const url = "www.agama.buddhason.org/SN/" + str;
    $("#notediv").load(url, function (data) {
        note_array[filenum] = data; // 全部資料放在 note_array 陣列中
        console.log(note_array[filenum]);
        add_agama_link("#notediv");
    });
    return note_array[filenum];
    // return "none";
}

export async function evalMynote(page, aref, x) {
    const note = await page.evaluate(
        (a, note_id) => {
            const the_note = window.mynote(note_id);
            console.log("note:", the_note);
            // note(a, note_id);
            return "OK";
            return Promise.resolve("OK");
        },
        aref,
        x,
    );
    return note;
}

export async function evalMynote2(page, aid, x) {
    const note = await page.evaluate(
        (a, note_id) => {
            // const myHash = await window.mynote(note_id);
            note(a, x);
            // console.log(`md5 of ${note_id} is ${myHash}`);
        },
        aref,
        x,
    );
    console.log(note);
    return note;
}

export async function callNote(page, x) {
    const note = await page.evaluate((notex) => {
        // const myHash = await window.mynote(note_id);
        const note = note2(notex);
        console.log(`${notex} is ${note}`);
    }, x);
    // console.log(note);
    return note;
}
