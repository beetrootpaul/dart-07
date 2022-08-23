const process = require("node:process");
const mkdirp = require("mkdirp");
const fs = require("fs");

const dirBasePath = process.argv[2];
const inputFilePath = process.argv[3];
const outputFilePath = process.argv[4];

mkdirp.sync(`build/src/${dirBasePath}`);
const fileContent = fs.readFileSync(inputFilePath, {encoding: "utf8"});

fs.writeFileSync(outputFilePath, fileContent);
