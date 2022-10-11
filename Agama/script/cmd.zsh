#!/bin/zsh

while {read url} {node agama.js $url} < urls
npx -p typescript tsc ./mynote.js --declaration --allowJs --emitDeclarationOnly --outDir types


