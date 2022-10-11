import type {JSHandle, Element, Page} from "puppeteer";

export declare function mynote(x:string):string;
export declare function evalMynote(page: Page, aref: JSHandle<Element>|null, x:string):Promise<string>;
export declare function callNote(page: Page, x:string):string;
