use chinese_number::{
    ChineseNumber, ChineseNumberCountMethod, ChineseNumberToNumber, ChineseVariant,
};
use nipper::Document;
use regex::Regex;
use std::{fs::*, io::Write, str::Chars};
use walkdir::WalkDir;

fn main() {
    for entry in WalkDir::new("./html-files/").into_iter().filter_map(|e| {
        if !e.as_ref().unwrap().path().is_file() {
            None
        } else {
            e.ok()
        }
    }) {
        // let entry = entry.unwrap();
        let html = read_to_string(entry.path()).unwrap();
        let document = Document::from(&html);
        let title = document.select("h1.rich_media_title").text().to_string();
        println!("title {}", title);
        let re = Regex::new(r"我的禅修经历（(?P<no>.*)）").unwrap();
        let num: i8;
        if let Some(caps) = re.captures(&title) {
            let 几 = caps.name("no").unwrap().as_str().to_string();
            num = 几
                .as_str()
                .parse_chinese_number(ChineseNumberCountMethod::TenThousand)
                .unwrap();
        } else {
            num = 18;
        }

        let ofile = num.to_string() + ".org";
        // let ofile = "0.org";
        // let mut urls = std::fs::File::create("./imgs.urls").unwrap();
        let mut urls = OpenOptions::new().append(true).open("./imgs.urls").unwrap();
        let mut art = OpenOptions::new()
            .append(true)
            .open(String::from("./org-files/") + &ofile)
            .expect("cannot open file");
        for (i, img) in document
            .select("p img.rich_pages.wxw-img")
            .iter()
            .enumerate()
        {
            let http = img.attr("data-src");
            let http = format!("{}\n\n", http.unwrap());
            let re = regex::Regex::new(".*wx_fmt=(.*)\n\n").unwrap();
            let fmt = re.replace_all(&http, "$1");
            let img_file = format!("{}-{}.{}", num, i, fmt);
            // let item = format!("{} % {}\n", img_file, &http.replace("\n", ""));
            // urls.write_all(item.as_bytes());
            let item = format!("file:./imgs/{}\n", img_file);

            art.write_all(item.as_bytes());
        }
    }
}
