#![feature(iter_intersperse)]

use chinese_number::{
    ChineseNumber, ChineseNumberCountMethod, ChineseNumberToNumber, ChineseVariant,
};
use nipper::{Document, Selection};
use regex::Regex;
use reqwest::blocking::Response;
use std::io::{BufRead, BufReader};

use std::{fs::*, io::Write, str::Chars};

fn main() {
    let filename = "../urls";
    // Open the file in read-only mode (ignoring errors).
    let file = File::open(filename).unwrap();
    let reader = BufReader::new(file);

    // Read the file line by line using the lines() iterator from std::io::BufRead.
    let mut file = File::create("../urls.voice").unwrap();
    for (index, line) in reader.lines().enumerate() {
        let line = line.unwrap(); // Ignore errors.
                                  // Show the line and its number.
        let d: Vec<_> = line.split('%').collect();
        let title = d[0];
        let url = d[1];
        println!("{}", title);
        let re = regex::Regex::new(r"第(.*)章(\d*)：").unwrap();
        if let Some(cap) = re.captures(&title) {
            let mut num = 0i8;
            let mut chapter = 1i8;
            if let Some(几) = cap.get(1) {
                let 几 = 几.as_str();
                num = 几
                    .parse_chinese_number(ChineseNumberCountMethod::TenThousand)
                    .unwrap();
            }
            if let Some(几) = cap.get(2) {
                let 几 = 几.as_str();
                if !几.is_empty() {
                    chapter = 几.parse::<i8>().unwrap();
                }
            }
            let mp3 = format!("2.{}-{}", num, chapter);
            println!("{}", mp3);
            let (v, content) = get_vid(url);
            write_voice_url(&mut file, mp3, &v, &content);
        }
        // println!("{}. {}", index + 1, line);
    }
}

fn write_voice_url(file: &mut File, mp3: String, v: &Vec<String>, content: &str) {
    let fhtm = format!("../part-html/{}", mp3);
    let mut f = File::create(fhtm).unwrap();
    f.write_all(content.as_bytes());
    
    if v.len() == 1 {
        return write_it(file, mp3, &v[0]);
    }
    for (i, it) in v.iter().enumerate() {
        let mp3 = format!("{}.{}", mp3, i);
        write_it(file, mp3, it);
    }
}

fn write_it(file: &mut File, mp3: String, vid: &str) {
    let buf = format!(
        "{}.mp3 % https://res.wx.qq.com/voice/getvoice?mediaid={}\n",
        mp3, vid
    );
    file.write_all(buf.as_bytes());
}

fn get_vid(url: &str) -> (Vec<String>, String) {
    loop {
        match reqwest::blocking::get(url) {
            Err(err) => {
                print!("{:#?}", err);
                continue;
            }
            Ok(resq) => {
                return nipper(resq);
            }
        }
    }
}

fn nipper(resq: Response) -> (Vec<String>, String) {
    let html = resq.text().unwrap();
    let document = Document::from(&html);
    let voice = document.select("mpvoice");
    let voice_id: Vec<_> = voice
        .iter()
        .map(|v| {
            let vid = v.attr("voice_encode_fileid").unwrap();
            // println!("{:#?}", html);
            vid.to_string()
        })
        .collect(); // intersperse(" % ".to_string()).
    let artical = document.select("div#js_content.rich_media_content");
    // remove_rest(&mut artical);
    // println!("{}", &artical.html());
    (voice_id, artical.html().to_string())
}

fn remove_rest(artical: &mut Selection) {
    // for item in section.iter() {
    // 	println!("{}", item.html());
    // }
    let section = artical.select("span");
    for mut item in section.iter() {
        if item.text().find("连载进行中").is_some() {
            let artid = artical.get(0).unwrap().id;
            while item.get(0).unwrap().id != artid {
                println!("{:#?} vs. {:#?}", artid, item.get(0).unwrap().id);
                item = item.parent();
            }
            // let v :Vec<_> = item.next_sibling().iter().collect();
            // v.iter().for_each(| i| Selection::remove(&i));
            loop {
                let mut it = item.next_sibling();
                println!("~~~{:#?}~~~", item);
                item.remove();
                !it.exists() && break;
                item = it;
            }
            // for mut it in item.next_sibling().iter() {
            // 	let n = it.next_sibling();
            //     it.remove();
            // }
            break;
        }
    }
}

#[test]
fn test_http() {
    let url = r"https://mp.weixin.qq.com/s?__biz=Mzk0MjE3MDYwMA==&mid=2247494595&idx=1&sn=35f5b457328963754dde4e68d9b75640&chksm=c2c5e344f5b26a529d58a3f4b6a4c01ed4191aacda1d5400784a2a1592dcac00fe5d2df2baae&scene=21#wechat_redirect";
    let v = get_vid(url);
    println!("{:#?}", v);
}
