const process = require("node:process");
const mkdirp = require("mkdirp");
const fs = require("fs");
const luamin = require("luamin");

const dirBasePath = process.argv[2];
const inputFilePath = process.argv[3];
const outputFilePath = process.argv[4];

mkdirp.sync(`build/src/${dirBasePath}`);
const fileContent = fs.readFileSync(inputFilePath, {encoding: "utf8"});
const minifiedFileContent = luamin.minify(fileContent);

fs.writeFileSync(outputFilePath, minifiedFileContent);
