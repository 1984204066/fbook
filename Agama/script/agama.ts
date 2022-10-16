import { load } from "cheerio";
import * as fs from "fs";
import {execaCommand, execaNode, execaCommandSync} from 'execa';
import {trs} from './mksep.js';

let already = new Set();
let notes = new Set<string>(); // 页映射。一卷包括多页。
let gnotes = new Map();
let glMapNo = new Map(); // 卷映射
let No = 1;

function loadNotes() {
    const html = fs.readFileSync("../html/notes.html").toString();
    const $= load(html)
    $('div').map((i,e)=>{
	const id = $(e).attr('id');
	if (!id) return;
	const no = id?.substring(3); //divx
	if (!no) console.log($(e).attr())
	// console.log(no)
	gnotes.set('G' + no, $(e).text())
    });
    console.log(gnotes.size)
}

function changeAHref(fid: string, html: string | null, div_class: string) {
    const $ = load(html ? html : "");
    const aref = $("a[onmouseover]").map((i, a) => {
        const over = $(a).attr("onmouseover") || "note(this,0);";
        const at = over?.indexOf("note") >= 0 ? "G" : "L";
        const s = over?.replace(/[^0-9]/g, "");
        let aid = at + s;
        // if (at === "G") aid = at + s;
        // else aid = at + fid + "." + s;
	if (at === 'L') aid = at + fid + "." + s;
        if (already.has(aid) || notes.has(aid)) {
            $(a).replaceWith($(a).text());
        } else {
            const fn = $(a).text() + `#${No}`//`[^${No}]`;
            // const fn = $(a).text() + "[fn:" + aid + "]";
            $(a).replaceWith(fn);
	    switch (at) {
		case 'G': already.add(aid); // pass through
		case 'L': notes.add(aid); // new notes for this page.
	    }
	    glMapNo.set(aid, No);
	    No++;
            // at === "G" && already.add(aid);	    
        }
        return aid;
    }).toArray();
    const fname = div_class;
    // const content = $.xml(div_class);
    const content = $.html();
    // console.log(content);
    fs.writeFileSync(fname, content);
}

// main
loadNotes();
// total 1362
for (let f = 1; f<=1; f++) { 
    // const url = "http://www.agama.buddhason.org/SN/SN0001.htm";
    const fbase = '../html/SA/SA';
    const sa = f.toLocaleString('en',{minimumIntegerDigits:4,useGrouping:false});
    const fname = fbase + sa + ".htm";
    let html = "";
    try {
	html = fs.readFileSync(fname).toString();
    } catch(e) {
	console.error(e)
	continue;
    }
    let $ = load(html);
    const fid = fname.substring(fname.lastIndexOf("/") + 3, fname.lastIndexOf("."));
    // console.log(fid);
    let lnotes = new Map();
    function localNotes() {
	$('span').map((i,e)=>{
	    const id = $(e).attr('id');
	    if (!id) return;
	    const x = id?.substring(4); //notex
	    const no = 'L' + fid + "." + x;
	    lnotes.set(no, $(e).text())
	});
	// console.log(lnotes.size)
    }

    localNotes();
    function singleAgama(html:string|null) {
	// console.log(html)
	if (!html) return "";
	const $=load(html);
	const agama = $('span').filter((i, e)=>{
	    console.log(i,"th is:", $(e).text());
	    if ($(e).text().match(/^[ \n]*雜阿含/)) {
		console.log("selected:", i, "is", $(e).text())
		return true;
	    }
	    return false;
	}).eq(0);
	$('#south',agama).remove();
	return $(agama).html();
    }
    for (let div of ["agama", "pali", "nikaya"]) {
	const s = "div." + div;
	// changeAHref($(s).html(), s);
	let html : string | null = $(s).html();
	if (!html && div === 'agama') {
	    html = singleAgama($('tr:nth-child(2) > td').html());
	}
	changeAHref(fid, html, s);
	await execaCommand(`./transition.zsh ${s}`, {shell: '/usr/bin/zsh'});
	// gen agama.md pali.md, nikaya.md for mksep.js.
    }
    for (let div of ["agama", "pali", "nikaya"]) {
	execaCommandSync(`cp ${div}.md X/${div}/${sa}.md`, {shell: '/usr/bin/zsh'});
    }
    const agama = fs.readFileSync('agama.md').toString().trim();
    const pali = fs.readFileSync("pali.md").toString().trim().split("\n\n", -1);
    const nikaya = fs.readFileSync("nikaya.md").toString().trim().split("\n\n", -1);
    // const res = await execaNode('./mksep.js')
    // let div2 = "<div class='parent'><div class='div2'><div class='left'>\n\n" + agama +"\n\n</div><div class='right'>\n\n" + res.stdout + "</div></div></div>\n\n-----\n\n";
    const table = trs(pali, nikaya);
    let div2 = "<div class='miscAgama'>\n\n" + agama +"\n\n" + table + "</div>\n\n";
    let footnotes= "<div class='note'>\n\n";
    for (let key of notes) {
	let note = '缺失(undefined)'
	switch (key.charAt(0)) {
	    case 'G': note = gnotes.get(key);break;
	    case 'L': note = lnotes.get(key);break;
	}
	if (!note) note = '缺失';
	const no = glMapNo.get(key);
	// footnotes += `[fn:${key}] ${note}\n\n`
	footnotes += `[^${no}]: ${note}\n\n`
    }
    div2 += footnotes + '\n\n</div>\n\n';
    notes.clear();
    fs.writeFileSync("main.md", div2);
    execaCommandSync('./br.zsh')
    // execaCommandSync(`cp main.org ../org/${sa}.org; cp main.md ../src/${sa}.md`, {shell: '/usr/bin/zsh'});
    execaCommandSync(`cp main.md X/src/${sa}.md`, {shell: '/usr/bin/zsh'});
}
