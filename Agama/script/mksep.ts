import * as fs from "fs";

const pali = fs.readFileSync("pali.org").toString().trim().split("\n\n", -1);
const nikaya = fs.readFileSync("nikaya.org").toString().trim().split("\n\n", -1);
// console.log(pali)
// if (pali.length !== nikaya.length) {
//     console.log("warning ", pali.length, nikaya.length, "different")
// }
const max = pali.length > nikaya.length ? pali.length: nikaya.length;
// console.log(max)
function td(e:string):string { return !e? "" : `<td>\n\n${e}\n\n</td>`;}
let table = ""
for (let i = 0; i < max ; i++) {
    const tr = "<tr>" + td(pali[i]) + "\n" + td(nikaya[i]) + "</tr>\n";
    table += tr;
}
table = "<table><tbody>" + table + "</tbody></table>";
// table = "<table><tbody><tr><td style='width:50%'></td><td></td></tr>" + table + "</tbody></table>";
console.log(table);
// type Part = [string,number]

// function onePart(lines: string[], p: Part):Part {
//     let end:number = p[1]!;
//     const part = lines.slice(end, pali.length);
//     for (let line of part) {
//         end++;
//         if (line.match(/^[ \n]*$/)) break;
// 	if (line === "" || line === "\n") break;
//     }
//     const text = part.slice(0, end).join("\n"); // 不包括end.
//     return [text, end];
// }

// let p1: Part = ["", 0];
// let p2 : Part = ["", 0];
// do {
//     // [text, end] = onePart(pali.slice(end, pali.length), end);
//     p1 = onePart(pali, p1);
//     console.log(p1)
//     // p2 = onePart(nikaya, p2);
//     // console.log(`<tr><td>${p1[0]}</td>\n<td>${p2[0]}</td></tr>\n`);
// }while (p1[1] < pali.length)

