const autoprefixer = require("autoprefixer");
const rgbaToHex = require("postcss-rgba-hex");
const postcssPresetEnv = require("postcss-preset-env");

//INFO: plugins for 2nd(final) line of processing. [Dependent on 1st line of processing]
module.exports = {
    plugins: [
        rgbaToHex,
        autoprefixer,
        postcssPresetEnv({
            features: {
                "color-function": false, // Disable color-function (we don't need this here)
                "custom-properties": false, // Disable custom-properties if not needed
            },
        }),
    ],
};
