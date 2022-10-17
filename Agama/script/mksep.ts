export function sepCaption(sutra:string) : string[] {
    const n = sutra.indexOf('\n') + 1;
    console.log("first enter at:", n)
    let line = sutra.slice(0, n);
    // [相應部22相應52經/歡喜的滅盡經第二]{.sutra_name}(蘊相應/蘊篇/修多羅)(莊春江譯)\
    sutra = sutra.slice(n)
    line = line.replace(/{.*}/,"");
    line = line.replace(/\(莊春江譯.*/, "");
    line = line.replace(/\//g, ".");
    line = line.replace(/[\]\[]/g, "");
    line = line.replace(/\\/g,"");
    console.log(line);
    
    return new Array(line, sutra);
}
// console.log(nikaya)
// if (pali.length !== nikaya.length) {
//     console.log("warning ", pali.length, nikaya.length, "different")
// }

function td(e:string):string {return !e? "": `<td>\n\n${e}\n\n</td>`;}

export function enlarge(c_b:string[]) :string[] {
    let anew = new Array<string>();
    console.log(`old len: ${c_b.length}`);
    c_b.forEach((e:string)=>{
	const a = sepCaption(e);
	anew = anew.concat(a)
	// console.log(`new len ${anew.length}, text:${anew}`)
    });
    return anew;
}

export function trs(pali:string[], nikaya:string[]) {
    pali = enlarge(pali);
    nikaya = enlarge(nikaya)
    
    const max = pali.length > nikaya.length ? pali.length: nikaya.length;
    console.log(max)
    let table = ""
    for (let i = 0; i < max ; i++) {
	const tr = "<tr>" + td(pali[i]) + "\n" + td(nikaya[i]) + "</tr>\n";
	table += tr;
    }
    table = "<table><tbody>" + table + "</tbody></table>";
    // table = "<table><tbody><tr><td style='width:50%'></td><td></td></tr>" + table + "</tbody></table>";
    // console.log(table);
    return table;
}

// type Part = [string,number]
