const tailwindcss = require("tailwindcss");
const tailwindcssNesting = require("tailwindcss/nesting");
// import cssnano from 'cssnano'; // Uncomment if needed

//INFO: plugins for using the functionalities like tailwindcss, nesting etc.
module.exports = {
    plugins: [tailwindcssNesting, tailwindcss],
};
