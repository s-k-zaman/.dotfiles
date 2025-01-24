const autoprefixer = require("autoprefixer");
const tailwindcss = require("tailwindcss");
const tailwindcssNesting = require("tailwindcss/nesting");
const postcssPrettify = require("postcss-prettify");
const postcssImport = require("postcss-import");

//INFO: plugins for using the functionalities like tailwindcss, nesting etc.
module.exports = {
    plugins: [
        postcssImport,
        tailwindcssNesting,
        tailwindcss,
        autoprefixer,
        postcssPrettify,
    ],
};
