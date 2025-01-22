/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        "./**/*.{html,xhtml,js}",
        "!./node_modules/**/*", // Explicitly exclude node_modules
    ],
    theme: {
        extend: {},
    },
    corePlugins: {
        // preflight: false, // Disable base resets
    },
    plugins: [],
};
