const cssByebye = require("css-byebye");
const postcssCssVariables = require("postcss-css-variables");

//INFO: plugins for 1st line of processing.
module.exports = {
    plugins: [
        postcssCssVariables, // Need to run first
        cssByebye({
            rulesToRemove: [
                /[\\\[]/, // Match any selector containing '\' or '['
            ],
            map: false,
        }),
    ],
};
