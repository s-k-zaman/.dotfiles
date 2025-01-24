const cssByebye = require("css-byebye");
const postcssPresetEnv = require("postcss-preset-env");
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
        postcssPresetEnv({
            features: {
                "color-function": false, // Disable color-function (we don't need this here)
                "custom-properties": false, // Disable custom-properties if not needed
            },
        }),
    ],
};
