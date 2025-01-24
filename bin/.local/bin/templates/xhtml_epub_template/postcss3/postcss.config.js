const rgbaToHex = require("postcss-rgba-hex");
const discardEmpty = require("postcss-discard-empty");
const removeBlankLines = require("./removeBlankLines");

//INFO: plugins for 2nd(final) line of processing. [Dependent on 1st line of processing]
module.exports = {
    plugins: [rgbaToHex, discardEmpty, removeBlankLines],
};
