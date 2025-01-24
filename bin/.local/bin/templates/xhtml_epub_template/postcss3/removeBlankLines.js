const removeBlankLines = () => {
    return {
        postcssPlugin: "remove-blank-lines",
        Once(root) {
            root.walk((node) => {
                // Clean blank lines in the raw `before` property
                if (node.raws.before) {
                    node.raws.before = node.raws.before.replace(
                        /^\s*\n+/gm,
                        "\n",
                    );
                }
                // Ensure a proper newline at the end of the node
                if (node.raws.after) {
                    node.raws.after = node.raws.after.replace(
                        /^\s*\n+/gm,
                        "\n",
                    );
                }
            });
        },
    };
};
removeBlankLines.postcss = true;

module.exports = removeBlankLines;
