import { load } from "cheerio";
import * as fs from "fs";
import {execaCommand, execaNode, execaCommandSync} from 'execa';

let already = new Set();
let notes = new Set<string>();
let gnotes = new Map();

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

function changeAHref(html: string | null, div_class: string) {
    const $ = load(html ? html : "");
    const aref = $("a[onmouseover]").map((i, a) => {
        const over = $(a).attr("onmouseover") || "note(this,0);";
        const at = over?.indexOf("note") >= 0 ? "G" : "L";
        const s = over?.replace(/[^0-9]/g, "");
        let aid = at + s;
        // if (at === "G") aid = at + s;
        // else aid = at + fid + "." + s;
        if (already.has(aid) || notes.has(aid)) {
            $(a).replaceWith($(a).text());
        } else {
            const fn = $(a).text() + "[fn:" + aid + "]";
            $(a).replaceWith(fn);
	    switch (at) {
		case 'G': already.add(aid); // pass through
		case 'L': notes.add(aid); // new notes for this page.
	    }
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
    const html = fs.readFileSync(fname).toString();
    let $ = load(html);
    // const fid = fname.substring(fname.lastIndexOf("/") + 3, fname.lastIndexOf("."));
    // console.log(fid);
    let lnotes = new Map();
    function localNotes() {
	$('span').map((i,e)=>{
	    const id = $(e).attr('id');
	    if (!id) return;
	    const no= id?.substring(4); //notex
	    lnotes.set('L' + no, $(e).text())
	});
	console.log(lnotes.size)
    }

    localNotes();
    for (let div of ["agama", "pali", "nikaya"]) {
	const s = "div." + div;
	// changeAHref($(s).html(), s);
	let html : string | null = $(s).html();
	if (!html && div === 'agama') {
	    html = $('tr:nth-child(2) > td').html();
	}
	changeAHref(html, s);
	await execaCommand(`./transition.zsh ${s}`, {shell: '/usr/bin/zsh'});
	// gen agama.org pali.org, nikaya.org for mksep.js.
    }
    for (let div of ["agama", "pali", "nikaya"]) {
	execaCommandSync(`cp ${div}.org X/${div}/${sa}.org`, {shell: '/usr/bin/zsh'});
    }
    const res = await execaNode('./mksep.js')
    const agama = fs.readFileSync('agama.org').toString().trim();
    // let div2 = "<div class='parent'><div class='div2'><div class='left'>\n\n" + agama +"\n\n</div><div class='right'>\n\n" + res.stdout + "</div></div></div>\n\n-----\n\n";
    let div2 = "<div class='miscAgama'>\n\n" + agama +"\n\n" + res.stdout + "</div>\n\n-----\n\n";
    let footnotes= "<div class='note'>\n\n";
    for (let key of notes) {
	let note = '缺失(undefined)'
	switch (key.charAt(0)) {
	    case 'G': note = gnotes.get(key);break;
	    case 'L': note = lnotes.get(key);break;
	}
	if (!note) note = '缺失';
	footnotes += `[fn:${key}] ${note}\n\n`
    }
    div2 += footnotes + '\n\n</div>\n\n';
    notes.clear();
    fs.writeFileSync("main.org", div2);
    execaCommandSync('./br.zsh')
    execaCommandSync(`cp main.org ../org/${sa}.org; cp main.md ../src/${sa}.md`, {shell: '/usr/bin/zsh'});
}
